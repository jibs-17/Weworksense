import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Core Palette ──
  static const Color primary = Color(0xFF2B6CB0);
  static const Color primaryDark = Color(0xFF1A4F8B);
  static const Color primaryLight = Color(0xFF4A90D9);
  static const Color accent = Color(0xFFE53E3E);
  static const Color accentOrange = Color(0xFFED8936);
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFD69E2E);
  static const Color surface = Color(0xFFF7FAFC);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF718096);
  static const Color divider = Color(0xFFE2E8F0);

  // Priority Colours
  static const Color highPriority = Color(0xFFE53E3E);
  static const Color mediumPriority = Color(0xFFED8936);
  static const Color lowPriority = Color(0xFF38A169);

  // ── Decorations ──
  static BorderRadius cardRadius = BorderRadius.circular(16);
  static BorderRadius buttonRadius = BorderRadius.circular(12);
  static BorderRadius inputRadius = BorderRadius.circular(12);

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // ── Input Decoration ──
  static InputDecoration inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
      prefixIcon: icon != null ? Icon(icon, color: primary, size: 20) : null,
      filled: true,
      fillColor: const Color(0xFFF0F4F8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: inputRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: inputRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: inputRadius,
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
    );
  }

  // ── Button Styles ──
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: buttonRadius),
    elevation: 0,
    textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
  );

  static ButtonStyle outlinedButton = OutlinedButton.styleFrom(
    foregroundColor: primary,
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: buttonRadius),
    side: const BorderSide(color: primary, width: 1.5),
    textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
  );

  // ── ThemeData ──
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.poppins(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.poppins(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.poppins(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(color: textPrimary, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        labelLarge: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: cardRadius),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
      ),
    );
  }
}
