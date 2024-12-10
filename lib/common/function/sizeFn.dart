import 'package:flutter/material.dart';

double deviceHeight(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final appBarHeight = AppBar().preferredSize.height;

  final bodyHeight = size.height - appBarHeight - MediaQuery.of(context).padding.top;

  return bodyHeight;
}

Size sizeFn(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return size;
}