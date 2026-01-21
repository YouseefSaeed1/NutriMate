import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';

class HeightCard extends StatelessWidget {
  const HeightCard({
    super.key,
    required this.height,
    required this.rulerPickerController,
    required this.onValueChanged,
  });

  final num height;
  final RulerPickerController rulerPickerController;
  final ValueChanged<num> onValueChanged;
  final List<RulerRange> ranges = const [
    RulerRange(begin: 100, end: 200, scale: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            'HEIGHT (cm)',
            style: TextTheme.of(
              context,
            ).titleMedium?.copyWith(letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Text(
            height.toString(),
            style: TextTheme.of(context).titleLarge?.copyWith(fontSize: 48),
          ),
          const SizedBox(height: 15),
          RulerPicker(
            controller: rulerPickerController,
            onValueChanged: onValueChanged,
            height: 80,
            width: 280,
            rulerBackgroundColor: Colors.transparent,
            onBuildRulerScaleText: (index, value) => value.toInt().toString(),
            ranges: ranges,
            marker: Container(
              width: 4,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            rulerMarginTop: 12,
            rulerScaleTextStyle: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
