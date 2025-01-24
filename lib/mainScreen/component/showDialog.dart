import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_text_field.dart';
import '../../common/component/custom_toast.dart';
import '../../searchScreen/component/geoCoding.dart';

Future<void> showInputDialog(
  BuildContext context, {
  required Function(Map<String, double>) onCoordinatesUpdated,
}) async {
  String text = "";
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('검색'),
        content: CustomTextFieldWidget(
          hintText: "검색어를 입력하세요",
          onChanged: (value) => text = value,
          textSpacing: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 닫기
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (text.isNotEmpty) {
                final NaverGeocodingService geocodingService = NaverGeocodingService();

                final geocodeData = await geocodingService.fetchCoordinates(text);

                Map<String, double> dataList = {
                  "latitude": geocodeData["latitude"],
                  "longitude": geocodeData["longitude"],
                };

                print(text);
                print(geocodeData["latitude"]);

                onCoordinatesUpdated(dataList);

                Navigator.of(context).pop();
              } else {
                customToast(message: "검색어를 입력하세요");
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
