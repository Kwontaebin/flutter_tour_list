import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../common/component/custom_appbar.dart';

class SubScreen extends StatefulWidget {
  const SubScreen({super.key});

  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  List markerList = [];
  NaverMapController? _mapController;
  final double _zoomLevel = 10.0;
  List<NLatLng> mapList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "서울 구경"),
      body: Stack(
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
                id: 'test',
                position: const NLatLng(35.694198, 128.489457),
              );
              final marker1 = NMarker(
                id: 'test1',
                position: const NLatLng(37.507310, 127.043614),
              );

              setState(() {
                mapList.add(marker.position);
                mapList.add(marker1.position);
              });

              controller.addOverlayAll({marker, marker1});

              final onMarkerInfoWindow = NInfoWindow.onMarker(id: marker.info.id, text: "멋쟁이 사자처럼");
              marker.openInfoWindow(onMarkerInfoWindow);

              print(mapList);

              _setBoundList(mapList);

              marker1.setOnTapListener((NMarker tappedMarker) {
                print(tappedMarker);
                setState(() {
                  const NaverMapViewOptions(
                    indoorEnable: true,
                    locationButtonEnable: false,
                    consumeSymbolTapEvents: false,

                    initialCameraPosition: NCameraPosition(
                      target: NLatLng(37.507310, 127.043614),
                      zoom: 100.0,
                      bearing: 0,
                      tilt: 30,
                    ),
                  );
                });

                _setBound(const NLatLng(37.507310, 127.043614));
              });
            },
          ),
        ],
      ),
    );
  }

  void _setBoundList(List<NLatLng> positions) {
    NLatLngBounds bounds = NLatLngBounds.from(positions);
    NCameraUpdate newCamera = NCameraUpdate.fitBounds(bounds, padding: const EdgeInsets.all(100.0));
    print("bounds : $bounds");
    _mapController?.updateCamera(newCamera);
  }

  void _setBound(NLatLng position) {
    // 단일 좌표를 기준으로 경계를 생성
    NLatLngBounds bounds = NLatLngBounds(
      southWest: position,
      northEast: position,
    );

    NCameraUpdate newCamera = NCameraUpdate.fitBounds(
      bounds,
      padding: const EdgeInsets.all(100.0),
    );

    print("bound : $bounds");
    _mapController?.updateCamera(newCamera);
  }
}
