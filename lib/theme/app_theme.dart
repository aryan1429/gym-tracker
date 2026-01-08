import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2C2C2C);
  
  static const Color primary = Color(0xFF00FF88); // Neon Green
  static const Color error = Color(0xFFFF4444); // Red
  static const Color warning = Color(0xFFFFAB40); // Subtle Orange
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  
  static const Color glassBorder = Color(0x1AFFFFFF);

  // New Gradients
  static const LinearGradient mainBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1E1E), // Slightly lighter surface tone at top-left
      Color(0xFF0A0A0A), // Deep black at bottom-right
    ],
    stops: [0.0, 1.0],
  );

  static List<BoxShadow> neonShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.5),
          blurRadius: 25,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: color.withOpacity(0.2),
          blurRadius: 50,
          spreadRadius: 10,
        ),
      ];
}

class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.outfit(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    shadows: [
      Shadow(
        color: AppColors.primary.withOpacity(0.5),
        offset: const Offset(0, 0),
        blurRadius: 20,
      ),
      Shadow(
        color: Colors.black.withOpacity(0.5),
        offset: const Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  );

  static TextStyle get displayMedium => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    shadows: [
      Shadow(
        color: AppColors.primary.withOpacity(0.4),
        offset: const Offset(0, 0),
        blurRadius: 15,
      ),
      Shadow(
        color: Colors.black.withOpacity(0.5),
        offset: const Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  );

  static TextStyle get headlineLarge => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );
}

class AppTheme {
  // Neon accent colors for UI elements
  static const Color neonBlue = Color(0xFF00D9FF);
  static const Color neonPink = Color(0xFFFF006E);
  static const Color neonPurple = Color(0xFFB537F2);
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headlineLarge,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
      ),
    );
  }
}
