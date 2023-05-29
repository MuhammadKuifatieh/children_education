import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/answer_model.dart';

class FireStoreAnswer {
  final CollectionReference _answerCollection =
      FirebaseFirestore.instance.collection('Answer');
  Future<AnswerModel> add(AnswerModel answerModel) async {
    var response = await _answerCollection.add(answerModel.toMap());
    answerModel.id = response.id;
    return answerModel;
  }

  Future<void> delete(String id) async {
    await _answerCollection.doc(id).delete();
  }

  Future<List<AnswerModel>> getAllAnswerToQuestion(String questionId) async {
    var response = await _answerCollection
        .where('questionId', isEqualTo: questionId)
        .get();
    List<AnswerModel> answers = [];
    for (var item in response.docs) {
      answers.add(
          AnswerModel.fromMap(item.data() as Map<String, dynamic>, item.id));
    }
    return answers;
  }
}
