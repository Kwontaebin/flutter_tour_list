import 'package:flutter/material.dart';
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
            Navigator.pop(context);
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
