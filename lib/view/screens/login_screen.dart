import 'package:children_education/controller/services/firestore_user.dart';
import 'package:children_education/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';

import './register_screen.dart';
import './child_screen.dart';
import './category_screen.dart';
import '../widgets/custom_buttom.dart';
import '../widgets/custom_button_social.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login_screen';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Future<void> saveINpref(String uid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('userId', uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          right: 20,
          left: 20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "أهلا بك",
                        fontSize: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .popAndPushNamed(RegisterScreen.routeName);
                        },
                        child: CustomText(
                          text: "إضافة حساب",
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    alignment: Alignment.topLeft,
                    text: 'إضافة حساب للتمكن من الإكمال',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextFormField(
                    controller: emailController,
                    text: 'الإيميل',
                    onSave: (value) {},
                    validator: (value) {
                      if (value == null) {
                        print("ERROR");
                      }
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  CustomTextFormField(
                    controller: passwordController,
                    text: 'كلمة السر',
                    onSave: (value) {},
                    validator: (value) {
                      if (value == null) {
                        print('error');
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                    onPress: () async {
                      _formKey.currentState.save();
                      var userCredential;

                      if (_formKey.currentState.validate()) {
                        BotToast.showLoading();
                        try {
                          print(emailController.text);
                          print(passwordController.text);
                          userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text)
                              .then((value) async {
                            print(value);
                            UserModel user = await FireStoreUser()
                                .getUserById(value.user.uid);
                            await saveINpref(value.user.uid);
                            Navigator.of(context)
                                .pushNamed(CategoryScreen.routeName);
                          });
                        } on FirebaseAuthException catch (e) {
                          print('x1');
                          if (e.code == 'user-not-found') {
                            {
                              BotToast.showText(
                                  text: 'لا يوجد مستخدم يملك هذا الإيميل');
                              print('No user found for that email.');
                            }
                          } else if (e.code == 'wrong-password') {
                            BotToast.showText(
                                text: 'كلمة السر التي ادخلتها خاطئة');
                            print('Wrong password provided for that user.');
                          } else {
                            BotToast.showText(text: 'something wronge');
                            print('حدث خطأ ما');
                          }
                        }
                        BotToast.closeAllLoading();
                        print(userCredential);
                      }
                    },
                    text: 'تسجيل الدخول',
                  ),
                  SizedBox(height: 40),
                  CustomText(
                    text: '-أو-',
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 40),
                  CustomButtonSocial(
                    text: ' تسجيل الدخول باستخدام Google ',
                    onPress: () async {
                      try {
                        BotToast.showLoading();
                        final GoogleSignInAccount googleUser =
                            await GoogleSignIn().signIn();
                        final GoogleSignInAuthentication googleAuth =
                            await googleUser.authentication;
                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );
                        final user = await FirebaseAuth.instance
                            .signInWithCredential(credential);

                        if (FireStoreUser().getUserById(user.user.uid) ==
                            null) {
                          Navigator.of(context)
                              .pushNamed(ChildScreen.routeName);
                          FireStoreUser().add(
                            UserModel(
                              userName: user.user.displayName,
                              email: user.user.email,
                              uid: user.user.uid,
                            ),
                          );
                        } else {
                          Navigator.of(context)
                              .pushNamed(CategoryScreen.routeName);
                        }
                        saveINpref(user.user.uid);
                      } catch (e) {
                        BotToast.closeAllLoading();
                        BotToast.showText(text: 'حدث خطأ ما');
                      }
                      BotToast.closeAllLoading();
                    },
                    imageName: 'assets/images/google.png',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
