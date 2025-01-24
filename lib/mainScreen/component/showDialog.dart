import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_elevatedButton.dart';
import 'package:flutter_tour_list/common/component/custom_text_field.dart';
import 'package:flutter_tour_list/common/component/custom_toast.dart';
import 'package:flutter_tour_list/common/function/sizeFn.dart';

void showInputDialog(
  BuildContext context, {
  required String text,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('검색'),
        content: CustomTextFieldWidget(
          hintText: "검색어를 입력하세요",
          onChanged: (value) => text = value,
        ),
        actions: [
          // customElevatedButton(
          //   context,
          //   text: "취소",
          //   width: sizeFn(context).width * 0.04,
          //   height: sizeFn(context).height * 0.045,
          //   buttonTextSize: sizeFn(context).width * 0.04,
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
          // customElevatedButton(
          //   context,
          //   text: "확인",
          //   width: sizeFn(context).width * 0.04,
          //   height: sizeFn(context).height * 0.045,
          //   buttonTextSize: sizeFn(context).width * 0.04,
          //   onPressed: () {
          //     print(text);
          //     Navigator.of(context).pop();
          //   },
          // )

          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 닫기
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              print(text);

              text.isEmpty ? customToast(message: "검색어를 입력하세요") : Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
