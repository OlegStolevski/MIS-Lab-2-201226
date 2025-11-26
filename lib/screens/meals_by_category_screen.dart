import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_api_service.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;

  const MealsByCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  late Future<List<MealSummary>> _mealsFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mealsFuture = MealApiService.fetchMealsByCategory(widget.category);
  }

  void _searchMeals() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        _mealsFuture = MealApiService.fetchMealsByCategory(widget.category);
      } else {
        _mealsFuture =
            MealApiService.searchMealsInCategory(widget.category, query);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Пребарај јадења во ${widget.category}...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchMeals,
                ),
              ),
              onSubmitted: (_) => _searchMeals(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MealSummary>>(
              future: _mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Грешка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Нема јадења.'));
                }

                final meals = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return MealGridItem(
                      meal: meal,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MealDetailScreen(mealId: meal.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
