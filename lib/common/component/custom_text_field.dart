/*
  todo 해당 모듈 사용 시 필수 사항
  모듈을 불러오는 파일 제일 상단에 GestureDetector 위젯을 불러오고 밑의 코드 작성
        onTap: () {
          FocusScope.of(context).unfocus(); // 빈 공간 클릭 시 포커스 해제
        },

  이렇게 하면 커서가 집중되어 있을 때 빈 공간을 클릭하면 커서 집중이 풀린다.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../function/sizeFn.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String hintText;
  final Color backGroundColor;
  final double? width;
  final double? height;
  final ValueChanged<String> onChanged;
  final bool onlyNum;
  final bool obscureText;
  final String myControllerText;
  final bool autoFocus;
  final bool textSpacing;

  const CustomTextFieldWidget({
    super.key,
    this.width,
    this.height,
    required this.hintText,
    this.backGroundColor = Colors.white12,
    required this.onChanged,
    this.onlyNum = false,
    this.obscureText = false,
    this.myControllerText = "",
    this.autoFocus = false,
    this.textSpacing = false,
  });

  @override
  _CustomTextFieldWidgetState createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late bool _obscureText;
  final _myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; // 초기 상태 설정
    _myController.text = widget.myControllerText;
  }

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black12,
        width: 1.0,
      ),
    );

    final textStyle = TextStyle(
      fontSize: deviceHeight(context) * 0.02,
      fontWeight: FontWeight.w400,
    );

    // height 값에 따라 contentPadding을 동적으로 설정
    EdgeInsetsGeometry contentPadding = EdgeInsets.symmetric(
      vertical: (widget.height != null && widget.height! < 40)
          ? widget.height! * 0.2
          : 20,
      horizontal: 20,
    );

    return SizedBox(
      width: widget.width ?? sizeFn(context).width * 0.9,
      height: 70,
      child: TextFormField(
        autofocus: widget.autoFocus,
        obscureText: _obscureText,
        controller: _myController,
        onChanged: widget.onChanged,
        keyboardType: widget.onlyNum ? TextInputType.number : TextInputType.text,
        inputFormatters: [
          if (!widget.textSpacing) FilteringTextInputFormatter.deny(RegExp(r'\s')), // 띄어쓰기 금지
          if (widget.onlyNum) FilteringTextInputFormatter.digitsOnly,
        ],
        style: textStyle,
        decoration: InputDecoration(
          suffixIcon: widget.obscureText
              ? IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText; // 클릭 시 텍스트 숨김/표시 토글
              });
            },
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          )
              : null,
          contentPadding: contentPadding,
          hintText: widget.hintText,
          hintStyle: textStyle,
          fillColor: widget.backGroundColor,
          filled: true,
          border: baseBorder,
          enabledBorder: baseBorder,
          focusedBorder: baseBorder.copyWith(
            borderSide: baseBorder.borderSide.copyWith(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
