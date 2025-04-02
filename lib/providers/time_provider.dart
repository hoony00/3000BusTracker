import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountdownNotifier extends StateNotifier<Duration> {
  Timer? _timer;
  final DateTime targetTime;

  CountdownNotifier({required this.targetTime})
      : super(targetTime.difference(DateTime.now())) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = targetTime.difference(DateTime.now());
      if (diff.isNegative) {
        state = Duration.zero;
        _timer?.cancel();
      } else {
        state = diff;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Family provider: 도착 시각을 파라미터로 받아 해당 타이머 상태를 관리
final countdownProvider = StateNotifierProvider.family<CountdownNotifier, Duration, DateTime>(
      (ref, targetTime) => CountdownNotifier(targetTime: targetTime),
);
