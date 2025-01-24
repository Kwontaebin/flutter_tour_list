import 'package:dio/dio.dart';
import '../../common/const/data.dart';

class NaverGeocodingService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchCoordinates(String address) async {
    try {
      final response = await _dio.get(
        NAVER_MAP_URL,
        queryParameters: {'query': address},
        options: Options(
          headers: {
            'X-NCP-APIGW-API-KEY-ID': NAVER_MAP_KEY, // 네이버 클라이언트 ID
            'X-NCP-APIGW-API-KEY': NAVER_MAP_SECRET_KEY, // 네이버 클라이언트 Secret
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['addresses'] != null && data['addresses'].isNotEmpty) {
          final firstResult = data['addresses'][0];
          return {
            'latitude': double.parse(firstResult['y']),
            'longitude': double.parse(firstResult['x']),
          };
        } else {
          throw Exception('No results found for the given address.');
        }
      } else {
        throw Exception('Failed to fetch data from Naver API.');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}