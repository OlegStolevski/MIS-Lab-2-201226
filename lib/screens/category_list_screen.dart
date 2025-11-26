import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/meal_api_service.dart';
import '../widgets/category_card.dart';
import 'meals_by_category_screen.dart';
import 'random_meal_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  late Future<List<MealCategory>> _categoriesFuture;
  List<MealCategory> _allCategories = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _categoriesFuture = MealApiService.fetchCategories();
  }

  List<MealCategory> _filterCategories(List<MealCategory> categories) {
    if (_searchQuery.isEmpty) return categories;
    return categories
        .where((c) =>
            c.name.toLowerCase().contains(_searchQuery.toLowerCase().trim()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории на јадења'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Рандом рецепт на денот',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RandomMealScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Пребарај категории...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MealCategory>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Грешка: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Нема категории.'));
                }

                _allCategories = snapshot.data!;
                final filtered = _filterCategories(_allCategories);

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final category = filtered[index];
                    return CategoryCard(
                      category: category,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MealsByCategoryScreen(
                              category: category.name,
                            ),
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
