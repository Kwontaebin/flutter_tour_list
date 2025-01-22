import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_tour_list/common/component/custom_appbar.dart';
import 'package:flutter_tour_list/common/const/data.dart';
import 'package:flutter_tour_list/common/function/navigator.dart';
import 'package:flutter_tour_list/common/function/postDio.dart';
import 'package:flutter_tour_list/mainScreen/view/mainScreen.dart';
import 'package:provider/provider.dart';
import '../component/geoCoding.dart';

class DataProvider with ChangeNotifier {
  List _dataList = [];

  List get dataList => _dataList;

  void setDataList(List dataList) {
    _dataList = dataList;

    notifyListeners();
  }

  Future<void> clearDataList() async {
    _dataList.clear(); // 저장한 값 삭제
    notifyListeners();
  }
}

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

  Map<String, dynamic> responseData = {}; // 응답을 받는 데이터
  Map<String, dynamic> requestData = {}; // 요청을 보내는 데이트
  final NaverGeocodingService _geocodingService = NaverGeocodingService();
  List dataList = [];
  String? _latitude;
  String? _longitude;
  var dio = Dio();

  @override
  void initState() {
    super.initState();

    getNaverMap();
  }

  void getNaverMap() async {
    WidgetsFlutterBinding.ensureInitialized();
    await NaverMapSdk.instance.initialize(
      clientId: NAVER_MAP_KEY,
      onAuthFailed: (ex) => log("인증 오류 ${ex.message}"),
    );
  }

  void storageData(BuildContext context, int index) async {
    setState(() {
      requestData = {
        'area': areaList[index],
      };
    });

    await postDio(
      postData: requestData,
      url: "search",
      onData: (Map<String, dynamic> data) async {
        if (data["statusCode"] == 200) {
          setState(() {
            responseData = data["data"][0];
          });

          String url = API_URL;

          Map<String, dynamic> queryParameters = {
            'serviceKey': API_SERVICES_KEY,
            'pageNo': 1,
            'numOfRows': 5,
            'MobileOS': 'IOS',
            'MobileApp': '서울 여행',
            'baseYm': '202411',
            'areaCd': responseData["area_num"],
            'signguCd': responseData["detail_area_num"],
            '_type': 'JSON',
          };

          Response response = await dio.get(url, queryParameters: queryParameters);

          for (int i = 0; i < response.data['response']["body"]["numOfRows"]; i++) {
            final item = response.data["response"]["body"]["items"]["item"][i];
            final result = await _geocodingService.fetchCoordinates(item["rlteBsicAdres"]);

            // final searchValue = await dio.get(
            //   "https://dapi.kakao.com/v2/local/search/keyword.JSON?x=${result['longitude'].toString()}&y=${result['latitude'].toString()}&query=${item["rlteTatsNm"]}&size=1",
            //   options: Options(
            //     headers: {
            //       "Authorization": KAKAO_SEARCH_KEY
            //     },
            //   ),
            // );
            //
            // print(searchValue.data["documents"][0]["place_url"]);

            setState(() {
              _latitude = result['latitude'].toString();
              _longitude = result['longitude'].toString();

              dataList.add([
                item["rlteTatsNm"],
                [_latitude, _longitude]
              ]);
              context.read<DataProvider>().setDataList(dataList);
            });
          }

          if (context.read<DataProvider>().dataList.isNotEmpty) {
            navigatorFn(context, const MainScreen());
          }
        }
      },
    );
  }

  Future<void> getLocationInfo(double latitude, double longitude) async {
    Dio dio = Dio();

    final url =
        'https://naveropenapi.apis.naver.com/map-reversegeocode/v2/gc?coords=$longitude,$latitude&orders=legalcode&output=json';

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'X-Naver-Client-Id': NAVER_MAP_KEY, // 네이버 클라이언트 ID
            'X-Naver-Client-Secret': NAVER_MAP_SECRET_KEY, // 네이버 클라이언트 시크릿
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        print(data); // 위치 정보 출력
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

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
            return GestureDetector(
              onTap: () async {
                storageData(context, index);
                // getLocationInfo(37.564764, 126.9818075);
              },
              child: Card(
                color: Colors.black12,
                child: Center(
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
