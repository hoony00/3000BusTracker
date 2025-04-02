import 'package:flutter_riverpod/flutter_riverpod.dart';

//StationMode enum
enum StationMode {
  misa,
  yatap,
}

final stationModeProvider = StateProvider<StationMode>((ref) {
  return StationMode.misa; // 기본값: 미사역 기준
});