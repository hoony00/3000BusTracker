import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';  // 날짜 포맷팅을 위한 패키지

import '../../models/bus_arrival.dart';
import '../../providers/bus_provider.dart';
import '../../providers/time_provider.dart';
import '../../services/bus_service.dart';

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
class _BusArrivalCardState extends ConsumerState<BusArrivalCard> with TickerProviderStateMixin {
  late final DateTime targetArrivalTime;
  late final AnimationController _shakeController;
  late final Animation<Offset> _shakeAnimation;  // Animation<Offset>으로 수정

  @override
  void initState() {
    super.initState();
    targetArrivalTime = DateTime.now().add(
      Duration(seconds: widget.busArrival.arrivalTime),
    );

    // 애니메이션 컨트롤러 초기화
    _shakeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // 애니메이션 설정 (좌우로 흔들리기)
    _shakeAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.05, 0.0),
    ).animate(CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));  // Animation<Offset>으로 변경
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = ref.watch(countdownProvider(targetArrivalTime));
    final minutes = remainingTime.inMinutes;
    final seconds = remainingTime.inSeconds % 60;
    final timeString = '$minutes:${seconds.toString().padLeft(2, '0')}';

    final arrivalTime = targetArrivalTime.add(remainingTime);
    final formattedArrivalTime = DateFormat('h:mm a').format(arrivalTime);

    final isTimeCritical = remainingTime.inMinutes < 2;

    // 'isTimeCritical'이 true일 때 애니메이션을 시작
    if (isTimeCritical) {
      _shakeController.repeat(reverse: true);
    } else {
      _shakeController.stop();
    }

    final isMisa = ref.watch(selectedStationProvider) == BusStations.misaStation;

    Color customColor = isMisa ? const Color(0xFF33B5E5) : const Color(0xFF7ED321);

    return Center(
      child: Card(
        surfaceTintColor: Colors.transparent,
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(12),
        child: Stack(
          children: [

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: customColor, size: 30),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          widget.stationName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '남은 정류장: ${widget.busArrival.prevStationCount}개',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '도착 예정 시간: $formattedArrivalTime',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
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
                            color: customColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              ShakeTransition(
                                animation: _shakeAnimation,  // 변경된 애니메이션 타입 사용
                                child: Icon(
                                  color: Colors.white,
                                  Icons.timer,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                timeString,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isMisa ? const Color(0xFF7ED321) : const Color(0xFF33B5E5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Text(
                  isMisa ? '성남행' : '하남행',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShakeTransition extends AnimatedWidget {
  final Widget child;

  const ShakeTransition({
    super.key,
    required Animation<Offset> animation,  // Animation<Offset>으로 수정
    required this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<Offset>;
    return SlideTransition(position: animation, child: child);
  }
}
