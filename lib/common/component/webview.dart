import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String linkUrl;

  const WebViewExample({
    super.key,
    required this.linkUrl,
  });

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // JavaScript 활성화
      ..loadRequest(Uri.parse(widget.linkUrl)); // 원하는 URL 로드
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: SizedBox(
          height: double.infinity,
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
