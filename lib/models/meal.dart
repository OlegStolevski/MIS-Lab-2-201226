class MealSummary {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String? category;

  const MealSummary({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    this.category,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbnailUrl: json['strMealThumb'] as String,
      category: json['strCategory'] as String?,
    );
  }
}

class Ingredient {
  final String name;
  final String measure;

  const Ingredient({
    required this.name,
    required this.measure,
  });
}

class MealDetail {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String instructions;
  final String youtubeUrl;
  final List<Ingredient> ingredients;

  const MealDetail({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.instructions,
    required this.youtubeUrl,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final List<Ingredient> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final String? ing = json['strIngredient$i'] as String?;
      final String? meas = json['strMeasure$i'] as String?;
      if (ing != null && ing.trim().isNotEmpty) {
        ingredients.add(
          Ingredient(
            name: ing.trim(),
            measure: (meas ?? '').trim(),
          ),
        );
      }
    }

    return MealDetail(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbnailUrl: json['strMealThumb'] as String,
      instructions: json['strInstructions'] as String? ?? '',
      youtubeUrl: json['strYoutube'] as String? ?? '',
      ingredients: ingredients,
    );
  }
}
