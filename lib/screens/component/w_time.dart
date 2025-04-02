import 'dart:async';

import 'package:flutter/cupertino.dart';

class CountdownTimer extends StatefulWidget {
  final int initialSeconds;

  const CountdownTimer({super.key, required this.initialSeconds});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  late int remainingSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.initialSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          if (remainingSeconds > 0) {
            remainingSeconds--;
          } else {
            timer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '$minutes분 ${seconds.toString().padLeft(2, '0')}초';
  }

  @override
  Widget build(BuildContext context) {
    return Text('도착까지 $formattedTime');
  }
}