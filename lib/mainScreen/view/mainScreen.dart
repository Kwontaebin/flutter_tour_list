import 'package:flutter/material.dart';
import 'package:flutter_tour_list/common/component/custom_appbar.dart';
import 'package:flutter_tour_list/common/component/custom_elevatedButton.dart';
import 'package:flutter_tour_list/common/component/custom_text_field.dart';
import '../component/geoCoding.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final NaverGeocodingService _geocodingService = NaverGeocodingService();
  late var address = "";
  String? _latitude;
  String? _longitude;

  Future<void> _getCoordinates() async {
    // if (address.isEmpty) return;


    // try {
    //   final result = await _geocodingService.fetchCoordinates(address);
    //   setState(() {
    //     _latitude = result['latitude'].toString();
    //     _longitude = result['longitude'].toString();
    //
    //     print(_latitude);
    //     print(_longitude);
    //   });
    // } catch (e) {
    //   print('Error: ${e.toString()}');
    // }
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
