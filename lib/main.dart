import 'package:flutter/material.dart';
import 'screens/category_list_screen.dart';

void main() {
  runApp(const MealApp());
}

class MealApp extends StatelessWidget {
  const MealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheMealDB рецепти',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF8BC34A),
        useMaterial3: true,
      ),
      home: const CategoryListScreen(),
    );
  }
}
