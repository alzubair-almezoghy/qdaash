import 'package:flutter/material.dart';

class MasarColors {
  static const navy = Color(0xFF102A43);
  static const navyDeep = Color(0xFF0B2035);
  static const emerald = Color(0xFF078F78);
  static const mint = Color(0xFFB5E9D9);
  static const ivory = Color(0xFFF4F8F6);
  static const splash = Color(0xFFEAF5F1);
  static const ink = Color(0xFF14283B);
  static const muted = Color(0xFF81909C);
  static const line = Color(0xFFE4ECE8);
  static const coral = Color(0xFFE88870);
  static const gold = Color(0xFFE7B965);
}

class MasarTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);
  static ThemeData lightWith(Color accent) => _build(Brightness.light, accent);
  static ThemeData darkWith(Color accent) => _build(Brightness.dark, accent);

  static TextTheme _typography(Brightness brightness) {
    final foreground =
        brightness == Brightness.dark
            ? const Color(0xFFF5F8F6)
            : MasarColors.ink;
    final secondary =
        brightness == Brightness.dark
            ? const Color(0xFF92A5B0)
            : MasarColors.muted;
    TextStyle style(double size, FontWeight weight, {bool muted = false}) =>
        TextStyle(
          fontFamily: 'IBM Plex Sans Arabic',
          fontSize: size,
          fontWeight: weight,
          height: 1.5,
          color: muted ? secondary : foreground,
        );
    return TextTheme(
      headlineLarge: style(32, FontWeight.w600),
      headlineMedium: style(28, FontWeight.w600),
      headlineSmall: style(24, FontWeight.w600),
      titleLarge: style(20, FontWeight.w600),
      titleMedium: style(18, FontWeight.w600),
      titleSmall: style(16, FontWeight.w500),
      bodyLarge: style(16, FontWeight.w400),
      bodyMedium: style(14, FontWeight.w400),
      bodySmall: style(12, FontWeight.w400, muted: true),
      labelLarge: style(14, FontWeight.w600),
      labelMedium: style(12, FontWeight.w500),
      labelSmall: style(11, FontWeight.w500),
    );
  }

  static ThemeData _build(
    Brightness brightness, [
    Color accent = MasarColors.emerald,
  ]) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
      surface: dark ? const Color(0xFF142B3D) : const Color(0xFFFFFEFC),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          dark ? const Color(0xFF0C1F2F) : MasarColors.ivory,
      fontFamily: 'IBM Plex Sans Arabic',
      textTheme: _typography(brightness),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: dark ? const Color(0xFF142B3D) : const Color(0xFFFFFEFC),
        elevation: dark ? 0 : 1,
        shadowColor: MasarColors.navy.withValues(alpha: .035),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF102537) : const Color(0xFFF6F9F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: dark ? Colors.white12 : MasarColors.line,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
