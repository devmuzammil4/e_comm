import 'package:flutter/material.dart';
import '../config/app_config.dart';

/// Enterprise Design Token Matrix.
/// Provides unique look-and-feel specs for Sports, Restaurants, and Marketing apps.
class DynamicThemeFactory {

  /// Generates a complete Material 3 ThemeData profile based on the loaded tenant configuration.
  static ThemeData createTheme(BusinessTenantType tenantType) {
    switch (tenantType) {
      case BusinessTenantType.sports:
        return _buildSportsTheme();
      case BusinessTenantType.restaurant:
        return _buildRestaurantTheme();
      case BusinessTenantType.marketing:
        return _buildMarketingTheme();
    }
  }

  /// High-contrast, energetic visual profile calibrated for Sports retail.
  static ThemeData _buildSportsTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFE5FF00),
        secondary: Color(0xFF00E5FF),
        surface: Color(0xFF121212),
        error: Color(0xFFFF3333),
      ),
      scaffoldBackgroundColor: const Color(0xFF000000),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        color: const Color(0xFF1E1E1E),
      ),
      typography: Typography.material2021(),
    );
  }

  /// Warm, appetizing visual profile optimized for Food and Restaurant orders.
  static ThemeData _buildRestaurantTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFF5722),
        secondary: Color(0xFF4CAF50),
        surface: Color(0xFFFFFFFF),
        error: Color(0xFFD32F2F),
      ),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        color: Colors.white,
        elevation: 2,
      ),
      typography: Typography.material2021(),
    );
  }

  /// Clean, corporate profile engineered for B2B/Marketing products.
  static ThemeData _buildMarketingTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1E3A8A),
        secondary: Color(0xFF64748B),
        surface: Color(0xFFF8FAFC),
        error: Color(0xFFEF4444),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: Colors.white,
        elevation: 1,
      ),
      typography: Typography.material2021(),
    );
  }
}
