import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/level_model.dart';

class FireStoreLevel {
  final CollectionReference _levelCollection =
      FirebaseFirestore.instance.collection('Level');
  Future<LevelModel> add(LevelModel levelModel) async {
    var response = await _levelCollection.add(levelModel.toMap());
    levelModel.id = response.id;
    return levelModel;
  }

  Future<void> delete(String id) async {
    await _levelCollection.doc(id).delete();
  }

  Future<List<LevelModel>> getAllLevel() async {
    var response = await _levelCollection.get();
    List<LevelModel> levels = [];
    for (var item in response.docs) {
      levels.add(
          LevelModel.fromMap(item.data() as Map<String, dynamic>, item.id));
    }
    return levels;
  }

  Future<LevelModel?> getLevelById(String levelId) async {
    var response = await _levelCollection.get();
    LevelModel? level;
    for (var item in response.docs)
      if (item.id == levelId) {
        level =
            LevelModel.fromMap(item.data() as Map<String, dynamic>, item.id);
      }
    return level;
  }
}
