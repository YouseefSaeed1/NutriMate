import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/meals_provider.dart';
import '../widgets/calories_hero_text.dart';
import '../widgets/home widgets/category_card.dart';
import '../widgets/transition/page_fade_transition.dart';
import 'calculate screens/health_calculator_screen.dart';
import 'daily tracker screens/daily_tracker_screen.dart';
import 'food_scanner_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double _calorieGoal = 0;
  double _todayCalories = 0;

  Future<void> _refreshData() async {
    await ref.read(mealsProvider.notifier).loadMealsForDate(DateTime.now());
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _calorieGoal = prefs.getDouble('calories') ?? 2000;
      _todayCalories = prefs.getDouble('todayCalories') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    bool isNormal = _todayCalories <= _calorieGoal;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/covers/home_cover.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'NutriMate',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Pacifico',
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 30),
                CategoryCard(
                  height: 200,
                  onTap: () async {
                    await Navigator.of(context).push(
                      PageFadeTransition(
                        page: DailyTrackerScreen(calories: _calorieGoal),
                      ),
                    );
                    _refreshData();
                  },

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Today's Intake",
                        style: TextTheme.of(
                          context,
                        ).titleMedium?.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 15),
                      CaloriesHeroText(
                        calories: _todayCalories,
                        goal: _calorieGoal,
                        isNormal: isNormal,
                        isToday: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CategoryCard(
                        onTap: () {
                          Navigator.of(context).push(
                            PageFadeTransition(page: HealthCalculatorScreen()),
                          );
                        },

                        title: "Health Calculator",
                        iconData: Icons.monitor_weight_outlined,
                      ),
                    ),
                    Expanded(
                      child: CategoryCard(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(PageFadeTransition(page: FoodScannerScreen()));
                        },
                        title: "Food Scanner",
                        iconData: Icons.qr_code_scanner,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
