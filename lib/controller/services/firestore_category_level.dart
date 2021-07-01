import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_level.dart';
import '../../models/category_level_model.dart';
import '../../models/level_model.dart';

class FireStoreCategoryLevel {
  final CollectionReference _categoryLevelCollection =
      FirebaseFirestore.instance.collection('Category Level');
  Future<CategoryLevelModel> add(String categoryId) async {
    List<LevelModel> levels = await FireStoreLevel().getAllLevel();

    List<CategoryLevelModel> categorylevels =
        await getAllLevelforCategory(categoryId);
    if (categorylevels.length + 1 < levels.length) {
      print(categorylevels);
      LevelModel newLevel =
          await FireStoreLevel().getLevelById('Qq2YjuvraN0D8kaT7s5C');
      for (var categorylevel in categorylevels) {
        LevelModel level =
            await FireStoreLevel().getLevelById(categorylevel.levelId);
        if (level.number > newLevel.number) newLevel = level;
      }
      for (var level in levels)
        if (level.number == newLevel.number + 1) {
          newLevel = level;
          break;
        }
      CategoryLevelModel categoryLevelModel =
          CategoryLevelModel(categoryId: categoryId, levelId: newLevel.id);
      var response =
          await _categoryLevelCollection.add(categoryLevelModel.toMap());
      categoryLevelModel.id= response.id;
      return categoryLevelModel;
    }
  }
  Future<void> delete(String id) async {
    await _categoryLevelCollection.doc(id).delete();
  }

  Future<List<CategoryLevelModel>> getAllCategoryLevel() async {
    var response = await _categoryLevelCollection.get();

    List<CategoryLevelModel> categorylevels = [];
    for (var item in response.docs) {
      categorylevels.add(CategoryLevelModel.fromMap(item.data(), item.id));
    }
    return categorylevels;
  }

  Future<List<CategoryLevelModel>> getAllLevelforCategory(
      String categoryId) async {
    var response = await _categoryLevelCollection
        .where('categoryId', isEqualTo: categoryId)
        .get();
    List<CategoryLevelModel> categorylevels = [];
    for (var item in response.docs) {
      categorylevels.add(CategoryLevelModel.fromMap(item.data(), item.id));
    }
    return categorylevels;
  }
}
