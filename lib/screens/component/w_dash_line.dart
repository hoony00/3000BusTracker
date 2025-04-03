import 'package:flutter/material.dart';

class DashDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double dashWidth;
  final double dashSpace;

  const DashDivider({super.key, this.color = Colors.black, this.height = 1, this.dashWidth = 5, this.dashSpace = 3});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashDividerPainter(color: color, dashWidth: dashWidth, dashSpace: dashSpace),
      size: Size(double.infinity, height),
    );
  }
}

class DashDividerPainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DashDividerPainter({required this.color, required this.dashWidth, required this.dashSpace});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height;

    double startX = 0;
    final space = dashWidth + dashSpace;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}