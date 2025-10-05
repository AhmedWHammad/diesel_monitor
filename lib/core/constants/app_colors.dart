import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color accent = Color(0xFFFF9800);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color danger = Color(0xFFF44336);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF424242);

  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [primary, Color(0xFF1976D2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get accentGradient => const LinearGradient(
        colors: [accent, Color(0xFFF57C00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get tankGradient => const LinearGradient(
        colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
}
