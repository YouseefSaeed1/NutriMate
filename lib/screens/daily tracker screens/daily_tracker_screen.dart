import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/meals_provider.dart';
import '../../widgets/calories_hero_text.dart';
import '../../widgets/tracker widgets/add_meal_dialog.dart';
import '../../widgets/tracker widgets/edit_goal_dialog.dart';
import '../../widgets/tracker widgets/meal_card.dart';
import '../../widgets/transition/page_slide_transition.dart';
import 'history_screen.dart';

class DailyTrackerScreen extends ConsumerStatefulWidget {
  const DailyTrackerScreen({super.key, required this.calories, this.date});

  final double calories;
  final DateTime? date;

  @override
  ConsumerState<DailyTrackerScreen> createState() => _DailyTrackerScreenState();
}

class _DailyTrackerScreenState extends ConsumerState<DailyTrackerScreen> {
  late DateTime _displayDate;
  late double _currentGoal;

  @override
  void initState() {
    super.initState();
    _displayDate = widget.date ?? DateTime.now();
    _currentGoal = widget.calories;
    ref.read(mealsProvider.notifier).loadMealsForDate(_displayDate);
  }

  void _showAddMealDialog() {
    showDialog(
      context: context,
      builder: (_) => AddMealDialog(
        onSave: (name, calories) {
          ref
              .read(mealsProvider.notifier)
              .addMeal(name: name, calories: calories);
        },
      ),
    );
  }

  void _showEditGoalDialog() {
    showDialog(
      context: context,
      builder: (_) => EditGoalDialog(
        currentGoal: _currentGoal,
        onUpdate: (newGoal) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setDouble('calories', newGoal);

          setState(() => _currentGoal = newGoal);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final totalCalories = meals.fold<double>(
      0,
      (sum, meal) => sum + meal.calories,
    );
    bool isNormal = totalCalories <= _currentGoal;

    final now = DateTime.now();
    final isToday =
        _displayDate.year == now.year &&
        _displayDate.month == now.month &&
        _displayDate.day == now.day;

    final titleText = isToday
        ? "TODAY"
        : DateFormat('MMMM dd, yyyy').format(_displayDate);

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          titleText,
          style: const TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (isToday)
            IconButton(
              onPressed: _showAddMealDialog,
              icon: const Icon(Icons.add, color: Colors.white60),
            ),
        ],
        leading: isToday
            ? IconButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    PageSlideTransition(
                      page: const HistoryScreen(),
                      left: true,
                    ),
                  );
                  if (mounted) {
                    ref
                        .read(mealsProvider.notifier)
                        .loadMealsForDate(DateTime.now());
                  }
                },
                icon: const Icon(Icons.history, color: Colors.white60),
              )
            : IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white60),
              ),
      ),
      body: Column(
        children: [
          Expanded(
            child: meals.isEmpty
                ? Center(
                    child: Text(
                      'No meals added today. Add one!',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (ctx, index) {
                      final meal = meals[index];
                      return isToday
                          ? Dismissible(
                              key: ValueKey(meal.id),
                              onDismissed: (_) => ref
                                  .read(mealsProvider.notifier)
                                  .deleteMeal(meal.id),
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20.0),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              child: MealCard(meal: meal),
                            )
                          : MealCard(meal: meal);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: CaloriesHeroText(
                calories: totalCalories,
                goal: _currentGoal,
                isNormal: isNormal,
                isToday: isToday,
                onGoalTap: _showEditGoalDialog,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
