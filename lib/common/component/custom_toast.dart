import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void customToast({
  required String message,
  Color bgColor = Colors.blue,
  Color textColor = Colors.white,
  double textSize = 16.0,
}) {
  Fluttertoast.showToast(
    msg: message, // 표시할 메시지
    toastLength: Toast.LENGTH_SHORT, // 지속 시간 (SHORT or LONG)
    gravity: ToastGravity.TOP, // 화면 위치
    backgroundColor: bgColor, // 배경색
    textColor: textColor, // 텍스트 색상
    fontSize: textSize, // 텍스트 크기
  );
}