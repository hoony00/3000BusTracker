import 'package:flutter/material.dart';

ThemeData buildThemeData(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,

    // 앱바
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),

    //CircularProgressIndicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.white,
    ),

    // 다이얼로그
    dialogTheme: const DialogTheme(backgroundColor: Colors.white),
  );
}
