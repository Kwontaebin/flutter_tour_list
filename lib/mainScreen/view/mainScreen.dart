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
              child: NaverMap(
                options: NaverMapViewOptions(
                  indoorEnable: true,
                  locationButtonEnable: false,
                  consumeSymbolTapEvents: false,
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(double.parse(dataList[0][3][0]),
                        double.parse(dataList[0][3][1])),
                    zoom: _zoomLevel,
                    bearing: 0,
                    tilt: 30,
                  ),
                ),
                onMapReady: (controller) {
                  mapControllerCompleter.complete(controller);
                  log("onMapReady", name: "onMapReady");

                  for (int i = 0; i < dataList.length; i++) {
                    final marker = NMarker(
                      id: dataList[i][0],
                      position: NLatLng(
                        double.parse(dataList[i][3][0]),
                        double.parse(dataList[i][3][1]),
                      ),
                      size: const Size(40, 50),
                    );

                    setState(() {
                      mapList.add(marker.position);
                      controller.addOverlay(marker);
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
            ) : const Center(
              child: CircularProgressIndicator() // 초기화 중 로딩 표시
            ),
    );
  }

  void _setBounds(List<NLatLng> positions) {
    NLatLngBounds bounds = NLatLngBounds.from(positions);
    NCameraUpdate newCamera =
        NCameraUpdate.fitBounds(bounds, padding: const EdgeInsets.all(100.0));
    // print("bounds : $bounds");
    _mapController?.updateCamera(newCamera);
  }
}
