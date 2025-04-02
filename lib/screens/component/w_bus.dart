import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/bus_arrival.dart';
import '../../providers/time_provider.dart';

/// 각 버스 도착 정보를 표시하는 카드 위젯 (Flex를 이용한 반응형 디자인, 힙한 테마 및 애니메이션 적용)
class BusArrivalCard extends ConsumerStatefulWidget {
  final BusArrival busArrival;
  final String stationName;

  const BusArrivalCard({
    super.key,
    required this.busArrival,
    required this.stationName,
  });

  @override
  ConsumerState<BusArrivalCard> createState() => _BusArrivalCardState();
}

class _BusArrivalCardState extends ConsumerState<BusArrivalCard> {
  late final DateTime targetArrivalTime;

  @override
  void initState() {
    super.initState();
    // 한 번만 계산해서 고정된 도착 시각으로 사용
    targetArrivalTime = DateTime.now().add(
      Duration(seconds: widget.busArrival.arrivalTime),
    );
  }

  @override
  Widget build(BuildContext context) {
    // targetArrivalTime이 고정된 값이므로 countdownProvider의 key가 계속 동일하게 유지됩니다.
    final remainingTime = ref.watch(countdownProvider(targetArrivalTime));
    final minutes = remainingTime.inMinutes;
    final seconds = remainingTime.inSeconds % 60;
    final timeString = '$minutes:${seconds.toString().padLeft(2, '0')}';

    return Center(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color(0xFF7ED321), // 연두
                Color(0xFF7ED321), // 연두
                Color(0xFF33B5E5), // 하늘/민트
                Color(0xFF33B5E5), // 하늘/민트
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 상단: 역 이름과 위치 아이콘
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white70),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.stationName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 버스 노선 정보 및 도착 시간 정보
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.busArrival.routeNumber}번 버스',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '정류장 전: ${widget.busArrival.prevStationCount}개',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.timer, color: Colors.white),
                          const SizedBox(height: 6),
                          // AnimatedSwitcher를 이용한 부드러운 타이머 전환 효과
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                            child: Text(
                              timeString,
                              key: ValueKey(timeString),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
