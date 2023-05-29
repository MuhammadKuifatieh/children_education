import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/category_model.dart';

class FireStoreCategory {
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('category');
  Future<CategoryModel> add(CategoryModel categoryModel) async {
    var response = await _categoryCollection.add(categoryModel.toMap());
    categoryModel.id = response.id;
    return categoryModel;
  }

  Future<void> delete(String id) async {
    await _categoryCollection.doc(id).delete();
  }

  Future<List<CategoryModel>> getAllCategory() async {
    var response = await _categoryCollection.get();
    List<CategoryModel> categories = [];
    for (var item in response.docs) {
      categories.add(CategoryModel.fromMap(item.data()as Map<String, dynamic>, item.id));
    }
    return categories;
  }
}
