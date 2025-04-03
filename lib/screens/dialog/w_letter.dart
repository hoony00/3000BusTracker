import 'package:flutter/material.dart';

class AnimatedLetterDialog extends StatefulWidget {
  const AnimatedLetterDialog({super.key});

  @override
  _AnimatedLetterDialogState createState() => _AnimatedLetterDialogState();
}

class _AnimatedLetterDialogState extends State<AnimatedLetterDialog> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 10), // 아래에서 시작
      end: const Offset(0, 5),   // 원래 위치로 이동
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showLetterDialog(BuildContext context) {
    _controller.forward(); // 애니메이션 시작

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SlideTransition(
            position: _animation,
            child: Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '편지 제목',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '여기 텍스트 내용이 들어갑니다. 아주아주 이쁜 다이얼로그입니다!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('애니메이션 편지지 다이얼로그'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => _showLetterDialog(context),
          child: Text(
            '여기를 클릭하세요!',
            key: ValueKey('modeText'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black, // 텍스트 색상: 검정
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AnimatedLetterDialog(),
  ));
}
