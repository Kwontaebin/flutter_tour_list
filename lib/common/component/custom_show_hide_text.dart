import 'package:flutter/material.dart';

Widget customTextShowHide({
  bool isTextVisible = true,
  required String text,
}) {
  return Container(
    // container -> alignment 속성을 사용해서 글자 중앙 정렬
    alignment: Alignment.center,
    padding: const EdgeInsets.all(16.0),
    child: isTextVisible
        ? Column(
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    ) : const SizedBox.shrink(), // 아무것도 보여주지 않음
  );
}
