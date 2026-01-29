import 'package:flutter/material.dart';

class CaloriesHeroText extends StatelessWidget {
  final double calories;
  final double? goal;
  final bool isNormal;
  final bool isToday;
  final VoidCallback? onGoalTap;

  const CaloriesHeroText({
    super.key,
    required this.calories,
    required this.isNormal,
    this.goal,
    this.isToday = false,
    this.onGoalTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = (!isToday || isNormal) ? Colors.white : Colors.red;

    return Hero(
      tag: 'calories',
      child: Material(
        color: Colors.transparent,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: calories.toStringAsFixed(0),
                style: TextStyle(
                  color: color,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (isToday)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: isToday ? onGoalTap : null,
                    child: Text(
                      " / ${goal!.toStringAsFixed(0)} kcal",
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                  ),
                )
              else
                const TextSpan(
                  text: " kcal",
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
