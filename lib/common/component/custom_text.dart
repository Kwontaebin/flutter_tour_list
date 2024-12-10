import 'package:flutter/material.dart';

Widget customTextWidget({
  required String text,
  double textSize  = 18,
  Color textColor = Colors.black,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: textSize,
      color: textColor,
    ),
  );
}
