import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_appbar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "서울 구경"),
      body: SizedBox(),
    );
  }
}
