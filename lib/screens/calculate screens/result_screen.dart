import 'package:flutter/material.dart';
import 'package:nutrimate/model/calculator_functions.dart';
import 'package:nutrimate/screens/home_screen.dart';
import 'package:nutrimate/widgets/result widgets/result_buttons.dart';
import 'package:nutrimate/widgets/result widgets/result_column.dart';
import 'package:nutrimate/widgets/screens_cover.dart';
import 'package:nutrimate/widgets/transition/page_fade_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/home widgets/set_goal_dialog.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.bmi,
    required this.bmr,
    required this.tdee,
    required this.bmiResult,
  });

  final double bmi;
  final double bmr;
  final double tdee;
  final BMIResult bmiResult;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _progressAnimation =
        Tween<double>(begin: 0.0, end: widget.bmiResult.progress).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.bounceInOut,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _setAsDefaultGoal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('calories', widget.bmr);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        PageFadeTransition(page: const HomeScreen()),
        (route) => false,
      );
    }
  }

  void _showSetGoalDialog() {
    showDialog(
      context: context,
      builder: (ctx) =>
          SetGoalDialog(bmr: widget.bmr, onSetGoal: _setAsDefaultGoal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreensCover(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 230,
                    height: 230,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 25,
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, _) {
                            return CircularProgressIndicator(
                              value: _progressAnimation.value,
                              strokeWidth: 25,
                              color: widget.bmiResult.color,
                              strokeCap: StrokeCap.round,
                            );
                          },
                        ),
                        Center(
                          child: Text(
                            widget.bmiResult.category,
                            style: TextTheme.of(
                              context,
                            ).titleLarge?.copyWith(fontSize: 28),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Your BMI is ',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        widget.bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 20,
                          color: widget.bmiResult.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  ResultColumn(
                    title: 'BMI',
                    value: widget.bmi.toStringAsFixed(1),
                    explanation: 'Body Mass Index.',
                  ),
                  const SizedBox(height: 15),
                  ResultColumn(
                    title: 'BMR',
                    value: widget.bmr.toStringAsFixed(1),
                    explanation: 'Basal Metabolic Rate .',
                  ),
                  const SizedBox(height: 15),
                  ResultColumn(
                    title: 'TDEE',
                    value: widget.tdee.toStringAsFixed(1),
                    explanation: 'Total Daily Energy Expenditure.',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResultButtons(
                    iconData: Icons.restart_alt,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 30),
                  ResultButtons(
                    iconData: Icons.arrow_right_alt,
                    onPressed: _showSetGoalDialog,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
