import 'package:flutter/material.dart';

class AgeDetailsCard extends StatelessWidget {
  const AgeDetailsCard({
    super.key,
    required this.age,
    required this.minusFun,
    required this.plusFun,
  });

  final int age;
  final VoidCallback minusFun;
  final VoidCallback plusFun;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ageActionButton(icon: Icons.remove_circle_outline, onTap: minusFun),
        const SizedBox(width: 15),
        Text(
          age.toString(),
          style: TextTheme.of(context).titleLarge?.copyWith(fontSize: 32),
        ),
        const SizedBox(width: 15),
        _ageActionButton(icon: Icons.add_circle_outline, onTap: plusFun),
      ],
    );
  }

  Widget _ageActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Icon(icon, size: 30, color: Colors.white70),
    );
  }
}
