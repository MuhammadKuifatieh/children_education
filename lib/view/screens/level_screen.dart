import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'level_content_screen.dart';
import 'question_screen.dart';
import '../../controller/provider/question_provider.dart';
import '../../controller/provider/level_provider.dart';
import '../../models/level_model.dart';
import '../../models/child_level_model.dart';

class LevelScreen extends StatefulWidget {
  static const routeName = '/level_screen';
  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen>
    with TickerProviderStateMixin {
  String categoryId;
  String imageUrl;
  bool _init;
  bool flag = false;
  Map<String, dynamic> argArray;
  List<Color> colors = [
    Colors.yellow[600],
    Colors.deepOrange[800],
    Colors.purple[800],
    Colors.red[200],
  ];
  List<AnimationController> _animations = [];

  fetchLevel(context) async {
    if (!_init) {
      await Provider.of<LevelProvider>(context).getAllLevel(categoryId);
      _init = true;
    }
  }

  @override
  void didChangeDependencies() {
    argArray =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    categoryId = argArray['categoryId'];
    imageUrl = argArray['imageUrl'];
    _animations.add(AnimationController(
      duration: const Duration(seconds: 7),
      lowerBound: 25,
      upperBound: 300,
      vsync: this,
    )..repeat());
    _animations.add(AnimationController(
      duration: const Duration(seconds: 6),
      lowerBound: 25,
      upperBound: 300,
      vsync: this,
    )..repeat());
    _animations.add(AnimationController(
      duration: const Duration(seconds: 5),
      lowerBound: 25,
      upperBound: 300,
      vsync: this,
    )..repeat());
    _animations.add(AnimationController(
      duration: const Duration(seconds: 4),
      lowerBound: 25,
      upperBound: 300,
      vsync: this,
    )..repeat());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    for (var item in _animations) item.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _init = false;
    super.initState();
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
                InkWell(
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اختر ',
                      style: GoogleFonts.tajawal(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'المستوى',
                      style: GoogleFonts.tajawal(
                        fontSize: 37,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: FutureBuilder(
                future: fetchLevel(context),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  List<LevelModel> levels =
                      Provider.of<LevelProvider>(context).levels;
                  List<String> categoryLevelId =
                      Provider.of<LevelProvider>(context).categoryLevelId;
                  List<ChildLevelModel> childLevels =
                      Provider.of<LevelProvider>(context).childLevels;
                  log(categoryLevelId.toString());
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Provider.of<QuestionProvider>(context, listen: false)
                              .getAllQuestion(categoryLevelId[index]);
                          Navigator.of(context).pushNamed(
                            (childLevels[index].isWath)
                                ? QuestionScreen.routeName
                                : LevelContentScreen.routeName,
                            arguments: {
                              'categoryLevelId': categoryLevelId[index],
                              'levelName': levels[index].name,
                              'color': colors[(index + 1) * 7 % 4],
                            },
                          );
                        },
                        child: AnimatedBuilder(
                          animation: _animations[index * 3 % 4],
                          builder: (context, _) {
                            return Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    _animations[index * 3 % 4].value),
                                gradient: LinearGradient(
                                  colors: [
                                    colors[(index + 1) * 7 % 4]
                                        .withOpacity(0.05),
                                    colors[(index + 1) * 7 % 4]
                                        .withOpacity(0.075)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [0.3, 0.6],
                                ),
                                border: Border.all(
                                  color: colors[(index + 1) * 7 % 4],
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                                // shape:(flag) ?BoxShape.circle:BoxShape.rectangle,
                              ),
                              child: Center(
                                child: Text(
                                  levels[index].number.toString(),
                                  style: GoogleFonts.tajawal(
                                    fontSize: 80,
                                    color: colors[(index + 1) * 7 % 4],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    itemCount: levels.length,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
