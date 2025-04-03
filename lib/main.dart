import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track3000/providers/time_provider.dart';
import 'package:track3000/screens/view/s_main.dart';
import 'package:track3000/theme/custom_theme.dart';
import 'models/bus_arrival.dart';
import 'providers/bus_provider.dart';
import 'services/bus_service.dart';
import 'package:track3000/screens/appbar/w_mode_appbar.dart';

Future<void> main() async {
  // .env 파일에서 API 키 로드
  await dotenv.load(fileName: "assets/env/.env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '버스 도착 정보',
      theme: buildThemeData(context),
      home: const BusArrivalScreen(),
    );
  }
}



