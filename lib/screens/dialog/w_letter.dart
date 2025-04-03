import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../component/w_dash_line.dart';

class AnimatedLetterDialog extends StatefulWidget {
  const AnimatedLetterDialog({super.key});

  @override
  AnimatedLetterDialogState createState() => AnimatedLetterDialogState();
}

class AnimatedLetterDialogState extends State<AnimatedLetterDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;

  final String title = dotenv.env['TITLE'] ?? '제목이 없습니다';
  final String description1 = dotenv.env['DESCRIPTION_1'] ?? '설명이 없습니다';
  final String description2 = dotenv.env['DESCRIPTION_2'] ?? '설명이 없습니다';
  final String description3 = dotenv.env['DESCRIPTION_3'] ?? '설명이 없습니다';
  final String description4 = dotenv.env['DESCRIPTION_4'] ?? '설명이 없습니다';
  final String description5 = dotenv.env['DESCRIPTION_5'] ?? '설명이 없습니다';
  final String description6 = dotenv.env['DESCRIPTION_6'] ?? '설명이 없습니다';

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
              color: Color(0xFFF8E6E1), // 편지지 배경색
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목 텍스트 (편지지 스타일로)
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 23, // 크기 조정
                      fontWeight: FontWeight.w600,
                      color: Colors.black87, // 색상 변경
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 본문 내용 (단락별로 나누고 밑줄 추가)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLetterParagraph(description1),
                          _buildLetterParagraph(description2),
                          _buildLetterParagraph(description3),
                          _buildLetterParagraph(description4),
                          _buildLetterParagraph(description5),
                          _buildLetterParagraph(description6, isTitle: true),
                        ],
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

  // 편지 단락에 밑줄을 추가하는 위젯
  Widget _buildLetterParagraph(String text, {bool isTitle = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 17,
            fontWeight: !isTitle ? FontWeight.w400 : FontWeight.w600, // 제목일 때 두껍게
            color:  !isTitle ? Colors.black87 : Colors.black87, // 색상 변경
            height: 1.6, // 줄 간격 조정
          ),
        ),
        const SizedBox(height: 10),
        !isTitle
            ?
            // 쪼개진 divider
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DashDivider(height: .5, color: Colors.brown[700]!, dashWidth: 10),
            )
            : SizedBox.shrink(),

      ],
    );
  }
}
