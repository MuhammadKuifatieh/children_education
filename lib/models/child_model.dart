import 'dart:convert';

import 'package:flutter/material.dart';

class ChildModel {
  String id;
  String name;
  String age;
  String gender;
  String userId;
  ChildModel({
    this.id,
    @required this.name,
    @required this.age,
    @required this.gender,
    @required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'userId': userId,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map, String id) {
    return ChildModel(
      id: id,
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      userId: map['userId'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory ChildModel.fromJson(String source) =>
  //     ChildModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'Type(name: $name, age: $age,gender: $gender, userId: $userId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChildModel &&
        other.name == name &&
        other.age == age &&
        other.gender == gender &&
        other.userId == userId;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      age.hashCode ^
      gender.hashCode ^
      userId.hashCode;
}
