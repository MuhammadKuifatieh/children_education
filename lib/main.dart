import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './view/screens/login_screen.dart';
import './view/screens/register_screen.dart';
import './view/screens/child_screen.dart';
import './view/screens/category_screen.dart';
import './view/screens/level_screen.dart';
import './view/screens/level_content_screen.dart';
import './view/screens/question_screen.dart';
import './view/screens/answer_screen.dart';
import './controller/provider/answer_provider.dart';
import './controller/provider/category_provider.dart';
import './controller/provider/level_content_provider.dart';
import './controller/provider/level_provider.dart';
import './controller/provider/question_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String userId;
  Future<String> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    userId = pref.getString('userId');
    print(userId);
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => AnswerProvider()),
        ChangeNotifierProvider(create: (context) => LevelProvider()),
        ChangeNotifierProvider(create: (context) => LevelContentProvider()),
        ChangeNotifierProvider(create: (context) => QuestionProvider()),
      ],
      child: MaterialApp(
        builder: (context, child) {
          child = botToastBuilder(context, child);
          return child;
        },
        title: 'children education',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          accentColor: Colors.yellow[600],
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: FutureBuilder<String>(
            future: getUserId(),
            builder: (context, snapShot) =>
                (snapShot.data == null) ? LoginScreen() : CategoryScreen(),
          ),
        ),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          RegisterScreen.routeName: (context) => RegisterScreen(),
          ChildScreen.routeName: (context) => ChildScreen(),
          CategoryScreen.routeName: (context) => CategoryScreen(),
          LevelScreen.routeName: (context) => LevelScreen(),
          LevelContentScreen.routeName: (context) => LevelContentScreen(),
          QuestionScreen.routeName: (context) => QuestionScreen(),
          AnswerScreen.routeName: (context) => AnswerScreen(),
        },
        navigatorObservers: [BotToastNavigatorObserver()],
      ),
    );
  }
}
