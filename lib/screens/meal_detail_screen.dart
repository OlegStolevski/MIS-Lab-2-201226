import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_api_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({
    super.key,
    required this.mealId,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late Future<MealDetail> _mealFuture;

  @override
  void initState() {
    super.initState();
    _mealFuture = MealApiService.fetchMealDetail(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детален рецепт'),
      ),
      body: FutureBuilder<MealDetail>(
        future: _mealFuture,
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
