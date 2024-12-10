import 'package:flutter/material.dart';
import 'package:flutter_tour_list/mainScreen/view/mainScreen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'tourList',
      home: MainScreen(),
    );
  }
}
