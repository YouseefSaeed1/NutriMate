import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nutrimate/database/database.dart';
import 'package:nutrimate/model/meal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyHistory {
  final DateTime date;
  final double totalCalories;
  DailyHistory({required this.date, required this.totalCalories});
}

class MealsNotifier extends StateNotifier<List<Meal>> {
  MealsNotifier() : super(const []);

  Meal _fromMap(Map<String, dynamic> row) {
    return Meal(
      id: row['id'] as String,
      name: row['name'] as String,
      calories: double.parse(row['calories'] as String),
      time: DateTime.parse(row['time'] as String),
    );
  }

  Future<void> loadMealsForDate(DateTime time) async {
    final db = await getDatabase();
    final data = await db.query('meals');
    final allMeals = data.map(_fromMap).toList();

    final filteredMeals = allMeals.where((meal) {
      return meal.time.year == time.year &&
          meal.time.month == time.month &&
          meal.time.day == time.day;
    }).toList();

    state = filteredMeals;

    final now = DateTime.now();
    final todayTotal = allMeals
        .where(
          (meal) =>
              meal.time.year == now.year &&
              meal.time.month == now.month &&
              meal.time.day == now.day,
        )
        .fold<double>(0, (sum, meal) => sum + meal.calories);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('todayCalories', todayTotal);
  }

  Future<void> addMeal({required String name, required double calories}) async {
    final now = DateTime.now();
    final newMeal = Meal(name: name, calories: calories, time: now);

    final newMealData = {
      'id': newMeal.id,
      'name': newMeal.name,
      'calories': newMeal.calories.toString(),
      'time': newMeal.time.toIso8601String(),
    };

    final db = await getDatabase();
    await db.insert('meals', newMealData);

    await loadMealsForDate(now);
  }

  Future<void> deleteMeal(String id) async {
    final db = await getDatabase();
    await db.delete('meals', where: 'id = ?', whereArgs: [id]);
    await loadMealsForDate(DateTime.now());
  }
}

final mealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>(
  (ref) => MealsNotifier(),
);

final historyProvider = FutureProvider<List<DailyHistory>>((ref) async {
  final db = await getDatabase();
  final data = await db.query('meals', orderBy: 'time DESC');

  final Map<String, double> dailyTotals = {};
  final Map<String, DateTime> dates = {};

  final now = DateTime.now();
  final todayKey = "${now.year}-${now.month}-${now.day}";

  for (final row in data) {
    final time = DateTime.parse(row['time'] as String);
    final dateKey = "${time.year}-${time.month}-${time.day}";

    if (dateKey == todayKey) continue;

    dailyTotals[dateKey] =
        (dailyTotals[dateKey] ?? 0) + double.parse(row['calories'] as String);
    dates[dateKey] = DateTime(time.year, time.month, time.day);
  }

  return dailyTotals.keys.map((key) {
    return DailyHistory(date: dates[key]!, totalCalories: dailyTotals[key]!);
  }).toList();
});
