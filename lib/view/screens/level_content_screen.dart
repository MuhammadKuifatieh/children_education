import 'package:children_education/controller/provider/level_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../../controller/provider/level_content_provider.dart';
import '../../models/level_content_model.dart';
import '../widgets/curve_clipper.dart';
import './question_screen.dart';

class LevelContentScreen extends StatefulWidget {
  static const routeName = '/welcome_level_screen';
  @override
  _LevelContentScreenState createState() => _LevelContentScreenState();
}

class _LevelContentScreenState extends State<LevelContentScreen> {
  late YoutubePlayerController _controller;
  late String categoryLevelId;
  late String levelName;
  late Map<String, dynamic> argArray;
  late bool _initContent;
  late bool _setVideo;
  late bool showPhotoText;
  late Color color;
  LevelContentModel? video;
  List<LevelContentModel> photo = [];
  List<LevelContentModel> text = [];
  LevelContentModel? audio;
  Audio? audios;
  final assetsAudioPlayer = AssetsAudioPlayer();
  fetchContent() async {
    if (!_initContent) {
      await Provider.of<LevelContentProvider>(context, listen: false)
          .getAllContentsToLevel(categoryLevelId);
      _initContent = true;
    }
  }

  getLists(List<LevelContentModel> list) {
    photo = [];
    text = [];
    for (var item in list) {
      if (item.type == 'فيديو') {
        video = item;
        setVideo(video!.content);
      } else if (item.type == 'صورة') {
        photo.add(item);
      } else if (item.type == 'نص') {
        text.add(item);
      } else if (item.type == 'صوت') {
        audio = item;
        audios = Audio.network(item.content);
      }
    }
    print(list);
  }

  setVideo(String key) {
    if (!_setVideo) {
      _controller = YoutubePlayerController(
          initialVideoId: key,
          flags: YoutubePlayerFlags(
            autoPlay: true,
          ));
      _setVideo = true;
    }
  }

  @override
  void didChangeDependencies() {
    argArray =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    categoryLevelId = argArray['categoryLevelId'];
    levelName = argArray['levelName'];
    color = argArray['color'];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _initContent = false;
    _setVideo = false;
    showPhotoText = true;
    _controller = YoutubePlayerController(
      initialVideoId: 'x_fW3gRHp2M',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: FutureBuilder(
          future: fetchContent(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            getLists(Provider.of<LevelContentProvider>(context).levelContents);
            return Stack(
              children: [
                ListView(
                  children: [
                    ClipPath(
                      clipper: CurveClipper(),
                      child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.275,
                          decoration: BoxDecoration(color: color),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.075,
                                ),
                                Text(
                                  ' أهلاَ بك في مقدمة ',
                                  style: GoogleFonts.tajawal(
                                    fontSize: 26,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  levelName,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 26,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                    if (video != null)
                      YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: _controller,
                        ),
                        builder: (context, play) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'فيديو توضيحي عن المستوى :',
                                  style: GoogleFonts.tajawal(fontSize: 18),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: play),
                              ],
                            ),
                          );
                        },
                      ),
                    if (photo.length != 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('صور توضيحية عن المستوى :'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.38,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(photo[index].content),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  );
                                },
                                itemCount: photo.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (audio != null)
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'صوت توضيحي عن المستوى',
                                style: GoogleFonts.tajawal(fontSize: 18),
                              ),
                            ),
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
                                        color: color,
                                        iconSize: 75,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.play_circle_fill),
                                        onPressed: () {
                                          assetsAudioPlayer.open(audios!);
                                        },
                                        color: color,
                                        iconSize: 75,
                                      ),
                                    ],
                                  ),
                                ))
                          ]),
                    if (text.length != 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'نص توضيحي عن المستوى',
                              style: GoogleFonts.tajawal(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Text(
                                    text[index].content,
                                    style: GoogleFonts.tajawal(fontSize: 18),
                                  );
                                },
                                itemCount: text.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.075,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(color),
                          elevation: MaterialStateProperty.all(10)),
                      onPressed: () {
                        Provider.of<LevelProvider>(context, listen: false)
                            .updateChildLevel(categoryLevelId, true);
                        Navigator.of(context).popAndPushNamed(
                          QuestionScreen.routeName,
                          arguments: {
                            'categoryLevelId': categoryLevelId,
                            'color': color,
                            'levelName': levelName,
                          },
                        );
                      },
                      child: Text(
                        'الانتقال إلى الاسئلة',
                        style: GoogleFonts.tajawal(
                            fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
