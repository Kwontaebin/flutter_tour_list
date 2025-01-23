import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/function/navigator.dart';
import 'package:flutter_tour_list/mainScreen/view/mainScreen.dart';
import '../../common/component/webview.dart';

class LocationInformationScreen extends StatefulWidget {
  final String urlLink;

  const LocationInformationScreen({
    super.key,
    required this.urlLink,
  });

  @override
  State<LocationInformationScreen> createState() => _LocationInformationScreenState();
}

class _LocationInformationScreenState extends State<LocationInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            navigatorFn(context, const MainScreen());
          },
          icon: const Icon(
            Icons.keyboard_arrow_down_sharp,
            color: Colors.black,
            size: 25.0,
          ),
        ),
      ),
      body: GestureDetector(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.0,
          color: Colors.white,
          child: WebViewExample(linkUrl: widget.urlLink),
        ),
      ),
    );
  }
}
