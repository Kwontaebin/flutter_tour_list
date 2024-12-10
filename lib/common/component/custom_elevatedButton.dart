import 'package:flutter/material.dart';
import '../function/sizeFn.dart';

Widget customElevatedButton(BuildContext context, {
  double? width,
  double? height,
  Color color = Colors.red,
  required String text,
  Color buttonTextColor = Colors.white,
  double? buttonTextSize,
  FontWeight? buttonTextFontWeight,
  required VoidCallback? onPressed
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      minimumSize: Size(
        width ?? sizeFn(context).width * 0.5,
        height ?? deviceHeight(context) * 0.05,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: buttonTextColor,
          fontSize: buttonTextSize ?? sizeFn(context).width * 0.05,
          fontWeight: buttonTextFontWeight ?? FontWeight.w500
      ),
    ),
  );
}