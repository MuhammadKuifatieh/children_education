import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/category_model.dart';
import '../services/firestore_category.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories;
  List<CategoryModel> get categories => [..._categories];

  Future<void> getAllCategory() async {
    print('hi');
    _categories = await FireStoreCategory().getAllCategory();
    notifyListeners();
  }

  Future<void> add(CategoryModel category) async {
    category = await FireStoreCategory().add(category);
    print(category);
    _categories.add(
      CategoryModel(
        id: category.id,
        image: category.image,
        name: category.name,
      ),
    );
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await FireStoreCategory().delete(id);
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i].id == id) _categories.removeAt(i);
    }
    notifyListeners();
  }
}
