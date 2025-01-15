import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_appbar.dart';
import 'package:flutter_tour_list/common/function/sizeFn.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';
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
  final double _zoomLevel = 10.0;
  double _bottomSheetHeight = -300; // 슬라이드 바텀 시트 초기 위치 (숨겨짐)

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List dataList = context.read<DataProvider>().dataList;
    NMarker? previousMarker;
    NMarker marker;

    return Scaffold(
        appBar: const CustomAppBar(
          title: "서울 구경",
          bgColor: Colors.white,
        ),
        body: Container(
          width: double.infinity,
          height: deviceHeight(context),
          color: Colors.white,
          child: Stack(
            children: [
              NaverMap(
                onMapReady: (controller) {
                  _mapController = controller;
                  mapControllerCompleter.complete(controller);
                  log("onMapReady", name: "onMapReady");

                  for (int i = 0; i < dataList.length; i++) {
                    marker = NMarker(
                      id: i.toString(),
                      position: NLatLng(
                        double.parse(dataList[i][3][0]),
                        double.parse(dataList[i][3][1]),
                      ),
                      size: const Size(40, 50),
                    );

                    setState(() {
                      mapList.add(marker.position);
                      print(marker);
                      controller.addOverlay(marker);
                    });

                    marker.setOnTapListener((NMarker tappedMarker) {
                      setState(() {
                        if (previousMarker != null) {
                          previousMarker!.setIconTintColor(Colors.transparent);
                        }
                        tappedMarker.setIconTintColor(Colors.blue);
                        previousMarker = tappedMarker;

                        // 마커 클릭 시 하단 위젯을 슬라이드하여 보이게 함
                        _bottomSheetHeight = 0.0;

                        NaverMapViewOptions(
                          indoorEnable: true,
                          locationButtonEnable: false,
                          consumeSymbolTapEvents: false,
                          initialCameraPosition: NCameraPosition(
                            target: NLatLng(
                              double.parse(dataList[int.parse(tappedMarker.info.id)][3][0]),
                              double.parse(dataList[int.parse(tappedMarker.info.id)][3][1]),
                            ),
                            zoom: 15,
                            bearing: 0,
                            tilt: 30,
                          ),
                        );
                      });
                      _setBound(
                        NLatLng(
                          double.parse(dataList[int.parse(tappedMarker.info.id)][3][0]),
                          double.parse(dataList[int.parse(tappedMarker.info.id)][3][1]),
                        ),
                      );
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
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    // 드래그하여 위젯 숨기기
                    if (details.primaryDelta! < 0) {
                      setState(() {
                        _bottomSheetHeight = 0.0;
                      });
                    } else if (details.primaryDelta! > 0) {
                      setState(() {
                        _bottomSheetHeight = -300.0; // 아래로 밀어 숨김
                      });
                    }
                  },
                  child: Container(
                    height: 300,
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("상세 정보"),
                          subtitle: Text(
                            previousMarker != null
                                ? '위치: ${dataList[int.parse(previousMarker!.info.id)][0]}'
                                : '위치: 선택된 마커 없음',
                          ),
                        ),
                      ],
                    ),
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
    print(positions);
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

    print("Updated bounds : $bounds");
    _mapController?.updateCamera(newCamera);
  }
}