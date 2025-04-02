import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mode_provider.dart';
import 'appbar/w_mode_appbar.dart';

class BusTrackingScreen extends ConsumerStatefulWidget {
  const BusTrackingScreen({super.key});

  @override
  ConsumerState<BusTrackingScreen> createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends ConsumerState<BusTrackingScreen> {
  NaverMapController? _mapController;

  @override 
    super.initState();
    // 주기적 갱신 활성화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(periodicRefreshProvider);
    });
  } 

  @override
  Widget build(BuildContext context) {
    // build 내에서 ref.listen 사용
    ref.listen<AsyncValue<BusLocationResponse>>(busLocationProvider, (prev, next) {
      next.whenData((data) {
        if (_mapController != null) {
          _mapController!.clearOverlays();
          final markers = _createBusMarkers(data.items.item);
          for (final marker in markers) {
            _mapController!.addOverlay(marker);
          }
        }
      });
    });

    final stationMode = ref.watch(stationModeProvider);
    final busLocationAsync = ref.watch(busLocationProvider);
    final nextBuses = ref.watch(nextBusesProvider);

    return Scaffold(
      appBar: const ModeToggleAppBar(),
      body: Column(
        children: [
          // 다음 버스 도착 정보
          Container(
            padding: const EdgeInsets.all(16),
            child: busLocationAsync.when(
              data: (_) {
                if (nextBuses.isEmpty) {
                  return const Text('현재 운행 중인 버스가 없습니다');
                }
                final apiService = ref.read(busApiServiceProvider);
                return Column(
                  children: [
                    Text(
                      '첫번째 버스: ${apiService.calculateArrivalTime(nextBuses[0].arrprevstationcnt)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (nextBuses.length > 1)
                      Text(
                        '두번째 버스: ${apiService.calculateArrivalTime(nextBuses[1].arrprevstationcnt)}',
                        style: const TextStyle(fontSize: 18),
                      ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('에러 발생: $error'),
            ),
          ),

          // 네이버 지도 표시
          Expanded(
            child: busLocationAsync.when(
              data: (data) {
                return _buildNaverMap(data.items.item, stationMode);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('에러 발생: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNaverMap(List<BusInfo> buses, StationMode mode) {
    // 초기 카메라 위치 설정
    double defaultLat = 37.5665;
    double defaultLng = 126.9780;

    // 선택된 모드에 따라 기준 위치 설정
    if (mode == StationMode.misa) {
      defaultLat = 37.5612; // 미사역 위치 (실제값 확인 필요)
      defaultLng = 127.1968;
    } else {
      defaultLat = 37.4111; // 야탑역 위치 (실제값 확인 필요)
      defaultLng = 127.1283;
    }

    // 버스가 있으면 첫 번째 버스 위치를 카메라 중심으로
    if (buses.isNotEmpty) {
      final firstBus = buses[0];
      defaultLat = firstBus.gpsLati;
      defaultLng = firstBus.gpsLong;
    }

    return NaverMap(
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: NLatLng(defaultLat, defaultLng),
          zoom: 13,
        ),
        mapType: NMapType.basic,
      ),
      onMapReady: (NaverMapController controller) {
        _mapController = controller;
        ref.read(busLocationProvider).whenData((data) {
          final markers = _createBusMarkers(data.items.item);
          for (final marker in markers) {
            controller.addOverlay(marker);
          }
        });
      },
    );
  }

  // 버스 마커 생성
  List<NMarker> _createBusMarkers(List<BusInfo> buses) {
    return buses.map((bus) {
      return NMarker(
        id: bus.vehicleno, // 차량 번호를 ID로 사용
        position: NLatLng(bus.gpsLati, bus.gpsLong),
        caption: NOverlayCaption(
          text: "3000번 버스",
          textSize: 14,
        ),
        icon: NOverlayImage.fromAssetImage('assets/images/marker.png'),
      );
    }).toList();
  }
}
