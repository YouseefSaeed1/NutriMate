import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Meal {
  Meal({
    required this.name,
    required this.calories,
    required this.time,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String name;
  final double calories;
  final DateTime time;
}
