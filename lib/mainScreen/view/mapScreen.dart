import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../common/const/data.dart';

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: NAVER_MAP_KEY,
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed")
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NaverMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return MaterialApp(
      home: Scaffold(
        body: NaverMap(
          onMapTapped: (point, latLng) {
          },

          options: const NaverMapViewOptions(
            indoorEnable: true,
            locationButtonEnable: false,
            consumeSymbolTapEvents: false,
          ),
          onMapReady: (controller) async {
            mapControllerCompleter.complete(controller);
            log("onMapReady", name: "onMapReady");
          },
        ),
      ),
    );
  }

  void _setBounds(List<NLatLng> positions) {
    NLatLngBounds bounds = NLatLngBounds.from(positions);
    NCameraUpdate newCamera =
    NCameraUpdate.fitBounds(bounds, padding: const EdgeInsets.all(100.0));
    print("bounds : $bounds");
    _mapController?.updateCamera(newCamera);
  }
}