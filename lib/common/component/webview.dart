import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../mainScreen/view/locationInformation.dart';
import '../function/navigator.dart';

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
  bool status = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            print('웹뷰 에러: ${error.description}');
          },
          onPageFinished: (String url) {
            print('페이지 로딩 완료: $url');

            setState(() {
              status = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.linkUrl));
  }

  @override
  void didUpdateWidget(covariant WebViewExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.linkUrl != widget.linkUrl) {
      // URL이 변경되었을 때 새로운 URL 로드
      _controller.loadRequest(Uri.parse(widget.linkUrl));
      print(widget.linkUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: double.infinity,
        child: status
            ? WebViewWidget(controller: _controller)
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
