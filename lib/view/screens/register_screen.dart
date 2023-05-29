import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './login_screen.dart';
import './child_screen.dart';
import '../widgets/custom_buttom.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';
import '../../controller/services/firestore_user.dart';
import '../../models/user_model.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register_screen';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  Future<void> saveINpref(String uid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('userId', uid);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
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
                textDirection: TextDirection.ltr,
                child: Column(
                  children: [
                    CustomText(
                      text: "إضافة حساب",
                      fontSize: 30,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                      controller: userNameController,
                      text: 'اسم المستخدم',
                      onSave: (value) {
                        // controller.name = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          print("ERROR");
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                      controller: emailController,
                      text: 'الإيميل',
                      onSave: (value) {
                        // controller.email = value;
                      },
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
                      onSave: (value) {
                        // controller.password = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          print('error');
                        }
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      onPress: () async {
                        _formKey.currentState?.save();
                        var userCredential;
                        if (_formKey.currentState?.validate() ?? false) {
                          BotToast.showLoading();
                          try {
                            userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
                            Navigator.of(context).pushNamed(
                                ChildScreen.routeName,
                                arguments: {'userId': userCredential.user.uid});
                            UserModel user = await FireStoreUser().add(
                              UserModel(
                                userName: userNameController.text,
                                email: emailController.text,
                                uid: userCredential.user.uid,
                              ),
                            );
                            await saveINpref(user.uid);
                            BotToast.closeAllLoading();
                          } on FirebaseAuthException catch (e) {
                            BotToast.closeAllLoading();
                            if (e.code == 'weak-password') {
                              {
                                BotToast.showText(
                                    text:
                                        'كلمة السر ضعيفة يرجى اختيار كلمة سر اقوى');
                                print('The password provided is too weak.');
                              }
                            } else if (e.code == 'email-already-in-use') {
                              BotToast.showText(
                                  text: 'يوجد حساب اخر يملك نفس الايميل');

                              print(
                                  'The account already exists for that email.');
                            } else {
                              BotToast.showText(text: 'حدث خطأ ما');
                            }
                          } catch (e) {
                            BotToast.showText(text: 'حدث خطأ ما');
                            print(e);
                          }
                          BotToast.closeAllLoading();
                        }
                      },
                      text: 'إضافة حساب',
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
