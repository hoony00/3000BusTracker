import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bus_arrival.dart';
import '../services/bus_service.dart';

final selectedStationProvider = StateProvider<Map<String, String>>((ref) => BusStations.misaStation);

final busServiceProvider = Provider((ref) => BusService());


final busArrivalProvider = FutureProvider<List<BusArrival>>((ref) async {
  final busService = ref.watch(busServiceProvider);
  final station = ref.watch(selectedStationProvider);

  return await busService.getBusArrivalInfo(
    nodeId: station['nodeId']!,
    routeId: station['routeId']!,
    cityId: station['cityId']!,
  );
}); 