import 'package:flutter/material.dart';
import 'package:tightline_news/core/gen/fonts.gen.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: FontFamily.inter,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F172A),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF9FAFB),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0F172A),
    ),
    cardColor: Colors.white,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    fontFamily: FontFamily.inter,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFF9FAFB),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF020617),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Color(0xFF020617),
      foregroundColor: Colors.white,
    ),
    cardColor: const Color(0xFF020617),
  );
}
