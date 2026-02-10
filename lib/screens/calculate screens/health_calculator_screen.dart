import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:nutrimate/screens/calculate%20screens/result_screen.dart';
import 'package:nutrimate/widgets/health calculator/age_weight_card.dart';

import '../../model/calculator_functions.dart';
import '../../widgets/health calculator/age_details_card.dart';
import '../../widgets/health calculator/calculate_button.dart';
import '../../widgets/health calculator/gender_card.dart';
import '../../widgets/health calculator/height_card.dart';
import '../../widgets/health calculator/wheel_selector.dart';
import '../../widgets/screens_cover.dart';
import '../../widgets/transition/page_slide_transition.dart';

class HealthCalculatorScreen extends StatefulWidget {
  const HealthCalculatorScreen({super.key});

  @override
  State<HealthCalculatorScreen> createState() => _HealthCalculatorScreenState();
}

class _HealthCalculatorScreenState extends State<HealthCalculatorScreen> {
  Gender _selectedGender = Gender.male;
  num _currentHeight = 170;
  int _currentWeight = 60;
  int _currentAge = 25;

  late final RulerPickerController _rulerPickerController;

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: _currentHeight);
  }

  void _analyzeData() {
    final double bmi = HealthCalculator.calculateBMI(
      _currentHeight.toInt(),
      _currentWeight,
    );
    final BMIResult bmiResult = HealthCalculator.getBMIResult(bmi);
    final double bmr = HealthCalculator.calculateBMR(
      _currentHeight.toInt(),
      _currentWeight,
      _currentAge,
      _selectedGender,
    );
    final double tdee = HealthCalculator.calculateTDEE(bmr);

    Navigator.of(context).push(
      PageSlideTransition(
        page: ResultScreen(
          bmi: bmi,
          bmr: bmr,
          tdee: tdee,
          bmiResult: bmiResult,
        ),
        left: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreensCover(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    'Health Calculator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GenderCard(
                              iconData: Icons.male,
                              title: 'Male',
                              isSelected: _selectedGender == Gender.male,
                              onTap: () =>
                                  setState(() => _selectedGender = Gender.male),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GenderCard(
                              iconData: Icons.female,
                              title: 'Female',
                              isSelected: _selectedGender == Gender.female,
                              onTap: () => setState(
                                () => _selectedGender = Gender.female,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      HeightCard(
                        height: _currentHeight,
                        rulerPickerController: _rulerPickerController,
                        onValueChanged: (num value) {
                          setState(() {
                            _currentHeight = value.toInt();
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: AgeWeightCard(
                              title: 'Weight',
                              child: WheelSelector(
                                value: _currentWeight,
                                min: 30,
                                max: 150,
                                onChanged: (newValue) =>
                                    setState(() => _currentWeight = newValue),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: AgeWeightCard(
                              title: 'Age',
                              child: AgeDetailsCard(
                                age: _currentAge,
                                minusFun: () => setState(() => _currentAge--),
                                plusFun: () => setState(() => _currentAge++),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  CalculateButton(onPressed: _analyzeData),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
