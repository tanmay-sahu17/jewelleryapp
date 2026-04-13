import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/shop_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final bool initialDarkMode =
      preferences.getBool(ShopProvider.darkModePreferenceKey) ?? false;
  final String localeCode =
      preferences.getString(ShopProvider.localePreferenceKey) ?? 'en';
  final Locale initialLocale =
      localeCode == 'hi' ? const Locale('hi') : const Locale('en');

  runApp(
    GulabJewellersApp(
      initialDarkMode: initialDarkMode,
      initialLocale: initialLocale,
    ),
  );
}

class GulabJewellersApp extends StatefulWidget {
  const GulabJewellersApp({
    super.key,
    this.initialDarkMode = false,
    this.initialLocale = const Locale('en'),
  });

  final bool initialDarkMode;
  final Locale initialLocale;

  @override
  State<GulabJewellersApp> createState() => _GulabJewellersAppState();
}

class ShriJewellersApp extends GulabJewellersApp {
  const ShriJewellersApp({super.key}) : super();
}

class _GulabJewellersAppState extends State<GulabJewellersApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _applyAndroidFullscreen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _applyAndroidFullscreen();
    }
  }

  @override
  void didChangeMetrics() {
    _applyAndroidFullscreen();
  }

  Future<void> _applyAndroidFullscreen() async {
    if (!Platform.isAndroid) {
      return;
    }

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShopProvider>(
      create: (_) => ShopProvider(
        initialDarkMode: widget.initialDarkMode,
        initialLocale: widget.initialLocale,
      ),
      child: Consumer<ShopProvider>(
        builder: (BuildContext context, ShopProvider provider, Widget? child) {
          AppColors.setDarkMode(provider.isDarkMode);

          return MaterialApp(
            onGenerateTitle: (BuildContext context) {
              return AppLocalizations.of(context)!.appTitle;
            },
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            themeAnimationDuration: const Duration(milliseconds: 320),
            themeAnimationCurve: Curves.easeInOutCubic,
            locale: provider.locale,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
