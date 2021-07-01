import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';

class FireStoreUser {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('User');
  Future<UserModel> add(UserModel userModel) async {
    var response = await _userCollection.add(userModel.toMap());
    userModel.id = response.id;
    return userModel;
  }

  Future<void> delete(String id) async {
    await _userCollection.doc(id).delete();
  }

  Future<List<UserModel>> getAllUser() async {
    var response = await _userCollection.get();
    List<UserModel> users = [];
    for (var item in response.docs) {
      users.add(UserModel.fromMap(item.data(), item.id));
    }
    return users;
  }

  Future<UserModel> getUserById(String userId) async {
    var response = await _userCollection.where('uId', isEqualTo: userId).get();

    if (response.docs.isNotEmpty) {
      UserModel user =
          UserModel.fromMap(response.docs[0].data(), response.docs[0].id);

      return user;
    }
    return null;
  }
}
