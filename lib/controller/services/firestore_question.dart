import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/question_model.dart';

class FireStoreQuestion {
  final CollectionReference _questionCollection =
      FirebaseFirestore.instance.collection('Question');
  Future<QuestionModel> add(QuestionModel questionModel) async {
    var response = await _questionCollection.add(questionModel.toMap());
    questionModel.id = response.id;
    return questionModel;
  }

  Future<void> delete(String id) async {
    await _questionCollection.doc(id).delete();
  }

  Future<QuestionModel> getById(String levelId) async {
    var response = await _questionCollection.get();
    QuestionModel result;
    for (var item in response.docs)
      if (item.id == levelId)
        result = QuestionModel.fromMap(item.data(), item.id);
    return result;
  }

  Future<List<QuestionModel>> getAllQuestionInLevel(
      String categoryLevelId) async {
    var response = await _questionCollection
        .where('categoryLevelId', isEqualTo: categoryLevelId)
        .get();
    List<QuestionModel> questions = [];
    for (var item in response.docs) {
      questions.add(QuestionModel.fromMap(item.data(), item.id));
    }
    return questions;
  }
}
