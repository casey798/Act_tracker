import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);

  // Quadrant 1: High Energy / Social ("The Hype") -> Warm Yellow to Solar Orange
  static const Color q1Start = Color(0xFFFFD05C);
  static const Color q1End = Color(0xFFFF6B35);

  // Quadrant 2: High Energy / Focus ("The Grind") -> Electric Red to Intense Pink
  static const Color q2Start = Color(0xFFFF4B4B);
  static const Color q2End = Color(0xFFFF9E9E);

  // Quadrant 3: Low Energy / Restoration ("The Recharge") -> Mint Green to Teal
  static const Color q3Start = Color(0xFF4ADE80);
  static const Color q3End = Color(0xFF2DD4BF);

  // Quadrant 4: Low Energy / Passive ("The Idle") -> Soft Blue to Periwinkle
  static const Color q4Start = Color(0xFF60A5FA);
  static const Color q4End = Color(0xFF818CF8);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: textPrimary,
      colorScheme: const ColorScheme.dark(
        primary: textPrimary,
        surface: surface,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
