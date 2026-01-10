import 'package:flutter/material.dart';

class AppTheme {
  static const Color navyBlue = Color(0xFF0A192F);
  // Primary background color
  static const Color darkBlue = Color(0xFF0A192F);
  // Accent color for CTAs and highlights
  static const Color neonGreen = Color(0xFF39FF14);
  // Text colors
  static const Color textWhite = Colors.white;
  static const Color textGray = Color(0xFFB0B3B8);

  // Font family
  static const String fontFamily = 'Montserrat'; // Use 'Poppins' or 'Montserrat'

  static BoxDecoration glassmorphicDecoration({
    double borderRadius = 16.0,
    double opacity = 0.08,
    double borderOpacity = 0.15,
  }) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity), // Frosted glass effect on dark background
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withOpacity(borderOpacity),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static ThemeData get themeData => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBlue,
        primaryColor: darkBlue,
        colorScheme: ColorScheme.dark(
          primary: darkBlue,
          secondary: neonGreen,
        ),
        fontFamily: fontFamily,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: textWhite,
          ),
          bodyMedium: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: textWhite,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: neonGreen,
            foregroundColor: darkBlue,
            textStyle: const TextStyle(
              fontFamily: fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkBlue,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: textGray.withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: textGray.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: neonGreen,
            ),
          ),
          labelStyle: TextStyle(
            color: textGray.withOpacity(0.7),
            fontFamily: fontFamily,
          ),
        ),
      );
}
