import 'package:flutter/material.dart';

class AddMealDialog extends StatelessWidget {
  final void Function(String name, double calories) onSave;

  const AddMealDialog({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.grey.shade800,
      title: const Text('Add New Meal', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: caloriesController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Calories',
              labelStyle: TextStyle(color: Colors.white70),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final calories = double.tryParse(caloriesController.text);

            if (name.isNotEmpty && calories != null && calories > 0) {
              onSave(name, calories);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
