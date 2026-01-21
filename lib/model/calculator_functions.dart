import 'dart:math';
import 'package:flutter/material.dart';

enum Gender { male, female }

class BMIResult {
  const BMIResult({
    required this.category,
    required this.progress,
    required this.color,
  });

  final String category;
  final Color color;
  final double progress;
}

class HealthCalculator {
  static double calculateBMI(int height, int weight) {
    if (height <= 0 || weight <= 0) return 0;
    
    final double heightInMeters = height / 100;
    return weight / pow(heightInMeters, 2);
  }

  static BMIResult getBMIResult(double bmi) {
    if (bmi < 18.5) {
      return BMIResult(
        category: 'Underweight',
        color: Colors.blue.shade300,
        progress: 0.25,
      );
    } else if (bmi < 25) {
      return const BMIResult(
        category: 'Normal',
        color: Colors.green,
        progress: 0.5,
      );
    } else if (bmi < 30) {
      return BMIResult(
        category: 'Overweight',
        color: Colors.orange.shade400,
        progress: 0.75,
      );
    } else {
      return const BMIResult(
        category: 'Obese',
        color: Colors.red,
        progress: 1.0,
      );
    }
  }

  static double calculateBMR(int height, int weight, int age, Gender gender) {
    if (weight <= 0 || height <= 0 || age <= 0) return 0;

    if (gender == Gender.male) {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
  }

  static double calculateTDEE(double bmr) {
    if (bmr <= 0) return 0;
    return bmr * 1.55;
  }
}
