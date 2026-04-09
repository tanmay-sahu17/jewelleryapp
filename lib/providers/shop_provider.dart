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
    return _resolveRate(product) * product.weight;
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

    _liveRates['Gold22K'] = _jitter(_liveRates['Gold22K'] ?? 6850, 18);
    _liveRates['Gold24K'] = _jitter(_liveRates['Gold24K'] ?? 7470, 22);
    _liveRates['Silver'] = _jitter(_liveRates['Silver'] ?? 89, 2);

    _shopRates['Gold22K'] = (_liveRates['Gold22K'] ?? 6850) - 20;
    _shopRates['Gold24K'] = (_liveRates['Gold24K'] ?? 7470) - 25;
    _shopRates['Silver'] = (_liveRates['Silver'] ?? 89) - 1;

    notifyListeners();
  }

  double _jitter(double value, int delta) {
    final int shift = _random.nextInt((delta * 2) + 1) - delta;
    return value + shift;
  }
}
