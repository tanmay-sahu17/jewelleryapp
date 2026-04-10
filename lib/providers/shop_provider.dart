import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/dummy_data.dart';
import '../models/offer_model.dart';
import '../models/product_model.dart';

class ShopProvider extends ChangeNotifier {
  final Random _random = Random();

  String _selectedCategory = DummyData.categories.first;
  final Map<String, double> _liveRates = Map<String, double>.from(
    DummyData.liveRates,
  );
  final Map<String, double> _shopRates = Map<String, double>.from(
    DummyData.shopRates,
  );

  String get selectedCategory => _selectedCategory;
  List<String> get categories => DummyData.categories;

  Map<String, double> get liveRates => _liveRates;
  Map<String, double> get shopRates => _shopRates;
  List<Product> get products => DummyData.products;
  List<ShopOffer> get offers => DummyData.offers;
  ShopInfo get shopInfo => DummyData.shopInfo;
  BankDetails get bankDetails => DummyData.bankDetails;

  List<Product> get featuredProducts =>
      products.where((Product item) => item.isFeatured).take(4).toList();

  List<Product> get filteredProducts {
    if (_selectedCategory == 'All') {
      return products;
    }

    if (_selectedCategory == 'Gold' || _selectedCategory == 'Silver') {
      return products
          .where((Product item) => item.metalType == _selectedCategory)
          .toList();
    }

    return products
        .where((Product item) => item.category == _selectedCategory)
        .toList();
  }

  void setCategory(String category) {
    if (_selectedCategory == category) {
      return;
    }
    _selectedCategory = category;
    notifyListeners();
  }

  double estimatePrice(Product product) {
    // Rates are stored per 10g; convert to per-gram for weight-based estimates.
    return (_resolveRate(product) / 10) * product.weight;
  }

  double _resolveRate(Product product) {
    if (product.metalType == 'Silver') {
      return _liveRates['Silver'] ?? 0;
    }

    if (product.purity.contains('24')) {
      return _liveRates['Gold24K'] ?? 0;
    }

    return _liveRates['Gold22K'] ?? 0;
  }

  Future<void> refreshHomeData() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    _liveRates['Gold22K'] = _jitter(_liveRates['Gold22K'] ?? 68500, 180);
    _liveRates['Gold24K'] = _jitter(_liveRates['Gold24K'] ?? 74700, 220);
    _liveRates['Silver'] = _jitter(_liveRates['Silver'] ?? 890, 20);

    _shopRates['Gold22K'] = (_liveRates['Gold22K'] ?? 68500) - 200;
    _shopRates['Gold24K'] = (_liveRates['Gold24K'] ?? 74700) - 250;
    _shopRates['Silver'] = (_liveRates['Silver'] ?? 890) - 10;

    notifyListeners();
  }

  double _jitter(double value, int delta) {
    final int shift = _random.nextInt((delta * 2) + 1) - delta;
    return value + shift;
  }
}
