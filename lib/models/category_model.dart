import 'dart:convert';

class CategoryModel {
  String? id;
  String name;
  String image;
  CategoryModel({
    this.id,
    required this.name,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory CategoryModel.fromJson(String source) =>
  //     CategoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'Category( name: $name,image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel && other.name == name && other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ image.hashCode;
}
