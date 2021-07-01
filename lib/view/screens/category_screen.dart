import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'level_screen.dart';
import '../../controller/provider/category_provider.dart';
import '../../models/category_model.dart';
import '../../models/child_model.dart';
import '../../controller/services/firestore_child.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/home_screen';
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> s = ['1', '2', '3', '4'];
  bool _init;
  ChildModel childModel;
  String childName = '';
  List<Color> colors = [
    Colors.yellow[600],
    Colors.deepOrange[800],
    Colors.purple[800],
    Colors.red[200],
  ];
  fetchCategory(context) async {
    if (!_init) {
      await Provider.of<CategoryProvider>(context).getAllCategory();
      childModel = await FireStoreChild().get();
      childName = childModel.name;
      _init = true;
    }
  }

  @override
  void initState() {
    _init = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          " أهلاَ بك $childName",
                          style: GoogleFonts.tajawal(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            wordSpacing: 3,
                          ),
                        ),
                        Text(
                          "اختر ماذا",
                          style: GoogleFonts.tajawal(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            wordSpacing: 3,
                          ),
                        ),
                        Text(' تريد تعلمه اليوم؟؟',
                            style: GoogleFonts.tajawal(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                              decorationColor: Colors.red,
                            )),
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
              ),
              Expanded(
                child: FutureBuilder(
                    future: fetchCategory(context),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      List<CategoryModel> categories =
                          Provider.of<CategoryProvider>(context).categories;
                      return StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                log(categories[index].id);
                                Navigator.of(context).pushNamed(
                                    LevelScreen.routeName,
                                    arguments: {
                                      'categoryId': categories[index].id,
                                      'imageUrl': categories[index].image
                                    });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                        colors: [
                                          colors[index * 9 % 4]
                                              .withOpacity(0.7),
                                          colors[index * 9 % 4]
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        stops: [0.2, 0.4]),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Image(
                                            image: NetworkImage(
                                                categories[index].image)),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          categories[index].name,
                                          style: GoogleFonts.tajawal(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.count(
                              1, index.isEven ? 1.2 : 1.8);
                        },
                        itemCount: categories.length,
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
