import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_api_service.dart';

class RandomMealScreen extends StatefulWidget {
  const RandomMealScreen({super.key});

  @override
  State<RandomMealScreen> createState() => _RandomMealScreenState();
}

class _RandomMealScreenState extends State<RandomMealScreen> {
  late Future<MealDetail> _randomMealFuture;

  @override
  void initState() {
    super.initState();
    _randomMealFuture = MealApiService.fetchRandomMeal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рандом рецепт на денот'),
      ),
      body: FutureBuilder<MealDetail>(
        future: _randomMealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Грешка: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Нема податоци.'));
          }

          final meal = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(meal.thumbnailUrl),
                ),
                const SizedBox(height: 16),
                Text(
                  meal.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Состојки:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...meal.ingredients.map(
                  (ing) => Text('• ${ing.measure} ${ing.name}'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Инструкции:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(meal.instructions),
                if (meal.youtubeUrl.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'YouTube линк:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    meal.youtubeUrl,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
