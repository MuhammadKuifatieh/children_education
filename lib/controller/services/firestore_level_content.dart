import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/level_content_model.dart';

class FireStoreLevelContent {
  final CollectionReference _levelContentCollection =
      FirebaseFirestore.instance.collection('Level Content');
  Future<LevelContentModel> add(LevelContentModel levelContentModel) async {
    var response = await _levelContentCollection.add(levelContentModel.toMap());
    levelContentModel.id = response.id;
    return levelContentModel;
  }

  Future<void> delete(String id) async {
    await _levelContentCollection.doc(id).delete();
  }

  Future<List<LevelContentModel>> getAllContaintToLevel(
      String categoryLevelId) async {
        print(categoryLevelId);
    var response = await _levelContentCollection
        .where('categoryLevelId', isEqualTo: categoryLevelId)
        .get();
    List<LevelContentModel> levelContent = [];
    for (var item in response.docs) {
      levelContent.add(LevelContentModel.fromMap(item.data(), item.id));
    }
    return levelContent;
  }
}
