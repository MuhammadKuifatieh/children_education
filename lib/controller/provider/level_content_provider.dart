import 'package:flutter/material.dart';

import '../../models/level_content_model.dart';
import '../services/firestore_level_content.dart';

class LevelContentProvider with ChangeNotifier {
  List<LevelContentModel> _levelContents = [];
  List<LevelContentModel> get levelContents {
    return [..._levelContents];
  }

  Future<void> getAllContentsToLevel(String categoryLevelId) async {
    List<LevelContentModel> newLevelContent =
        await FireStoreLevelContent().getAllContaintToLevel(categoryLevelId);
    _levelContents = newLevelContent;
    notifyListeners();
  }

  Future<void> add(LevelContentModel levelContent) async {
    levelContent = await FireStoreLevelContent().add(levelContent);
    _levelContents.add(LevelContentModel(
      id: levelContent.id,
      categoryLevelId: levelContent.categoryLevelId,
      content: levelContent.content,
      type: levelContent.type,
    ));
    notifyListeners();
  }
   Future<void> delete(String id) async {
    await FireStoreLevelContent().delete(id);
    for (int i=0;i< _levelContents.length;i++) {
      if (_levelContents[i].id == id) _levelContents.removeAt(i);
    }
    notifyListeners();
  }
}
