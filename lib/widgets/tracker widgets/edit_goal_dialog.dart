import 'package:flutter/material.dart';

class EditGoalDialog extends StatelessWidget {
  final double currentGoal;
  final ValueChanged<double> onUpdate;

  const EditGoalDialog({
    super.key,
    required this.currentGoal,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final goalController = TextEditingController(
      text: currentGoal.toStringAsFixed(0),
    );

    return AlertDialog(
      backgroundColor: Colors.grey.shade800,
      title: const Text(
        'Edit Daily Goal',
        style: TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: goalController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          labelText: 'Target Calories',
          labelStyle: TextStyle(color: Colors.white70),
        ),
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: () {
            final newGoal = double.tryParse(goalController.text);
            if (newGoal != null && newGoal > 0) {
              onUpdate(newGoal);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
