import 'package:flutter/material.dart';
import 'package:nutrimate/widgets/transition/page_fade_transition.dart';

import '../../screens/home_screen.dart';

class SetGoalDialog extends StatelessWidget {
  final double bmr;
  final VoidCallback onSetGoal;

  const SetGoalDialog({super.key, required this.bmr, required this.onSetGoal});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Update Goal?', style: TextStyle(color: Colors.white)),
      content: Text(
        'Would you like to set ${bmr.toStringAsFixed(0)} kcal as your new daily calorie goal?',
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushAndRemoveUntil(
              PageFadeTransition(page: const HomeScreen()),
              (route) => false,
            );
          },
          child: const Text(
            'Maybe Later',
            style: TextStyle(color: Colors.white38),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onSetGoal();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            foregroundColor: Colors.black,
          ),
          child: const Text('Set Goal'),
        ),
      ],
    );
  }
}
