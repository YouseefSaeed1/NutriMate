import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../model/api.dart';
import '../widgets/result widgets/result_buttons.dart';
import '../widgets/result widgets/result_column.dart';
import '../widgets/scanner_action_button.dart';
import '../widgets/screens_cover.dart';

class FoodScannerScreen extends StatefulWidget {
  const FoodScannerScreen({super.key});

  @override
  State<FoodScannerScreen> createState() => _FoodScannerScreenState();
}

class _FoodScannerScreenState extends State<FoodScannerScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;
  ImageLabeler? _imageLabeler;
  String _mealName = '';
  String _mealCalories = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    _imageLabeler?.close();
    super.dispose();
  }

  Future<void> _loadModel() async {
    final modelPath = await _getModelPath('assets/ml/foodModel.tflite');
    final options = LocalLabelerOptions(
      confidenceThreshold: 0.5,
      modelPath: modelPath,
    );
    _imageLabeler = ImageLabeler(options: options);
  }

  Future<String> _getModelPath(String asset) async {
    final path = p.join((await getApplicationSupportDirectory()).path, asset);
    await Directory(p.dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
    }
    return file.path;
  }

  Future<void> _processImage() async {
    if (_image == null || _imageLabeler == null) return;

    setState(() => _isLoading = true);

    final inputImage = InputImage.fromFile(_image!);
    final List<ImageLabel> labels = await _imageLabeler!.processImage(
      inputImage,
    );
    if (labels.isNotEmpty) {
      _mealName = labels.first.label;
      await _fetchCalories();
    } else {
      _mealName = '';
      _mealCalories = '';
    }

    setState(() => _isLoading = false);
  }

  Future<void> _fetchCalories() async {
    final double? calories = await FoodApi.getCalories(_mealName);
    _mealCalories = calories != null ? calories.toStringAsFixed(1) : '';
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _imagePicker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _image = File(selectedImage.path);
      });
      await _processImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreensCover(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    'Food Scanner',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Card(
                    color: Colors.grey.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3,
                      child: _image == null
                          ? const Icon(
                              Icons.image_outlined,
                              size: 150,
                              color: Colors.white24,
                            )
                          : Image.file(_image!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      scannerActionButton(
                        icon: Icons.photo_library,
                        onTap: () => _pickImage(ImageSource.gallery),
                      ),
                      const SizedBox(height: 30),
                      scannerActionButton(
                        icon: Icons.camera_alt,
                        onTap: () => _pickImage(ImageSource.camera),
                      ),
                    ],
                  ),
                ],
              ),
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.greenAccent)
              else
                Column(
                  children: [
                    ResultColumn(title: 'Meal Name', value: _mealName),
                    const SizedBox(height: 20),
                    ResultColumn(
                      title: 'Calories (per 100g)',
                      value: _mealCalories,
                    ),
                  ],
                ),
              ResultButtons(
                iconData: Icons.arrow_back,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
