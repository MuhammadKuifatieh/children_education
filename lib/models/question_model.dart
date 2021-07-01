import 'dart:convert';

import 'package:flutter/material.dart';

class QuestionModel {
  String id;
  String type;
  String content;
  String categoryLevelId;
  QuestionModel({
    this.id,
    @required this.type,
    @required this.content,
    @required this.categoryLevelId,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'content': content,
      'categoryLevelId': categoryLevelId,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map, String id) {
    return QuestionModel(
      id: id,
      type: map['type'],
      content: map['content'],
      categoryLevelId: map['categoryLevelId'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory QuestionModel.fromJson(String source) =>
  //     QuestionModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'Question(type: $type, content: $content,categoryLevelId:$categoryLevelId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionModel &&
        other.type == type &&
        other.categoryLevelId == categoryLevelId &&
        other.content == content;
  }

  @override
  int get hashCode =>
      type.hashCode ^ content.hashCode ^ categoryLevelId.hashCode;
}
