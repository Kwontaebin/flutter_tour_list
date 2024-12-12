import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_appbar.dart';
import 'package:flutter_tour_list/common/const/data.dart';
import 'package:flutter_tour_list/common/function/sizeFn.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  bool isMapInitialized = false; // 맵 초기화 상태

  // 지도 초기화하기
  Future<void> _initialize() async {
    try {
      await NaverMapSdk.instance.initialize(
        clientId: NAVER_MAP_KEY,
        onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"),
      );
      setState(() {
        isMapInitialized = true; // 초기화 완료
      });
    } catch (e) {
      log("네이버맵 초기화 중 오류: $e", name: "_initialize");
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "서울 구경",
        bgColor: Colors.white,
      ),
      body: isMapInitialized ? Container(
        width: double.infinity,
        height: deviceHeight(context),
        color: Colors.white,
        child: NaverMap(
          options: const NaverMapViewOptions(
            indoorEnable: true,
            locationButtonEnable: false,
            consumeSymbolTapEvents: false,
          ),
          onMapReady: (controller) {
            mapControllerCompleter.complete(controller);
            log("onMapReady", name: "onMapReady");
          },
        ),
      ) : const Center(
        child: CircularProgressIndicator(), // 초기화 중 로딩 표시
      ),
    );
  }
}