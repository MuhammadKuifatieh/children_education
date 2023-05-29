import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;

  final double fontSize;

  final Color color;

  final Alignment alignment;

  final int? maxLine;
  final double height;

  CustomText({
    this.text = '',
    this.fontSize = 14,
    this.color = Colors.black,
    this.alignment = Alignment.topRight,
    this.maxLine,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        alignment: alignment,
        child: Text(
          text,
          style: GoogleFonts.tajawal(
            color: color,
            height: height,
            fontSize: fontSize,
          ),
          maxLines: maxLine,
        ),
      ),
    );
  }
}