import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/bus_tracking_screen.dart';

Future<void> main() async {
  // .env 파일에서 API 키 로드
  await dotenv.load(fileName: "assets/env/.env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3000번 버스 위치 조회',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BusTrackingScreen(),
    );
  }
}
