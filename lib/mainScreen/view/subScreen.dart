import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../common/component/custom_appbar.dart';
import '../../common/const/data.dart';

class SubScreen extends StatefulWidget {
  const SubScreen({super.key});

  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  List carLocation = [35.165413991450066, 129.13574871506785]; // 벡스코
  NaverMapController? _mapController;
  final double _zoomLevel = 10.0;
  List<NLatLng> mapList = [];
  bool isMapInitialized = false; // 맵 초기화 상태

  @override
  void initState() {
    super.initState();
    _initialize();
    _addCarLocationMarker();
  }

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

  void _addCarLocationMarker() {
    if (_mapController != null && carLocation.isNotEmpty) {
      final marker2 = NMarker(
        id: 'car location',
        position: NLatLng(carLocation[0], carLocation[1]),
      );

      setState(() {
        mapList.add(marker2.position);
        _mapController!.addOverlay(marker2);

        print("mapList $mapList");
      });

      final onMarkerInfoMap = NInfoWindow.onMarker(
        id: "second", // 고유 식별자
        text: "second marker",
      );

      marker2.openInfoWindow(onMarkerInfoMap);

      _setBounds(mapList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "서울 구경"),
      body: isMapInitialized
          ? Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              indoorEnable: true,
              locationButtonEnable: false,
              initialCameraPosition: NCameraPosition(
                target: const NLatLng(35.694198, 128.489457),
                zoom: _zoomLevel,
                bearing: 0,
                tilt: 30,
              ),
              mapType: NMapType.basic,
              activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
            ),
            onMapReady: (controller) {
              _mapController = controller;

              final marker = NMarker(
                id: 'current location',
                position: const NLatLng(35.694198, 128.489457),
              );

              final marker2 = NMarker(
                id: 'current location',
                position: const NLatLng(35.694198, 128.489457),
              );

              setState(() {
                mapList.add(marker.position);
                controller.addOverlay(marker);
                print(mapList);
              });

              _setBounds(mapList);
            },
          ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(), // 초기화 중 로딩 표시
      ),
    );
  }

  void _setBounds(List<NLatLng> positions) {
    NLatLngBounds bounds = NLatLngBounds.from(positions);
    NCameraUpdate newCamera = NCameraUpdate.fitBounds(bounds, padding: const EdgeInsets.all(100.0));
    print("bounds : $bounds");
    _mapController?.updateCamera(newCamera);
  }
}
