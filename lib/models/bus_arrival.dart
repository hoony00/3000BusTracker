class BusArrival {
  final int arrivalTime; // 도착 예정 시간(초)
  final int prevStationCount; // 남은 정류장 수
  final String stationId; // 정류장 ID
  final String stationName; // 정류장 이름
  final String routeId; // 노선 ID
  final String routeNumber; // 노선 번호
  final String routeType; // 노선 유형

  BusArrival({
    required this.arrivalTime,
    required this.prevStationCount,
    required this.stationId,
    required this.stationName,
    required this.routeId,
    required this.routeNumber,
    required this.routeType,
  });

  // 빈 리스트일 때 리턴 할 객체
  static final empty = BusArrival(
    arrivalTime: 0,
    prevStationCount: 0,
    stationId: '',
    stationName: '',
    routeId: '',
    routeNumber: '',
    routeType: '',
  );

  // JSON의 리스트를 파싱하는 메서드
  static List<BusArrival> fromJsonList(Map<String, dynamic> json) {
    try {
      final items = json['response']['body']['items']['item'];
      if (items == null) {
        throw Exception("버스 정보가 아직 없습니다");
      }
      // items가 리스트인지 확인 (하나의 결과만 있을 때도 객체로 올 수 있으므로)
      final List<dynamic> itemList = items is List ? items : [items];
      if (itemList.isEmpty) {
        throw Exception("버스 정보가 아직 없습니다");
      }
      return itemList.map((item) {
        return BusArrival(
          arrivalTime: item['arrtime'] as int,
          prevStationCount: item['arrprevstationcnt'] as int,
          stationId: item['nodeid'] as String,
          stationName: item['nodenm'] as String,
          routeId: item['routeid'] as String,
          routeNumber: item['routeno'].toString(),
          routeType: item['routetp'] as String,
        );
      }).toList();
    } catch (e) {
      throw Exception("버스 정보가 아직 없습니다");
    }
  }
}
