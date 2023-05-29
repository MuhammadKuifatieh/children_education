import 'dart:convert';

class CategoryLevelModel {
  String? id;
  String categoryId;
  String levelId;

  CategoryLevelModel({
    required this.categoryId,
    required this.levelId,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'levelId': levelId,
    };
  }

  factory CategoryLevelModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryLevelModel(
      categoryId: map['categoryId'],
      levelId: map['levelId'],
      id: id,
    );
  }

  String toJson() => json.encode(toMap());

  // factory CategoryLevelModel.fromJson(String source) =>
  //     CategoryLevelModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'Category Level( categoryId: $categoryId ,levelId: $levelId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryLevelModel &&
        other.categoryId == categoryId &&
        other.levelId == levelId;
  }

  @override
  int get hashCode => categoryId.hashCode ^ levelId.hashCode;
}
