import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/webview.dart';
import 'package:flutter_tour_list/mainScreen/view/locationInformation.dart';
import 'package:flutter_tour_list/searchScreen/view/search.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
