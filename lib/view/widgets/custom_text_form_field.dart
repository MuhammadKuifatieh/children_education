
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? text;

  final String? hint;

  final Function(String?)? onSave;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  CustomTextFormField({
    this.text,
    this.hint,
    this.onSave,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
          child: TextFormField(
        controller: controller,
        onSaved: onSave,
        validator: validator,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(),
          fillColor: Colors.white,
        ),
      )),
    );
  }
}
