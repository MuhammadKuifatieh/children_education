import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import './category_screen.dart';
import '../widgets/custom_buttom.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';
import '../../models/child_model.dart';
import '../../controller/services/firestore_child.dart';

class ChildScreen extends StatefulWidget {
  static const routeName = '/child_screen';

  @override
  _ChildScreenState createState() => _ChildScreenState();
}

class _ChildScreenState extends State<ChildScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController genderController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  Map<String, dynamic> argArray;
  String userId;
  @override
  void didChangeDependencies() {
    argArray =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    userId = argArray['userId'];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.125),
                  CustomText(
                    text: "الرجاء إدخال البيانات الخاصة بطفلك",
                    fontSize: 30,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextFormField(
                    controller: nameController,
                    text: 'اسم الطفل',
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
                    controller: ageController,
                    text: 'عمر الطفل',
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
                    controller: genderController,
                    text: 'جنس الطفل',
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
                      BotToast.showLoading();
                      FireStoreChild().add(ChildModel(
                          name: nameController.text,
                          age: ageController.text,
                          gender: genderController.text,
                          userId: userId));
                          Navigator.of(context).pushNamed(CategoryScreen.routeName);
                      BotToast.closeAllLoading();
                    },
                    text: 'إتمام التسجيل',
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
