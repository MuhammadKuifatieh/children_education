import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;

  final Function onPress;

  CustomButton({
    @required this.onPress,
    this.text = 'Write text ',
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(10),
        onPressed: onPress,
        color: Theme.of(context).primaryColor,
        child: CustomText(
          alignment: Alignment.center,
          text: text,
          color: Colors.white,
        ),
      ),
    );
  }
}
