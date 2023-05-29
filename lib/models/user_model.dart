import 'dart:convert';

class UserModel {
  String? id;
  String userName;
  String email;
  String uid;
  UserModel({
    required this.userName,
    required this.email,
    required this.uid,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {'userName': userName, 'email': email, 'uid': uid};
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      userName: map['userName'],
      email: map['email'],
      uid: map['uid'],
      id: id,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Level( userName: $userName,email:$email,uid:$uid)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.userName == userName &&
        other.email == email &&
        other.uid == uid;
  }

  @override
  int get hashCode => userName.hashCode ^ email.hashCode ^ uid.hashCode;
}
