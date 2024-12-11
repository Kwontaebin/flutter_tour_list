import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_image.dart';
import 'package:flutter_tour_list/common/function/navigator.dart';
import 'package:flutter_tour_list/searchScreen/view/search.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 설정
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // 애니메이션의 지속 시간
      vsync: this, // TickerProvider를 제공
    );

    // 회전 애니메이션 (0부터 2π까지 회전)
    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * 3.14159).animate(_controller)
          ..addListener(() {
            setState(() {}); // 애니메이션 업데이트 시 화면을 다시 그리기
          });

    // 애니메이션 반복 설정
    _controller.repeat(); // 애니메이션을 반복하도록 설정

    Timer(const Duration(seconds: 3), () {
      navigatorFn(context, const SearchScreen());
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // 애니메이션 컨트롤러 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.blue,
          child: Transform.rotate(
            angle: _rotationAnimation.value, // 회전 애니메이션 적용
            child: customImage(
              image: 'assets/images/splashImg.png',
              fit: BoxFit.none,
            ),
          ),
        ),
      ),
    );
  }
}
