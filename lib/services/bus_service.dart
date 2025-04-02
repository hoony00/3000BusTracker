import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/bus_arrival.dart';

class BusService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://apis.data.go.kr/1613000/ArvlInfoInqireService';
  final String serviceKey = dotenv.env['API_KEY']!;

  Future<List<BusArrival>> getBusArrivalInfo({
    required String nodeId,
    required String routeId,
    required String cityId,
  }) async {
    try {

      final queryData = {
        'serviceKey': serviceKey,
        'pageNo': 1,
        'numOfRows': 10,
        '_type': 'json',
        'cityCode': cityId,
        'nodeId': nodeId,
        //'routeId': routeId,
      };

      print('조회한 역 : $nodeId');
      print('queryData : $queryData');

      final response = await _dio.get(
        '$baseUrl/getSttnAcctoSpcifyRouteBusArvlPrearngeInfoList',
        queryParameters: {
          'serviceKey': serviceKey,
          'pageNo': 1,
          'numOfRows': 10,
          '_type': 'json',
          'cityCode': cityId,
          'nodeId': nodeId,
          'routeId': routeId,
        },
      );

      print('response : $response');


      return BusArrival.fromJsonList(response.data);
    } catch (e) {
      throw Exception('버스 도착 정보를 가져오는데 실패했습니다: $e');
    }
  }
}

// 정류장 정보
class BusStations {
  static const misaStation = {
    'name': '미사강변브라운스톤',
    'nodeId': 'GGB227000514',
    'routeId': 'GGB227000038',
    'cityId': '31180'
  };
  
  static const yatapStation = {
    'name': '야탑역 종합버스터미널',
    'nodeId': 'GGB206000784',
    'routeId': 'GGB227000038',
    'cityId': '31020'
  };
} 