import 'package:flutter/material.dart';

class CalculateButton extends StatelessWidget {
  const CalculateButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white60,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        elevation: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          'ANALYZE',
          style: TextTheme.of(context).titleLarge?.copyWith(fontSize: 15),
        ),
      ),
    );
  }
}
