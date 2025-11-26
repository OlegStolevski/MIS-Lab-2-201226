class MealCategory {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String description;

  const MealCategory({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.description,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      id: json['idCategory'] as String,
      name: json['strCategory'] as String,
      thumbnailUrl: json['strCategoryThumb'] as String,
      description: json['strCategoryDescription'] as String,
    );
  }
}
