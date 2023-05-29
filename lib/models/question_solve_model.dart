import 'dart:convert';

class QuestionSolveModel {
  String ?id;
  String questionId;
  bool isSolve;
  String userId;
  QuestionSolveModel({
    this.id,
    required this.questionId,
    required this.isSolve,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'isSolve': isSolve,
      'userId': userId,
    };
  }

  factory QuestionSolveModel.fromMap(Map<String, dynamic> map, String id) {
    return QuestionSolveModel(
      id: id,
      questionId: map['questionId'],
      isSolve: map['isSolve'],
      userId: map['userId'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory QuestionSolveModel.fromJson(String source) =>
  //     QuestionSolveModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'Question(questionId: $questionId, isSolve: $isSolve,userId:$userId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionSolveModel &&
        other.questionId == questionId &&
        other.userId == userId &&
        other.isSolve == isSolve;
  }

  @override
  int get hashCode => questionId.hashCode ^ isSolve.hashCode ^ userId.hashCode;
}
