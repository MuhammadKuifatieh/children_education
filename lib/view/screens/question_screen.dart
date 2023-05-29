import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controller/provider/question_provider.dart';
import '../../models/question_model.dart';
import '../../models/question_solve_model.dart';
import './answer_screen.dart';
import './level_content_screen.dart';

class QuestionScreen extends StatefulWidget {
  static const routeName = '/question_screen';

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  String? categoryLevelId;
  Map<String, dynamic>? argArray;
  List<String> name = [
    'السؤال الاول',
    'السؤال الثاني',
    'السؤال الثالث',
    'السؤال الرابع',
    'السؤال الخامس',
    'السؤال السادس',
    'السؤال السابع',
    'السؤال الثامن',
    'السؤال التاسع',
    'السؤال العاشر',
    'السؤال الحادي عشر',
    'السؤال الثاني عشر',
    'السؤال الثالث عشر',
    'السؤال الرابع عشر',
    'السؤال الخامس عشر',
  ];
  late Color color;
  late String levelName;
  late bool _init;
  fetchQuestion() async {
    if (!_init) {
      await Provider.of<QuestionProvider>(context)
          .getAllQuestion(categoryLevelId!);
      _init = true;
    }
  }

  @override
  void initState() {
    _init = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    argArray =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    categoryLevelId = argArray!['categoryLevelId'];
    color = argArray!['color'];
    levelName = argArray!['levelName'];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'قم بالاجابة ',
                        style: GoogleFonts.tajawal(
                            color: color,
                            fontSize: 25,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'على الاسئلة',
                        style: GoogleFonts.tajawal(
                            color: color,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/home.png"))),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: FutureBuilder(
                future: fetchQuestion(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  List<QuestionSolveModel> questionsSolved =
                      Provider.of<QuestionProvider>(context).questionsSloved;
                  List<QuestionModel> questions =
                      Provider.of<QuestionProvider>(context).question;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AnswerScreen.routeName, arguments: {
                            'questionId': questions[index].id,
                            'color': color,
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                  colors: [
                                    (!questionsSolved[index].isSolve)
                                        ? Colors.red
                                        : Colors.green,
                                    (!questionsSolved[index].isSolve)
                                        ? Colors.red.withOpacity(0.5)
                                        : Colors.green.withOpacity(0.5),
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: [0.5, 0.9]),
                            ),
                            child: Center(
                              child: Text(
                                name[index],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.tajawal(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              ),
                            )),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.075,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(
                    LevelContentScreen.routeName,
                    arguments: {
                      'color': color,
                      'categoryLevelId': categoryLevelId,
                      'levelName':levelName,
                    },
                  );
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10),
                    backgroundColor: MaterialStateProperty.all(color)),
                child: Text(
                  "العودة لشرح المستوى",
                  style: GoogleFonts.tajawal(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
