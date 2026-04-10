import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/shop_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GulabJewellersApp());
}

class GulabJewellersApp extends StatelessWidget {
  const GulabJewellersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShopProvider>(
      create: (_) => ShopProvider(),
      child: MaterialApp(
        title: 'Gulab Jewellers',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
