import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/question_solve_model.dart';

class FireStoreQuestionSolve {
  final CollectionReference _questionSolveCollection =
      FirebaseFirestore.instance.collection('questionSolve');
  Future<QuestionSolveModel> add(QuestionSolveModel questionSolveModel) async {
    var response =
        await _questionSolveCollection.add(questionSolveModel.toMap());
    questionSolveModel.id = response.id;
    return questionSolveModel;
  }

  Future<void> delete(String id) async {
    await _questionSolveCollection.doc(id).delete();
  }

  Future<QuestionSolveModel> getById(String questionId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString('userId') ?? "";
    var response = await _questionSolveCollection
        .where('questionId', isEqualTo: questionId)
        .where('userId', isEqualTo: userId)
        .get();
    QuestionSolveModel questionSolve;
    if (response.docs.isNotEmpty) {
      questionSolve = QuestionSolveModel.fromMap(
          response.docs[0].data()as Map<String, dynamic>, response.docs[0].id);
    } else {
      questionSolve = await add(QuestionSolveModel(
          questionId: questionId, isSolve: false, userId: userId));
    }
    return questionSolve;
  }

  Future<List<QuestionSolveModel>> getAllQuestionSolve() async {
    var response = await _questionSolveCollection.get();
    List<QuestionSolveModel> questionSolves = [];
    for (var item in response.docs) {
      questionSolves.add(QuestionSolveModel.fromMap(item.data()as Map<String, dynamic>, item.id));
    }
    return questionSolves;
  }

  Future update(questionSolveId) async {
    await _questionSolveCollection
        .doc(questionSolveId)
        .update({'isSolve': true});
    return;
  }
}
