import 'dart:ui';

class AppCategories {
  static const String focus = 'High Effort\nPersonal';
  static const String social = 'High Effort\nSocial';
  static const String rest = 'Low Effort\nPersonal';
  static const String idle = 'Low Effort\nSocial';
}

class AppColors {
  // Focus (Red) - More saturated
  static const Color focusStart = Color(0xFFFF0000);
  static const Color focusEnd = Color(0xFFFF2B2B);

  // Social (Gold/Orange) - More vibrant
  static const Color socialStart = Color(0xFFFFD000);
  static const Color socialEnd = Color(0xFFFF3C00);

  // Rest (Green/Turquoise) - Saturated
  static const Color restStart = Color(0xFF00FF4C);
  static const Color restEnd = Color(0xFF00E5FF);

  // Idle (Blue/Purple) - Deep and vibrant
  static const Color idleStart = Color(0xFF0066FF);
  static const Color idleEnd = Color(0xFFB300FF);
}
