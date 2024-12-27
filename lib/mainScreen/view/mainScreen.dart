import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_appbar.dart';
import 'package:flutter_tour_list/common/const/data.dart';
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
  bool isMapInitialized = false; // 맵 초기화 상태
  NaverMapController? _mapController;
  List<NLatLng> mapList = [];
  final double _zoomLevel = 10.0;
  double _bottomSheetHeight = -300; // 슬라이드 바텀 시트 초기 위치 (숨겨짐)

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
    List dataList = context.read<DataProvider>().dataList;
    NMarker? previousMarker;
    NMarker marker;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "서울 구경",
        bgColor: Colors.white,
      ),
      body: isMapInitialized
          ? Container(
              width: double.infinity,
              height: deviceHeight(context),
              color: Colors.white,
              child: Stack(
                children: [
                  NaverMap(
                    options: NaverMapViewOptions(
                      indoorEnable: true,
                      locationButtonEnable: false,
                      consumeSymbolTapEvents: false,
                      initialCameraPosition: NCameraPosition(
                        target: NLatLng(
                          double.parse(dataList[0][3][0]),
                          double.parse(dataList[0][3][1]),
                        ),
                        zoom: _zoomLevel,
                        bearing: 0,
                        tilt: 30,
                      ),
                    ),

                    onMapReady: (controller) {
                      mapControllerCompleter.complete(controller);
                      log("onMapReady", name: "onMapReady");

                      final marker1 = NMarker(
                        id: 'current location2',
                        position: const NLatLng(35.694198, 128.489457),
                      );

                      setState(() {
                        mapList.add(marker1.position);
                        controller.addOverlay(marker1);
                      });

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
                            if (previousMarker != null) previousMarker!.setIconTintColor(Colors.transparent);
                            tappedMarker.setIconTintColor(Colors.blue);
                            previousMarker = tappedMarker;

                            print(dataList[int.parse(tappedMarker.info.id)][3][0]);
                            print(dataList[int.parse(tappedMarker.info.id)][3][1]);

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
                                zoom: 20, // 줌 레벨
                                bearing: 50,
                                tilt: 20,
                              ),
                            );
                          });
                        });

                        final onMarkerInfoMap = NInfoWindow.onMarker(
                          id: i.toString(),
                          text: dataList[i][0],
                        );

                        marker.openInfoWindow(onMarkerInfoMap);
                      }

                      _setBounds(mapList);
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
            )

          : const Center(child: CircularProgressIndicator()), // 초기화 중 로딩 표시
    );
  }

  void _setBounds(List<NLatLng> positions) {
    NLatLngBounds bounds = NLatLngBounds.from(positions);
    print(positions);
    NCameraUpdate newCamera = NCameraUpdate.fitBounds(bounds, padding: const EdgeInsets.all(100.0));
    _mapController?.updateCamera(newCamera);
  }
}
