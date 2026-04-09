import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/shop_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ShriJewellersApp());
}

class ShriJewellersApp extends StatelessWidget {
  const ShriJewellersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShopProvider>(
      create: (_) => ShopProvider(),
      child: MaterialApp(
        title: 'Shri Jewellers',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
