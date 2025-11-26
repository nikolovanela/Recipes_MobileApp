import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';
import 'screens/random_meal_screen.dart';

void main() {
  runApp(MealApp());
}

class MealApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meal App',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: CategoriesScreen(),
    );
  }
}
