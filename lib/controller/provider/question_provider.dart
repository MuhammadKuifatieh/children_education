import 'package:flutter/material.dart';

import '../../models/question_model.dart';
import '../../models/question_solve_model.dart';
import '../services/firestore_question.dart';
import '../services/firestore_question_slove.dart';

class QuestionProvider with ChangeNotifier {
  List<QuestionModel> _questions = [];
  List<QuestionSolveModel> _questionsSolved = [];

  List<QuestionModel> get question {
    return [..._questions];
  }

  List<QuestionSolveModel> get questionsSloved {
    return [..._questionsSolved];
  }

  QuestionModel questionById(questionId) {
    for (var item in question) {
      if (item.id == questionId) return item;
    }
    return null;
  }

  Future<void> getAllQuestion(String categoryLevelId) async {
    List<QuestionModel> list =
        await FireStoreQuestion().getAllQuestionInLevel(categoryLevelId);
    _questions = list;
    List<QuestionSolveModel> newList = [];
    _questionsSolved = [];
    for (var item in list) {
      QuestionSolveModel newQ = await FireStoreQuestionSolve().getById(item.id);
      newList.add(newQ);
    }
    _questionsSolved = newList;
    notifyListeners();
  }

  Future<void> solve(questionId) async {
    for (var item in questionsSloved) {
      if (item.questionId == questionId) {
        await FireStoreQuestionSolve().update(item.id);
        item.isSolve = true;
      }
    }
    notifyListeners();
  }

  Future<void> add(QuestionModel questionModel) async {
    questionModel = await FireStoreQuestion().add(questionModel);
    _questions.add(QuestionModel(
      id: questionModel.id,
      type: questionModel.type,
      content: questionModel.content,
      categoryLevelId: questionModel.categoryLevelId,
    ));
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await FireStoreQuestion().delete(id);
    for (int i = 0; i < _questions.length; i++) {
      if (_questions[i].id == id) _questions.removeAt(i);
    }
    notifyListeners();
  }
}
