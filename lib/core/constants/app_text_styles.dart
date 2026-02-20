import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String _heading = 'SpaceGrotesk';
  static const String _body    = 'Inter';
  static const String _mono    = 'JetBrainsMono';

  static TextStyle get displayLarge => const TextStyle(
        fontFamily: _heading,
        fontSize: 72,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.05,
        letterSpacing: -2,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontFamily: _heading,
        fontSize: 52,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.1,
        letterSpacing: -1.5,
      );

  static TextStyle get headingLarge => const TextStyle(
        fontFamily: _heading,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
        letterSpacing: -1,
      );

  static TextStyle get headingMedium => const TextStyle(
        fontFamily: _heading,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.25,
        letterSpacing: -0.5,
      );

  static TextStyle get headingSmall => const TextStyle(
        fontFamily: _heading,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: _body,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.7,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: _body,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: _body,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontFamily: _body,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      );

  static TextStyle get code => const TextStyle(
        fontFamily: _mono,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.accentCyan,
      );

  static TextStyle get navLabel => const TextStyle(
        fontFamily: _body,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.2,
      );

  static TextStyle get statNumber => const TextStyle(
        fontFamily: _heading,
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -1,
      );

  static TextStyle get statLabel => const TextStyle(
        fontFamily: _body,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      );

  static TextStyle get tagLabel => const TextStyle(
        fontFamily: _body,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.accent,
        letterSpacing: 0.3,
      );
}
