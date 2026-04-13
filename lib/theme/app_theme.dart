import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static bool _isDarkMode = false;

  static void setDarkMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
  }

  static bool get isDarkMode => _isDarkMode;

  static const Color _lightBlack = Color(0xFF221A11);
  static const Color _lightCharcoal = Color(0xFFFFFDF8);
  static const Color _lightGold = Color(0xFFC79530);
  static const Color _lightSoftGold = Color(0xFF8E6315);
  static const Color _lightSilver = Color(0xFFDCD2C0);
  static const Color _lightCream = Color(0xFF3A2C1A);
  static const Color _lightMaroon = Color(0xFF7B5443);
  static const Color _lightCanvas = Color(0xFFF9F3E7);
  static const Color _lightBorder = Color(0xFFE9DBC2);
  static const Color _lightMutedText = Color(0xFF75644D);

  static const Color _darkBlack = Color(0xFF0D0D0D);
  static const Color _darkCharcoal = Color(0xFF1A1A1A);
  static const Color _darkGold = Color(0xFFD4A017);
  static const Color _darkSoftGold = Color(0xFFF3D57B);
  static const Color _darkSilver = Color(0xFFC0C0C0);
  static const Color _darkCream = Color(0xFFF5F0E8);
  static const Color _darkMaroon = Color(0xFF5A1E1E);
  static const Color _darkCanvas = Color(0xFF0D0D0D);
  static const Color _darkBorder = Color(0xFF3B3227);
  static const Color _darkMutedText = Color(0xFFC8B79B);

  static Color get black => _isDarkMode ? _darkBlack : _lightBlack;
  static Color get charcoal => _isDarkMode ? _darkCharcoal : _lightCharcoal;
  static Color get gold => _isDarkMode ? _darkGold : _lightGold;
  static Color get softGold => _isDarkMode ? _darkSoftGold : _lightSoftGold;
  static Color get silver => _isDarkMode ? _darkSilver : _lightSilver;
  static Color get cream => _isDarkMode ? _darkCream : _lightCream;
  static Color get maroon => _isDarkMode ? _darkMaroon : _lightMaroon;
  static Color get canvas => _isDarkMode ? _darkCanvas : _lightCanvas;
  static Color get border => _isDarkMode ? _darkBorder : _lightBorder;
  static Color get mutedText => _isDarkMode ? _darkMutedText : _lightMutedText;

  static const LinearGradient _lightBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFFFFFCF5),
      Color(0xFFF8EFD9),
      Color(0xFFFFF8EC),
      Color(0xFFF7EDDA),
    ],
    stops: <double>[0.0, 0.32, 0.66, 1.0],
  );

  static const LinearGradient _darkBackground = LinearGradient(
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

  static LinearGradient get appBackground =>
      _isDarkMode ? _darkBackground : _lightBackground;
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
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final ThemeData base = ThemeData(
      brightness: brightness,
      useMaterial3: true,
    );
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.gold,
      secondary: AppColors.maroon,
      tertiary: AppColors.softGold,
      surface: AppColors.charcoal,
      onSurface: AppColors.cream,
      outline: AppColors.border,
      onPrimary: isDark ? AppColors.black : Colors.white,
      onSecondary: Colors.white,
      shadow: AppColors.black.withValues(alpha: 0.12),
    );

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
            color: isDark ? AppColors.cream : AppColors.black,
            height: 1.5,
          ),
          bodyMedium: GoogleFonts.lato(
            fontSize: 14,
            color: isDark
                ? AppColors.cream.withValues(alpha: 0.9)
                : AppColors.black.withValues(alpha: 0.88),
            height: 1.45,
          ),
          bodySmall: GoogleFonts.lato(
            fontSize: 12,
            color: AppColors.mutedText,
          ),
        );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.canvas,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? AppColors.black.withValues(alpha: 0.86)
            : AppColors.canvas.withValues(alpha: 0.92),
        foregroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.cream),
      ),
      cardTheme: CardThemeData(
        color: AppColors.charcoal.withValues(alpha: isDark ? 0.92 : 0.96),
        elevation: isDark ? 4 : 3,
        shadowColor: AppColors.black.withValues(alpha: isDark ? 0.35 : 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerColor: AppColors.border,
      dividerTheme: DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(color: AppColors.cream),
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
          color: isDark ? AppColors.black : Colors.white,
          fontWeight: FontWeight.w700,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.charcoal : AppColors.black,
        contentTextStyle: GoogleFonts.lato(
          color: isDark ? AppColors.cream : Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: isDark ? AppColors.black : Colors.white,
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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.cream,
          side: BorderSide(color: AppColors.gold.withValues(alpha: 0.45)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.lato(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.charcoal,
        hintStyle: GoogleFonts.lato(color: AppColors.mutedText),
        prefixIconColor: AppColors.softGold,
        suffixIconColor: AppColors.softGold,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.8)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.charcoal.withValues(alpha: 0.95),
        indicatorColor: AppColors.gold.withValues(alpha: isDark ? 0.25 : 1),
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: isDark ? AppColors.softGold : Colors.white);
          }
          return IconThemeData(color: AppColors.mutedText);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
          Set<WidgetState> states,
        ) {
          final bool selected = states.contains(WidgetState.selected);
          return GoogleFonts.lato(
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? AppColors.cream : AppColors.mutedText,
          );
        }),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.softGold,
          textStyle: GoogleFonts.lato(fontWeight: FontWeight.w700),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.gold;
          }
          return isDark ? AppColors.silver : Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.gold.withValues(alpha: 0.38);
          }
          return AppColors.border.withValues(alpha: isDark ? 0.34 : 0.75);
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.gold,
        linearTrackColor: AppColors.border.withValues(alpha: 0.35),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.softGold,
        textColor: AppColors.cream,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.charcoal,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.charcoal,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
