import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF07080E);
  static const Color surface    = Color(0xFF0C0D1B);
  static const Color card       = Color(0xFF101120);
  static const Color cardBorder = Color(0xFF17182C);

  static const Color accent      = Color(0xFF7B74CC);
  static const Color accentDim   = Color(0xFF3D3870);
  static const Color accentCyan  = Color(0xFF00C8DC);
  static const Color flutterBlue = Color(0xFF54C5F8);

  static const Color textPrimary   = Color(0xFFECEAF8);
  static const Color textSecondary = Color(0xFF7674A0);
  static const Color textMuted     = Color(0xFF3C3A58);

  static const Color green     = Color(0xFF48BB78);
  static const Color greenGlow = Color(0xFF9AE6B4);

  static const Color divider = Color(0xFF141528);

  static Color glassBackground = Colors.white.withOpacity(0.04);
  static Color glassBorder     = Colors.white.withOpacity(0.07);

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFF9C96E0)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF07080E), Color(0xFF0C0D1B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
