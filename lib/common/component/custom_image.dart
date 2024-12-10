import 'package:flutter/material.dart';

Widget customImage({
  required image,
  fit = BoxFit.fill,
}) {
  return Image.asset(
    image,
    fit: fit,
  );
}
