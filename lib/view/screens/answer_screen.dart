import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../../controller/provider/answer_provider.dart';
import '../../controller/provider/question_provider.dart';
import '../../models/answer_model.dart';
import '../../models/question_model.dart';

class AnswerScreen extends StatefulWidget {
  static const routeName = '/answer_screen';
  @override
  _AnswerScreenState createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  late Map<String, dynamic> argArray;
  late String questionId;
  late bool _init;
  late QuestionModel question;
  late List<AnswerModel> answers;
  List<bool> flags = [];
  final assetsAudioPlayer = AssetsAudioPlayer();
  late YoutubePlayerController _controller;
  late Audio audio;
  late Color color;
  @override
  void initState() {
    _init = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    argArray =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    questionId = argArray['questionId'];
    color = argArray['color'];
    question = Provider.of<QuestionProvider>(context).questionById(questionId)!;
    super.didChangeDependencies();
  }

  fetchAnswer() async {
    if (!_init) {
      await Provider.of<AnswerProvider>(context)
          .getAllAnswerToQuestion(questionId);
      _init = true;
      if (question.type == 'صوت') {
        audio = Audio.network(question.content);
      } else if (question.type == 'فيديو') {
        _controller = YoutubePlayerController(
          initialVideoId: question.content,
          flags: YoutubePlayerFlags(
            autoPlay: true,
          ),
        );
      }
    }
  }

  setAnswer() {
    answers = Provider.of<AnswerProvider>(context).answers;
    for (var item in answers) {
      flags.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            if (question.type == 'فيديو')
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller,
                ),
                builder: (context, play) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: play,
                  );
                },
              ),
            if (question.type == 'صوت')
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.pause_circle_filled,
                        ),
                        onPressed: () {
                          assetsAudioPlayer.stop();
                        },
                        color: Theme.of(context).primaryColor,
                        iconSize: 75,
                      ),
                      IconButton(
                        icon: Icon(Icons.play_circle_fill),
                        onPressed: () {
                          assetsAudioPlayer.open(audio);
                        },
                        color: Theme.of(context).primaryColor,
                        iconSize: 75,
                      ),
                    ],
                  ),
                ),
              ),
            if (question.type == 'صورة')
              Container(
                width: double.infinity,
                child: Image.network(
                  question.content,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ),
            if (question.type == 'نص')
              Container(
                child: Text(
                  question.content,
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                  ),
                ),
              ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            FutureBuilder(
              future: fetchAnswer(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Expanded(
                      flex: 2,
                      child: Center(child: CircularProgressIndicator()));
                setAnswer();
                return Expanded(
                  flex: 1,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            flags[index] = !flags[index];
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: (flags[index])
                                ? Border.all(
                                    width: 2,
                                    color: Colors.green,
                                  )
                                : null,
                          ),
                          child: (answers[index].answerType == 'صورة')
                              ? Image.network(answers[index].answerContent)
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: color,
                                  ),
                                  child: Center(
                                    child: Text(
                                      answers[index].answerContent,
                                      textAlign: TextAlign.center,
                                      
                                      style: GoogleFonts.tajawal(fontSize: 20),
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                    itemCount: answers.length,
                  ),
                );
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(color)),
              onPressed: () {
                bool flag = true;
                for (int i = 0; i < answers.length; i++) {
                  if (answers[i].isCurrect != flags[i]) {
                    flag = false;
                  }
                }

                if (flag) {
                  BotToast.showText(
                    text: 'الجواب صحيح',
                    contentColor: Colors.green,
                    backgroundColor: Colors.green.withOpacity(0.1),
                    textStyle: GoogleFonts.tajawal(color: Colors.white),
                  );
                  Provider.of<QuestionProvider>(context, listen: false)
                      .solve(questionId);
                  Timer(Duration(milliseconds: 2000), () {
                    Navigator.of(context).pop();
                  });
                } else {
                  BotToast.showText(
                    text: 'الجواب خاطئ',
                    contentColor: Colors.red,
                    backgroundColor: Colors.red.withOpacity(0.1),
                    textStyle: GoogleFonts.tajawal(color: Colors.white),
                  );
                  Timer(Duration(milliseconds: 2000), () {
                    Navigator.of(context).pop();
                  });
                }
              },
              child: Text(
                'تأكيد الجواب',
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
