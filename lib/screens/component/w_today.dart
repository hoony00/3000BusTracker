import 'package:flutter/material.dart';

class TodayWidget extends StatelessWidget {
  const TodayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final baseDate = DateTime(2025, 4, 3);
    final currentDate = DateTime.now();

    final daysLeft = baseDate.difference(currentDate).inDays.abs() + 1;

    return Positioned(
      bottom: 50,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '❤️+$daysLeft',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
