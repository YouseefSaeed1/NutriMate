import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrimate/screens/home_screen.dart';

final theme = ThemeData(
  useMaterial3: true,
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white70,
    ),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  ),
);
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NutriMateApp()));
}

class NutriMateApp extends StatelessWidget {
  const NutriMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const HomeScreen(),
    );
  }
}
