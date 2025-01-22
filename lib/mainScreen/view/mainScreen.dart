import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_appbar.dart';
import 'package:flutter_tour_list/common/function/sizeFn.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';
import '../../common/component/webview.dart';
import '../../searchScreen/view/search.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  NaverMapController? _mapController;
  List<NLatLng> mapList = [];
  double? _bottomSheetHeight = -300.0; // 슬라이드 바텀 시트 초기 위치 (숨겨짐)
  int _clickedMarkerId = 0;

  @override
  Widget build(BuildContext context) {
    List dataList = context.read<DataProvider>().dataList;
    NMarker? previousMarker;
    NMarker marker;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "서울 구경",
        bgColor: Colors.white,
        showLeading: true,
      ),
      body: Container(
        width: double.infinity,
        height: deviceHeight(context),
        color: Colors.white,
        child: Stack(
          children: [
            NaverMap(
              options: const NaverMapViewOptions(mapType: NMapType.hybrid),
              onSymbolTapped: (symbol) {
                print(symbol.caption);
                print(symbol.position);

                setState(() {
                  markerZoom(
                    symbol.position.latitude,
                    symbol.position.longitude,
                  );
                });
              },
              onMapReady: (controller) {
                _mapController = controller;
                mapControllerCompleter.complete(controller);
                log("onMapReady", name: "onMapReady");

                for (int i = 0; i < dataList.length; i++) {
                  marker = NMarker(
                    id: i.toString(),
                    position: NLatLng(
                      double.parse(dataList[i][2][0]),
                      double.parse(dataList[i][2][1]),
                    ),
                    size: const Size(40, 50),
                  );

                  setState(() {
                    if (mounted) {
                      mapList.add(marker.position);
                      print(marker);
                      controller.addOverlay(marker);
                    }
                  });

                  marker.setOnTapListener((NMarker tappedMarker) {
                    setState(() {
                      if (previousMarker != null && mounted) previousMarker!.setIconTintColor(Colors.transparent);
                      tappedMarker.setIconTintColor(Colors.blue);
                      previousMarker = tappedMarker;

                      _clickedMarkerId = int.parse(tappedMarker.info.id);

                      print("dataList ${dataList[int.parse(tappedMarker.info.id)]}");

                      markerZoom(
                        double.parse(dataList[int.parse(tappedMarker.info.id)][2][0]),
                        double.parse(dataList[int.parse(tappedMarker.info.id)][2][1]),
                      );
                    });
                  });

                  final onMarkerInfoMap = NInfoWindow.onMarker(
                    id: i.toString(),
                    text: dataList[i][0],
                  );

                  marker.openInfoWindow(onMarkerInfoMap);
                }

                _setBoundList(mapList);
              },
            ),
            // 하단 슬라이드 가능한 위젯
            AnimatedPositioned(
              bottom: _bottomSheetHeight,
              left: 0,
              right: 0,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    // 위로 드래그하여 열기, 아래로 드래그하여 닫기
                    details.primaryDelta! < 0
                        ? _bottomSheetHeight = 0.0
                        : _bottomSheetHeight = -MediaQuery.of(context).size.height * 0.3;
                  });
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3, // 화면 높이의 30%
                  color: Colors.white,
                  child: dataList[_clickedMarkerId][1] == ""
                      ? const Center(child: Text("정보가 없습니다."))
                      : WebViewExample(linkUrl: dataList[_clickedMarkerId][1]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setBoundList(List<NLatLng> positions) {
    NLatLngBounds bounds = NLatLngBounds.from(positions);
    NCameraUpdate newCamera = NCameraUpdate.fitBounds(bounds, padding: const EdgeInsets.all(100.0));
    _mapController?.updateCamera(newCamera);
  }

  void _setBound(NLatLng position) {
    // 여유를 줄 거리(단위: 위도/경도 약 0.001 ~ 0.01 범위에서 적절히 설정)
    const double offset = 0.005;

    NLatLngBounds bounds = NLatLngBounds(
      southWest: NLatLng(position.latitude - offset, position.longitude - offset),
      northEast: NLatLng(position.latitude + offset, position.longitude + offset),
    );

    NCameraUpdate newCamera = NCameraUpdate.fitBounds(
      bounds,
      padding: const EdgeInsets.all(50.0), // 주변 여백 조정
    );

    _mapController?.updateCamera(newCamera);
  }

  void markerZoom(double lat, double lon) {
    _bottomSheetHeight = 0.0;

    NaverMapViewOptions(
      indoorEnable: true,
      locationButtonEnable: false,
      consumeSymbolTapEvents: false,
      initialCameraPosition: NCameraPosition(
        target: NLatLng(lat, lon),
        zoom: 15,
        bearing: 0,
        tilt: 30,
      ),
    );

    _setBound(
      NLatLng(lat, lon),
    );
  }
}