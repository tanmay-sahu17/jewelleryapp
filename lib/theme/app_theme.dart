import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color black = Color(0xFF0D0D0D);
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color gold = Color(0xFFD4A017);
  static const Color softGold = Color(0xFFF3D57B);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color cream = Color(0xFFF5F0E8);
  static const Color maroon = Color(0xFF5A1E1E);

  static const LinearGradient appBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFF0A0A0A),
      Color(0xFF16110B),
      Color(0xFF120F0A),
      Color(0xFF0D0D0D),
    ],
    stops: <double>[0.0, 0.32, 0.66, 1.0],
  );
}

class SlideFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const SlideFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final CurvedAnimation curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.04, 0.02),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

class AppTheme {
  static ThemeData get darkTheme {
    final ThemeData base = ThemeData.dark(useMaterial3: true);

    final TextTheme textTheme = GoogleFonts.latoTextTheme(base.textTheme)
        .copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: AppColors.cream,
            letterSpacing: 0.4,
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.cream,
          ),
          titleLarge: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.cream,
          ),
          titleMedium: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.cream,
            letterSpacing: 0.2,
          ),
          bodyLarge: GoogleFonts.lato(
            fontSize: 15,
            color: AppColors.cream,
            height: 1.5,
          ),
          bodyMedium: GoogleFonts.lato(
            fontSize: 14,
            color: AppColors.cream.withValues(alpha: 0.9),
            height: 1.45,
          ),
          bodySmall: GoogleFonts.lato(
            fontSize: 12,
            color: AppColors.cream.withValues(alpha: 0.72),
          ),
        );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.black,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.silver,
        surface: AppColors.charcoal,
        onPrimary: AppColors.black,
        onSecondary: AppColors.black,
        onSurface: AppColors.cream,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.charcoal.withValues(alpha: 0.9),
        elevation: 10,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.gold.withValues(alpha: 0.25)),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerColor: AppColors.gold.withValues(alpha: 0.2),
      iconTheme: const IconThemeData(color: AppColors.cream),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: SlideFadePageTransitionsBuilder(),
          TargetPlatform.iOS: SlideFadePageTransitionsBuilder(),
          TargetPlatform.macOS: SlideFadePageTransitionsBuilder(),
          TargetPlatform.windows: SlideFadePageTransitionsBuilder(),
          TargetPlatform.linux: SlideFadePageTransitionsBuilder(),
        },
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.charcoal,
        selectedColor: AppColors.gold,
        disabledColor: AppColors.charcoal,
        labelStyle: GoogleFonts.lato(
          color: AppColors.cream,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: GoogleFonts.lato(
          color: AppColors.black,
          fontWeight: FontWeight.w700,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.charcoal,
        contentTextStyle: GoogleFonts.lato(
          color: AppColors.cream,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.black,
          backgroundColor: AppColors.gold,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.lato(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
    );
  }
}
