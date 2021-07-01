import 'dart:convert';

import 'package:flutter/material.dart';

class AnswerModel {
  String id;
  String answerType;
  String answerContent;
  bool isCurrect;
  String questionId;
  AnswerModel({
    this.id,
    @required this.answerType,
    @required this.answerContent,
    @required this.isCurrect,
    @required this.questionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'answerType': answerType,
      'answerContent': answerContent,
      'isCurrect': isCurrect,
      'questionId': questionId,
    };
  }

  factory AnswerModel.fromMap(Map<String, dynamic> map, String id) {
    return AnswerModel(
      id: id,
      answerType: map['answerType'],
      answerContent: map['answerContent'],
      isCurrect: map['isCurrect'],
      questionId: map['questionId'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory AnswerModel.fromJson(String source) =>
  //     AnswerModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'Type(answerType: $answerType, answerContent: $answerContent,isCurrect: $isCurrect, questionId: $questionId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnswerModel &&
        other.answerType == answerType &&
        other.answerContent == answerContent &&
        other.isCurrect == isCurrect &&
        other.questionId == questionId;
  }

  @override
  int get hashCode =>
      answerType.hashCode ^
      answerContent.hashCode ^
      isCurrect.hashCode ^
      questionId.hashCode;
}
