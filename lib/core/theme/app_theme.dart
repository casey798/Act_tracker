import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);

  // Quadrant 1: High Energy / Social (Red/Pink)
  static const Color q1Start = Color(0xFFFF512F);
  static const Color q1End = Color(0xFFDD2476);

  // Quadrant 2: High Energy / Private (Yellow/Green/Gold)
  static const Color q2Start = Color(0xFFF09819);
  static const Color q2End = Color(0xFFEDDE5D);

  // Quadrant 3: Low Energy / Social (Blue/Purple)
  static const Color q3Start = Color(0xFF4776E6);
  static const Color q3End = Color(0xFF8E54E9);

  // Quadrant 4: Low Energy / Private (Grey/Muted)
  static const Color q4Start = Color(0xFF232526);
  static const Color q4End = Color(0xFF414345);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: textPrimary,
      colorScheme: const ColorScheme.dark(
        primary: textPrimary,
        surface: surface,
        background: background,
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
