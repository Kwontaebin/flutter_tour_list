import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_appbar.dart';
import 'package:flutter_tour_list/common/component/custom_elevatedButton.dart';
import 'package:flutter_tour_list/common/component/custom_text_field.dart';
import '../../common/const/data.dart';
import '../component/geoCoding.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final NaverGeocodingService _geocodingService = NaverGeocodingService();
  late var address = "";
  List dataList = [];
  String? _latitude;
  String? _longitude;

  Future<void> _getCoordinates() async {
    var dio = Dio();

    String url = API_URL;

    Map<String, dynamic> queryParameters = {
      'serviceKey': API_SERVICES_KEY,
      'pageNo': 1,
      'numOfRows': 5,
      'MobileOS': 'IOS',
      'MobileApp': '서울 여행',
      'baseYm': '202411',
      'areaCd': 11,
      'signguCd': 11110,
      '_type': 'JSON',
    };

    try {
      Response response = await dio.get(url, queryParameters: queryParameters);

      for(int i = 0; i < response.data['response']["body"]["numOfRows"]; i++) {
        final result = await _geocodingService.fetchCoordinates(response.data['response']["body"]["items"]["item"][i]["rlteBsicAdres"]);
        setState(() {
          _latitude = result['latitude'].toString();
          _longitude = result['longitude'].toString();

          dataList.add([response.data["response"]["body"]["items"]["item"][i]["rlteTatsNm"], [_latitude, _longitude]]);
        });
        print(dataList);
      }
    } catch (e) {
      // 오류 처리
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "네이버 지도",
        showLeading: false
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFieldWidget(
              hintText: "",
              textSpacing: true,
              myControllerText: address,
              onChanged: (value) {
                address = value;
              },
            ),
            const SizedBox(height: 16),
            customElevatedButton(
              context,
              text: "button",
              onPressed: _getCoordinates,
            ),
            const SizedBox(height: 16),
            if (_latitude != null && _longitude != null) ...[
              Text('Latitude: $_latitude'),
              Text('Longitude: $_longitude'),
            ]
          ],
        ),
      ),
    );
  }
}
