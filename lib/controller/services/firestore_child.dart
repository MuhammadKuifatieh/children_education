import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/child_model.dart';

class FireStoreChild {
  final CollectionReference _childCollection =
      FirebaseFirestore.instance.collection('Child');
  Future<ChildModel> add(ChildModel childModel) async {
    var response = await _childCollection.add(childModel.toMap());
    childModel.id = response.id;
    return childModel;
  }

  Future<void> delete(String id) async {
    await _childCollection.doc(id).delete();
  }

  Future<ChildModel> get() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString('userId');
    var response = await _childCollection.where('userId', isEqualTo: userId).get();
    ChildModel child =
        ChildModel.fromMap(response.docs[0].data(), response.docs[0].id);
    return child;
  }
}
