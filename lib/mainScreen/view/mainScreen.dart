import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_appbar.dart';
import 'package:flutter_tour_list/common/function/navigator.dart';
import 'package:flutter_tour_list/common/function/sizeFn.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_tour_list/mainScreen/view/locationInformation.dart';
import 'package:provider/provider.dart';
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
  int _clickedMarkerId = 0;
  String _urlLink = "";
  Future<String>? _urlLinkFuture;

  @override
  Widget build(BuildContext context) {
    List dataList = context.read<DataProvider>().dataList;
    NMarker? previousMarker;
    NMarker marker;

    return Scaffold(
      appBar: CustomAppBar(
        title: "서울 구경",
        bgColor: Colors.white,
        showLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
        ],
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

                await getUrlLink(
                  symbol.position.latitude,
                  symbol.position.longitude,
                  symbol.caption,
                );

                navigatorFn(context, LocationInformationScreen(urlLink: _urlLink));
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
                    });

                    await getUrlLink(
                      double.parse(dataList[_clickedMarkerId][1][0]),
                      double.parse(dataList[_clickedMarkerId][1][1]),
                      dataList[_clickedMarkerId][0],
                    );

                    navigatorFn(context, LocationInformationScreen(urlLink: _urlLink));
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

  Future<void> getUrlLink(double lat, double lon, String name) async {
    setState(() {
      if (mounted) _urlLinkFuture = getLocationInformation(lat, lon, name);
    });

    try {
      _urlLink = await _urlLinkFuture!;
      setState(() {}); // 값 변경 감지
      print("Updated _urlLink value: $_urlLink");
    } catch (e) {
      print("Error fetching URL: $e");
    }

    markerZoom(lat, lon);
  }
}
