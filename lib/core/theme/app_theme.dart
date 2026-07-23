import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF006C53); // Teal
  static const Color onPrimaryLight = Colors.white;
  static const Color primaryContainerLight = Color(0xFF75F8D1);
  static const Color onPrimaryContainerLight = Color(0xFF002117);

  static const Color secondaryLight = Color(0xFF4C635A);
  static const Color onSecondaryLight = Colors.white;
  static const Color secondaryContainerLight = Color(0xFFCEE9DD);
  static const Color onSecondaryContainerLight = Color(0xFF092018);

  static const Color tertiaryLight = Color(0xFF406276);
  static const Color onTertiaryLight = Colors.white;
  static const Color tertiaryContainerLight = Color(0xFFC4E7FF);
  static const Color onTertiaryContainerLight = Color(0xFF001E2D);

  static const Color backgroundLight = Color(0xFFFBFDF9);
  static const Color onBackgroundLight = Color(0xFF191C1B);
  static const Color surfaceLight = Color(0xFFFBFDF9);
  static const Color onSurfaceLight = Color(0xFF191C1B);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF56DBB6);
  static const Color onPrimaryDark = Color(0xFF00382A);
  static const Color primaryContainerDark = Color(0xFF00513E);
  static const Color onPrimaryContainerDark = Color(0xFF75F8D1);

  static const Color secondaryDark = Color(0xFFB3CCC1);
  static const Color onSecondaryDark = Color(0xFF1E352D);
  static const Color secondaryContainerDark = Color(0xFF354B43);
  static const Color onSecondaryContainerDark = Color(0xFFCEE9DD);

  static const Color tertiaryDark = Color(0xFFA8CBE4);
  static const Color onTertiaryDark = Color(0xFF0C3446);
  static const Color tertiaryContainerDark = Color(0xFF274B5E);
  static const Color onTertiaryContainerDark = Color(0xFFC4E7FF);

  static const Color backgroundDark = Color(0xFF191C1B);
  static const Color onBackgroundDark = Color(0xFFE1E3E0);
  static const Color surfaceDark = Color(0xFF191C1B);
  static const Color onSurfaceDark = Color(0xFFE1E3E0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryLight,
        onPrimary: onPrimaryLight,
        primaryContainer: primaryContainerLight,
        onPrimaryContainer: onPrimaryContainerLight,
        secondary: secondaryLight,
        onSecondary: onSecondaryLight,
        secondaryContainer: secondaryContainerLight,
        onSecondaryContainer: onSecondaryContainerLight,
        tertiary: tertiaryLight,
        onTertiary: onTertiaryLight,
        tertiaryContainer: tertiaryContainerLight,
        onTertiaryContainer: onTertiaryContainerLight,
        error: Color(0xFFBA1A1A),
        onError: Colors.white,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
        background: backgroundLight,
        onBackground: onBackgroundLight,
        surface: surfaceLight,
        onSurface: onSurfaceLight,
      ),
      fontFamily: 'Inter', // Assuming Inter or Roboto
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: onBackgroundLight),
        titleTextStyle: TextStyle(
          color: onBackgroundLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryDark,
        onPrimary: onPrimaryDark,
        primaryContainer: primaryContainerDark,
        onPrimaryContainer: onPrimaryContainerDark,
        secondary: secondaryDark,
        onSecondary: onSecondaryDark,
        secondaryContainer: secondaryContainerDark,
        onSecondaryContainer: onSecondaryContainerDark,
        tertiary: tertiaryDark,
        onTertiary: onTertiaryDark,
        tertiaryContainer: tertiaryContainerDark,
        onTertiaryContainer: onTertiaryContainerDark,
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        background: backgroundDark,
        onBackground: onBackgroundDark,
        surface: surfaceDark,
        onSurface: onSurfaceDark,
      ),
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: onBackgroundDark),
        titleTextStyle: TextStyle(
          color: onBackgroundDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
