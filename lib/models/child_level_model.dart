import 'dart:convert';

import 'package:flutter/material.dart';

class ChildLevelModel {
  String id;
  String categoryLevelId;
  bool isWath;
  bool isEnd;
  String userId;
  ChildLevelModel({
    this.id,
    @required this.categoryLevelId,
    @required this.isWath,
    @required this.isEnd,
    @required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryLevelId': categoryLevelId,
      'isWath': isWath,
      'isEnd': isEnd,
      'userId': userId,
    };
  }

  factory ChildLevelModel.fromMap(Map<String, dynamic> map, String id) {
    return ChildLevelModel(
      id: id,
      categoryLevelId: map['categoryLevelId'],
      isWath: map['isWath'],
      isEnd: map['isEnd'],
      userId: map['userId'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory ChildLevelModel.fromJson(String source) =>
  //     ChildLevelModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'Question(categoryLevelId: $categoryLevelId, isWath: $isWath isEnd:$isEnd ,userId:$userId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChildLevelModel &&
        other.categoryLevelId == categoryLevelId &&
        other.userId == userId &&
        other.isWath == isWath &&
        other.isEnd == isEnd;
  }

  @override
  int get hashCode =>
      categoryLevelId.hashCode ^
      isWath.hashCode ^
      isEnd.hashCode ^
      userId.hashCode;
}
