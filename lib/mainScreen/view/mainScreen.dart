import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_appbar.dart';
import 'package:flutter_tour_list/common/function/sizeFn.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';
import '../../common/component/webview.dart';
import '../../common/const/data.dart';
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
  double? _bottomSheetHeight = -1000.0;
  int _clickedMarkerId = 0;
  String _urlLink = "";
  Future<String>? _urlLinkFuture;

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
              onSymbolTapped: (symbol) async {
                print(symbol.caption);
                print(symbol.position);

                setState(() {
                  _urlLinkFuture = getLocationInformation(
                    symbol.position.latitude,
                    symbol.position.longitude,
                    symbol.caption,
                  );
                });

                try {
                  _urlLink = await _urlLinkFuture!;
                  setState(() {});
                  print("Updated _urlLink value: $_urlLink");
                } catch (e) {
                  print("Error fetching URL: $e");
                }

                markerZoom(
                  symbol.position.latitude,
                  symbol.position.longitude,
                );
              },
              onMapReady: (controller) {
                _mapController = controller;
                mapControllerCompleter.complete(controller);
                log("onMapReady", name: "onMapReady");

                print(dataList);

                for (int i = 0; i < dataList.length; i++) {
                  marker = NMarker(
                    id: i.toString(),
                    position: NLatLng(
                      double.parse(dataList[i][1][0]),
                      double.parse(dataList[i][1][1]),
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

                  marker.setOnTapListener((NMarker tappedMarker) async {
                    print("data information ${dataList[int.parse(tappedMarker.info.id)][0]}");

                    setState(() {
                      if (previousMarker != null && mounted) {
                        previousMarker!.setIconTintColor(Colors.transparent);
                      }
                      tappedMarker.setIconTintColor(Colors.blue);
                      previousMarker = tappedMarker;
                      _clickedMarkerId = int.parse(tappedMarker.info.id);

                      _urlLinkFuture = getLocationInformation(
                        double.parse(dataList[_clickedMarkerId][1][0]),
                        double.parse(dataList[_clickedMarkerId][1][1]),
                        dataList[_clickedMarkerId][0],
                      );
                    });

                    try {
                      _urlLink = await _urlLinkFuture!;
                      setState(() {});
                      print("Updated _urlLink value: $_urlLink");
                    } catch (e) {
                      print("Error fetching URL: $e");
                    }

                    markerZoom(
                      double.parse(dataList[_clickedMarkerId][1][0]),
                      double.parse(dataList[_clickedMarkerId][1][1]),
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
            AnimatedPositioned(
              bottom: _bottomSheetHeight,
              left: 0,
              right: 0,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                // onVerticalDragUpdate: (details) {
                //   setState(() {
                //     details.primaryDelta! < 0
                //         ? _bottomSheetHeight = 0.0
                //         : _bottomSheetHeight = double.infinity;
                //         // : _bottomSheetHeight = -MediaQuery.of(context).size.height * 1.0;
                //   });
                // },
                child: Container(
                  height: MediaQuery.of(context).size.height * 1.0,
                  color: Colors.white,
                  child: _urlLink.isEmpty ? const Center(child: Text("정보가 없습니다")) : WebViewExample(linkUrl: _urlLink),
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
    const double offset = 0.005;

    NLatLngBounds bounds = NLatLngBounds(
      southWest: NLatLng(position.latitude - offset, position.longitude - offset),
      northEast: NLatLng(position.latitude + offset, position.longitude + offset),
    );

    NCameraUpdate newCamera = NCameraUpdate.fitBounds(
      bounds,
      padding: const EdgeInsets.all(50.0),
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

  Future<String> getLocationInformation(double lat, double lon, String name) async {
    var dio = Dio();

    final searchValue = await dio.get(
      "https://dapi.kakao.com/v2/local/search/keyword.JSON?x=$lon&y=$lat&query=$name&size=1",
      options: Options(
        headers: {"Authorization": KAKAO_SEARCH_KEY},
      ),
    );

    String value = searchValue.data["documents"][0]["place_url"];

    return value;
  }
}
