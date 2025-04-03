import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AnimatedLetterDialog extends StatefulWidget {
  const AnimatedLetterDialog({super.key});

  @override
  _AnimatedLetterDialogState createState() => _AnimatedLetterDialogState();
}

class _AnimatedLetterDialogState extends State<AnimatedLetterDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;

  final String title = dotenv.env['TITLE'] ?? '제목이 없습니다';
  final String description = dotenv.env['DESCRIPTION'] ?? '설명이 없습니다';


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // 위치 애니메이션 (아래에서 위로 슈웅)
    _positionAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // 아래에서 시작
      end: const Offset(0, 0), // 원래 위치로 이동
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // 불투명도 애니메이션 (처음에는 투명, 끝에는 불투명)
    _opacityAnimation = Tween<double>(
      begin: 0.0, // 처음에는 투명
      end: 1.0, // 마지막에는 불투명
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // 애니메이션 시작
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SlideTransition(
        position: _positionAnimation, // 애니메이션 위치
        child: FadeTransition(
          opacity: _opacityAnimation, // 애니메이션 불투명도
          child: Container(
            width: 350,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // SingleChildScrollView로 텍스트 내용 스크롤 가능하게 만들기
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(description,
                        style: TextStyle(fontSize: 17, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
