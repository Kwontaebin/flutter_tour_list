/*
 체크박스 모듈 사용 시
 size.dart 에 있는 3개의 배열(checkStatus, checkboxText, showMoreText) 선언
 checkAllCheckBox, updateCheckStatus 함수 선언 후 사용 가능
 자세한 코드는 size.dart, custom_checkBox.dart 확인
 */

import 'package:flutter/material.dart';

import 'custom_show_hide_text.dart';

class CustomCheckboxWidget extends StatefulWidget {
  final String text;
  final bool isChecked;
  final ValueChanged onChanged;
  final bool showMoreText;
  final String showText;

  const CustomCheckboxWidget({
    super.key,
    required this.text,
    required this.isChecked,
    required this.onChanged,
    this.showMoreText = true,
    required this.showText,
  });

  @override
  State<CustomCheckboxWidget> createState() => _CustomCheckboxWidgetState();
}

class _CustomCheckboxWidgetState extends State<CustomCheckboxWidget> {
  bool iconBtnStatus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      children: [
        Row(
          children: [
            Checkbox(
              value: widget.isChecked,
              onChanged: widget.onChanged,
            ),
            GestureDetector(
              onTap: () {
                widget.onChanged(!widget.isChecked);
              },
              child: Text(
                widget.text,
              ),
            ),
            const Spacer(), // 나머지 위젯과 IconButton 사이에 가변 공간 추가
            widget.showMoreText
                ? IconButton(
                    // 애니메이션 효과 지우기
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        iconBtnStatus = !iconBtnStatus;
                      });
                    },
                    iconSize: 22.0,
                    icon: iconBtnStatus
                        ? const Icon(Icons.keyboard_arrow_down)
                        : const Icon(Icons.keyboard_arrow_right),
                  )
                : const SizedBox.shrink(), // 아무것도 보여주지 않음
          ],
        ),
        if (iconBtnStatus)
          customTextShowHide(
            text: widget.showText,
          ),
      ],
    );
  }
}
