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
    dividerTheme: DividerThemeData(
      color: const Color(0xFF0F172A).withValues(alpha: 0.06),
      thickness: 1,
      space: 1,
    ),
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
    dividerTheme: DividerThemeData(
      color: Colors.white.withValues(alpha: 0.08),
      thickness: 1,
      space: 1,
    ),
  );
}
