import 'package:flutter/material.dart';

void navigatorFn(BuildContext context, Widget routeName) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => routeName,
    ),
  );
}