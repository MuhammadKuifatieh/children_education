import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/level_model.dart';
import '../services/firestore_level.dart';
import '../../models/category_level_model.dart';
import '../services/firestore_category_level.dart';
import '../../models/child_level_model.dart';
import '../services/firestore_child_level.dart';

class LevelProvider with ChangeNotifier {
  List<LevelModel> _levels = [];
  List<String> categoryLevelId = [];
  List<ChildLevelModel> _childLevels = [];

  List<LevelModel> get levels => [..._levels];

  List<ChildLevelModel> get childLevels => [..._childLevels];

  Future<void> getAllLevel(String categoryId) async {
    List<CategoryLevelModel> categoryLevels =
        await FireStoreCategoryLevel().getAllLevelforCategory(categoryId);
    List<LevelModel> newList = [];
    List<String> newStrList = [];
    for (var item in categoryLevels) {
      newStrList.add(item.id!);
      final resutl = await FireStoreLevel().getLevelById(item.levelId);
      if (resutl != null) newList.add(resutl);
    }
    for (int i = 0; i < newList.length; i++) {
      for (int j = 0; j < newList.length; j++) {
        if (newList[i].number < newList[j].number) {
          var swap = newList[i];
          newList[i] = newList[j];
          newList[j] = swap;
          var swap2 = newStrList[i];
          newStrList[i] = newStrList[j];
          newStrList[j] = swap2;
        }
      }
    }
    _levels = newList;
    categoryLevelId = newStrList;
    _childLevels = [];
    for (var item in categoryLevelId) {
      _childLevels.add(await FireStoreChildLevel().getById(item));
    }
    notifyListeners();
  }

  Future<void> add(String categoryId) async {
    CategoryLevelModel? categoryLevel =
        await FireStoreCategoryLevel().add(categoryId);
    if (null != categoryLevel) {
      categoryLevelId.add(categoryLevel.id!);
      final result = await FireStoreLevel().getLevelById(categoryLevel.levelId);
      if (result != null) _levels.add(result);
    }

    notifyListeners();
  }

  getCategoryLevelId(String levelId) {
    for (int i = 0; i < _levels.length; i++)
      if (_levels[i].id == levelId) return categoryLevelId[i];
  }

  Future<void> delete(String id) async {
    await FireStoreLevel().delete(id);
    for (int i = 0; i < _levels.length; i++) {
      if (_levels[i].id == id) _levels.removeAt(i);
    }
    notifyListeners();
  }

  updateChildLevel(String categorylevId, bool flag) {
    for (int i = 0; i < categoryLevelId.length; i++) {
      if (childLevels[i].categoryLevelId == categorylevId) {
        if (flag) {
          childLevels[i].isWath = true;
          FireStoreChildLevel().update(childLevels[i]);
        } else {
          childLevels[i].isEnd = true;
          FireStoreChildLevel().update(childLevels[i]);
        }
      }
    }
  }
}
