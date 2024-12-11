import 'package:flutter/material.dart';
import 'package:flutter_tour_list/mainScreen/view/mainScreen.dart';
import 'package:flutter_tour_list/searchScreen/view/search.dart';
import 'package:flutter_tour_list/splashScreen/view/splash.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'tourList',
      home: SearchScreen(),
    );
  }
}
