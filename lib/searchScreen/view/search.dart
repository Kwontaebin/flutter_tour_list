import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_appbar.dart';
import 'package:flutter_tour_list/common/const/data.dart';
import 'package:flutter_tour_list/common/function/postDio.dart';

import '../component/geoCoding.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> areaList = [
    '종로구',
    '중구',
    '용산구',
    '성동구',
    '광진구',
    '동대문구',
    '중랑구',
    '성북구',
    '강북구',
    '도봉구',
    '노원구',
    '은평구',
    '서대문구',
    '마포구',
    '양천구',
    '강서구',
    '구로구',
    '금천구',
    '영등포구',
    '동작구',
    '관악구',
    '서초구',
    '강남구',
    '송파구',
    '강동구'
  ];
  Map<String, dynamic> responseData = {};

  Map<String, dynamic> requestData = {};
  final NaverGeocodingService _geocodingService = NaverGeocodingService();
  List dataList = [];
  String? _latitude;
  String? _longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "서울 구경",
        bgColor: Colors.white,
        showLeading: false,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 한 줄에 3개 항목
            crossAxisSpacing: 10.0, // 항목 간의 가로 간격
            mainAxisSpacing: 10.0, // 항목 간의 세로 간격
            childAspectRatio: 1.0, // 항목의 비율 (정사각형으로 설정)
          ),
          itemCount: 25, // 총 25개의 항목
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.black12,
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      requestData = {
                        'area': areaList[index],
                      };
                    });

                    await postDio(
                      postData: requestData,
                      url: "search",
                      onSuccess: (Map<String, dynamic> data) async {
                        print(data["data"][0]);
                        setState(() {
                          responseData = data["data"][0];
                        });
                      },
                    );

                    print(responseData);

                    // var dio = Dio();
                    //
                    // String url = API_URL;
                    //
                    // Map<String, dynamic> queryParameters = {
                    //   'serviceKey': API_SERVICES_KEY,
                    //   'pageNo': 1,
                    //   'numOfRows': 5,
                    //   'MobileOS': 'IOS',
                    //   'MobileApp': '서울 여행',
                    //   'baseYm': '202411',
                    //   'areaCd': data["data"][0]["area_num"],
                    //   'signguCd': data["data"][0]["detail_area_name"],
                    //   '_type': 'JSON',
                    // };
                    //
                    // try {
                    //   Response response = await dio.get(url, queryParameters: queryParameters);
                    //
                    //   for(int i = 0; i < response.data['response']["body"]["numOfRows"]; i++) {
                    //     final result = await _geocodingService.fetchCoordinates(response.data['response']["body"]["items"]["item"][i]["rlteBsicAdres"]);
                    //     setState(() {
                    //       _latitude = result['latitude'].toString();
                    //       _longitude = result['longitude'].toString();
                    //
                    //       dataList.add([response.data["response"]["body"]["items"]["item"][i]["rlteTatsNm"], [_latitude, _longitude]]);
                    //     });
                    //     print(dataList);
                    //   }
                    // } catch (e) {
                    //   // 오류 처리
                    //   print('Error: $e');
                    // }
                  },
                  child: Text(
                    areaList[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}