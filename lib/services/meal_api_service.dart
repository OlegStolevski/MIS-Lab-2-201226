import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';

class MealApiService {
  static const String _baseUrl = 'www.themealdb.com';

  /// 1) Сите категории
  static Future<List<MealCategory>> fetchCategories() async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/categories.php');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Грешка при вчитување категории');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> list = data['categories'] as List<dynamic>;
    return list.map((e) => MealCategory.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// 2) Јадења по категорија
  static Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/filter.php', {'c': category});
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Грешка при вчитување јадења');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> list = data['meals'] as List<dynamic>;
    return list.map((e) => MealSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// 3) Пребарување јадења по query, но филтрирано по избрана категорија
  static Future<List<MealSummary>> searchMealsInCategory(
      String category, String query) async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/search.php', {'s': query});
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Грешка при пребарување јадења');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data['meals'] == null) {
      return [];
    }
    final List<dynamic> list = data['meals'] as List<dynamic>;

    final allMeals = list
        .map((e) => MealSummary.fromJson(e as Map<String, dynamic>))
        .toList();

    // задржи само оние од избраната категорија
    return allMeals.where((m) => m.category == category).toList();
  }

  /// 4) Детали за јадење по ID
  static Future<MealDetail> fetchMealDetail(String id) async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/lookup.php', {'i': id});
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Грешка при вчитување детали за рецепт');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> list = data['meals'] as List<dynamic>;
    return MealDetail.fromJson(list.first as Map<String, dynamic>);
  }

  /// 5) Рандом рецепт
  static Future<MealDetail> fetchRandomMeal() async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/1/random.php');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Грешка при вчитување рандом рецепт');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> list = data['meals'] as List<dynamic>;
    return MealDetail.fromJson(list.first as Map<String, dynamic>);
  }
}
