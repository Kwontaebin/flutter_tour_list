import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../function/sizeFn.dart';

Widget customLoading() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              height: deviceHeight(context) * 0.05,
              color: Colors.white,
            ),
          );
        },
      ),
    ),
  );
}