import 'dart:convert';

import 'package:flutter/material.dart';

class LevelContentModel {
  String? id;
  String categoryLevelId;
  String type;
  String content;
  LevelContentModel({
    this.id,
    required this.categoryLevelId,
    required this.type,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryLevelId': categoryLevelId,
      'type': type,
      'content': content,
    };
  }

  factory LevelContentModel.fromMap(Map<String, dynamic> map, String id) {
    return LevelContentModel(
      id: id,
      categoryLevelId: map['categoryLevelId'],
      type: map['type'],
      content: map['content'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory LevelContentModel.fromJson(String source) =>
  //     LevelContentModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'Level Content( categoryLevelId: $categoryLevelId,type: $type,content: $content)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LevelContentModel &&
        other.categoryLevelId == categoryLevelId &&
        other.type == type &&
        other.content == content;
  }

  @override
  int get hashCode =>
      categoryLevelId.hashCode ^ type.hashCode ^ content.hashCode;
}
