import 'package:flutter/material.dart';

/// Professional color scheme for SignalX Workers App
/// Based on modern "Trust & Opportunity" design system
class AppColors {
  // Primary Brand Colors - Deep Professional Blue
  static const Color primary = Color(0xFF1E40AF); // Rich blue
  static const Color primaryDark = Color(0xFF1E3A8A); // Deeper blue
  static const Color primaryLight = Color(0xFF3B82F6); // Lighter blue
  static const Color primarySurface = Color(0xFFEFF6FF); // Very light blue

  // Secondary Colors - Success Green (for jobs/opportunities)
  static const Color secondary = Color(0xFF059669); // Emerald green
  static const Color secondaryDark = Color(0xFF047857);
  static const Color secondaryLight = Color(0xFF10B981);
  static const Color secondarySurface = Color(0xFFECFDF5);

  // Accent Colors
  static const Color accent = Color(0xFF7C3AED); // Purple for AI features
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentSurface = Color(0xFFF5F3FF);

  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningSurface = Color(0xFFFEF3C7);
  
  static const Color error = Color(0xFFDC2626); // Red
  static const Color errorSurface = Color(0xFFFEE2E2);

  // Neutral Colors
  static const Color background = Color(0xFFF8FAFC); // Light gray-blue
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceElevated = Color(0xFFF1F5F9);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Almost black
  static const Color textSecondary = Color(0xFF475569); // Medium gray
  static const Color textTertiary = Color(0xFF94A3B8); // Light gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White

  // Border & Divider
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Special Colors
  static const Color shimmer = Color(0xFFE0E7FF); // For loading states
  static const Color overlay = Color(0x80000000); // Black with 50% opacity

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF1E40AF),
      Color(0xFF1E3A8A),
    ],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF10B981),
      Color(0xFF059669),
    ],
  );

  static const LinearGradient aiGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA78BFA),
      Color(0xFF7C3AED),
    ],
  );

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF1E40AF).withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: const Color(0xFF1E40AF).withOpacity(0.12),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

class AppAssets {
  // Animations
  static const String splashAnimation = 'assets/animations/hiring.json';
}

class AppStrings {
  static const String appName = 'SignalX';
  static const String tagline = 'AI-Powered Livelihood Intelligence';
  static const String taglineShort = 'Find Work, Build Better Lives';
}

class AppSizes {
  // Padding & Margins
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;

  // Border Radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;

  // Icon Sizes
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 48.0;
}
