import 'package:flutter/material.dart';

class AgeWeightCard extends StatelessWidget {
  const AgeWeightCard({super.key, required this.child, required this.title});

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: TextTheme.of(
              context,
            ).titleMedium?.copyWith(letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
