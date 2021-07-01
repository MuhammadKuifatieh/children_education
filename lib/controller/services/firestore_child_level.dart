import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/child_level_model.dart';

class FireStoreChildLevel {
  final CollectionReference _childLevelCollection =
      FirebaseFirestore.instance.collection('childLevel');
  Future<ChildLevelModel> add(ChildLevelModel childLevelModel) async {
    var response = await _childLevelCollection.add(childLevelModel.toMap());
    childLevelModel.id = response.id;
    return childLevelModel;
  }

  Future<void> delete(String id) async {
    await _childLevelCollection.doc(id).delete();
  }

  Future<ChildLevelModel> getById(String categoryLevelId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString('userId');
    var response = await _childLevelCollection
        .where('categoryLevelId', isEqualTo: categoryLevelId)
        .where('userId', isEqualTo: userId)
        .get();
    ChildLevelModel childLevel;
    if (response.docs.isNotEmpty) {
      childLevel =
          ChildLevelModel.fromMap(response.docs[0].data(), response.docs[0].id);
    } else {
      childLevel = await add(ChildLevelModel(
          categoryLevelId: categoryLevelId,
          isWath: false,
          isEnd: false,
          userId: userId));
    }
    return childLevel;
  }

  Future<List<ChildLevelModel>> getAllChildLevel() async {
    var response = await _childLevelCollection.get();
    List<ChildLevelModel> childLevels = [];
    for (var item in response.docs) {
      childLevels.add(ChildLevelModel.fromMap(item.data(), item.id));
    }
    return childLevels;
  }

  Future update(ChildLevelModel childLevelModel) async {
    await _childLevelCollection.doc(childLevelModel.id).update({
      'isWatch': childLevelModel.isWath,
      'isEnd': childLevelModel.isEnd,
    });
    return;
  }
}
