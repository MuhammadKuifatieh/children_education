import 'package:flutter/cupertino.dart';

import '../../models/answer_model.dart';
import '../services/firestore_answer.dart';

class AnswerProvider with ChangeNotifier {
  List<AnswerModel> _answers = [];
  List<AnswerModel> get answers {
    return [..._answers];
  }

  getAllAnswerToQuestion(String questionId) async {
    List<AnswerModel> list =
        await FireStoreAnswer().getAllAnswerToQuestion(questionId);
    _answers = list;
    notifyListeners();
  }

  Future<void> add(AnswerModel answerModel) async {
    answerModel = await FireStoreAnswer().add(answerModel);
    _answers.add(answerModel);
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await FireStoreAnswer().delete(id);
    for (int i = 0; i < _answers.length; i++) {
      if (_answers[i].id == id) _answers.removeAt(i);
    }
    notifyListeners();
  }
}
