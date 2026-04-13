import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/dummy_data.dart';
import '../models/notification_model.dart';
import '../models/offer_model.dart';
import '../models/product_model.dart';

enum ProductFeedSortOption {
  latest,
  priceLowToHigh,
  priceHighToLow,
  popular,
}

class ShopProvider extends ChangeNotifier {
  final Random _random = Random();
  static const String darkModePreferenceKey = 'shop_dark_mode_enabled';
  static const String localePreferenceKey = 'shop_locale_code';
  static const int _productFeedPageSize = 12;

  ShopProvider({
    bool initialDarkMode = false,
    Locale? initialLocale,
  })  : _isDarkMode = initialDarkMode,
        _locale = initialLocale ?? const Locale('en') {
    _seedNotifications();
    _resetProductFeed(notify: false);
  }

  String _selectedCategory = DummyData.categories.first;
  final Map<String, double> _liveRates = Map<String, double>.from(
    DummyData.liveRates,
  );
  final Map<String, double> _shopRates = Map<String, double>.from(
    DummyData.shopRates,
  );
  DateTime _shopRatesLastUpdatedAt = DateTime.now();
  final List<ShopNotification> _notifications = <ShopNotification>[];
  bool _isDarkMode;
  Locale _locale;

  final List<Product> _productFeed = <Product>[];
  List<Product> _productFeedSource = <Product>[];
  int _productFeedCursor = 0;
  bool _hasMoreProductFeed = true;
  bool _isProductFeedLoadingMore = false;
  int _productFeedTotalMatches = 0;

  String _productFeedSearchQuery = '';
  String _productFeedCategory = 'All';
  Set<String> _productFeedMetals = <String>{};
  Set<String> _productFeedPurities = <String>{};
  bool _productFeedInStockOnly = false;
  double? _productFeedMinPrice;
  double? _productFeedMaxPrice;
  double? _productFeedMinWeight;
  double? _productFeedMaxWeight;
  ProductFeedSortOption _productFeedSortOption = ProductFeedSortOption.latest;

  String get selectedCategory => _selectedCategory;
  List<String> get categories => DummyData.categories;

  Map<String, double> get liveRates => _liveRates;
  Map<String, double> get shopRates => _shopRates;
  DateTime get shopRatesLastUpdatedAt => _shopRatesLastUpdatedAt;
  List<ShopNotification> get notifications => List<ShopNotification>.unmodifiable(
    _notifications,
  );
  int get unreadNotificationCount => _notifications
      .where((ShopNotification item) => !item.isRead)
      .length;
  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;
  List<Product> get products => DummyData.products;
  List<Product> get catalogProducts => DummyData.products;
  List<Product> get productFeed => List<Product>.unmodifiable(_productFeed);
  bool get hasMoreProductFeed => _hasMoreProductFeed;
  bool get isProductFeedLoadingMore => _isProductFeedLoadingMore;
  int get productFeedTotalMatches => _productFeedTotalMatches;
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

  void setDarkMode(bool value) {
    if (_isDarkMode == value) {
      return;
    }
    _isDarkMode = value;
    notifyListeners();
    _persistDarkModePreference();
  }

  void setLocale(Locale value) {
    if (_locale == value) {
      return;
    }

    _locale = value;
    notifyListeners();
    _persistLocalePreference();
  }

  Future<void> _persistDarkModePreference() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();
    await preferences.setBool(darkModePreferenceKey, _isDarkMode);
  }

  Future<void> _persistLocalePreference() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();
    await preferences.setString(localePreferenceKey, _locale.languageCode);
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
    final double oldShop22K = _shopRates['Gold22K'] ?? 68250;
    final double oldShop24K = _shopRates['Gold24K'] ?? 74400;
    final double oldShopSilver = _shopRates['Silver'] ?? 870;

    _liveRates['Gold22K'] = _jitter(_liveRates['Gold22K'] ?? 68500, 180);
    _liveRates['Gold24K'] = _jitter(_liveRates['Gold24K'] ?? 74700, 220);
    _liveRates['Silver'] = _jitter(_liveRates['Silver'] ?? 890, 20);

    _shopRates['Gold22K'] = (_liveRates['Gold22K'] ?? 68500) - 200;
    _shopRates['Gold24K'] = (_liveRates['Gold24K'] ?? 74700) - 250;
    _shopRates['Silver'] = (_liveRates['Silver'] ?? 890) - 10;

    final double newShop22K = _shopRates['Gold22K'] ?? oldShop22K;
    final double newShop24K = _shopRates['Gold24K'] ?? oldShop24K;
    final double newShopSilver = _shopRates['Silver'] ?? oldShopSilver;

    final bool shopRateChanged =
        newShop22K.round() != oldShop22K.round() ||
        newShop24K.round() != oldShop24K.round() ||
        newShopSilver.round() != oldShopSilver.round();

    if (shopRateChanged) {
      _shopRatesLastUpdatedAt = DateTime.now();
      _addShopRateUpdateNotification(
        old22K: oldShop22K,
        old24K: oldShop24K,
        oldSilver: oldShopSilver,
        new22K: newShop22K,
        new24K: newShop24K,
        newSilver: newShopSilver,
      );
    }

    if (_productFeed.isNotEmpty) {
      _resetProductFeed(notify: false);
    }

    notifyListeners();
  }

  void configureProductFeed({
    required String searchQuery,
    required String category,
    required Set<String> metals,
    required Set<String> purities,
    required bool inStockOnly,
    double? minPrice,
    double? maxPrice,
    double? minWeight,
    double? maxWeight,
    required ProductFeedSortOption sortOption,
  }) {
    final String nextSearchQuery = searchQuery.trim();
    final Set<String> nextMetals = Set<String>.from(metals);
    final Set<String> nextPurities = Set<String>.from(purities);

    final bool unchanged = _productFeedSearchQuery == nextSearchQuery &&
        _productFeedCategory == category &&
        _setEquals(_productFeedMetals, nextMetals) &&
        _setEquals(_productFeedPurities, nextPurities) &&
        _productFeedInStockOnly == inStockOnly &&
        _productFeedMinPrice == minPrice &&
        _productFeedMaxPrice == maxPrice &&
        _productFeedMinWeight == minWeight &&
        _productFeedMaxWeight == maxWeight &&
        _productFeedSortOption == sortOption;

    if (unchanged && _productFeed.isNotEmpty) {
      return;
    }

    _productFeedSearchQuery = nextSearchQuery;
    _productFeedCategory = category;
    _productFeedMetals = nextMetals;
    _productFeedPurities = nextPurities;
    _productFeedInStockOnly = inStockOnly;
    _productFeedMinPrice = minPrice;
    _productFeedMaxPrice = maxPrice;
    _productFeedMinWeight = minWeight;
    _productFeedMaxWeight = maxWeight;
    _productFeedSortOption = sortOption;

    _resetProductFeed();
  }

  Future<void> loadMoreProductFeed() async {
    if (_isProductFeedLoadingMore || !_hasMoreProductFeed) {
      return;
    }

    _isProductFeedLoadingMore = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 260));
    _appendNextProductFeedPage(notify: false);

    _isProductFeedLoadingMore = false;
    notifyListeners();
  }

  void _resetProductFeed({bool notify = true}) {
    _productFeed.clear();
    _productFeedSource = _filteredProductFeedSource();
    _productFeedCursor = 0;
    _hasMoreProductFeed = true;
    _productFeedTotalMatches = _productFeedSource.length;

    _appendNextProductFeedPage(notify: false);
    if (notify) {
      notifyListeners();
    }
  }

  void _appendNextProductFeedPage({bool notify = true}) {
    final List<Product> source = _productFeedSource;

    if (_productFeedCursor >= source.length) {
      _hasMoreProductFeed = false;
      if (notify) {
        notifyListeners();
      }
      return;
    }

    final int nextCursor = min(
      _productFeedCursor + _productFeedPageSize,
      source.length,
    );

    _productFeed.addAll(source.sublist(_productFeedCursor, nextCursor));
    _productFeedCursor = nextCursor;
    _hasMoreProductFeed = _productFeedCursor < source.length;

    if (notify) {
      notifyListeners();
    }
  }

  List<Product> _filteredProductFeedSource() {
    final String query = _productFeedSearchQuery.toLowerCase();
    final List<Product> matched = catalogProducts.where((Product product) {
      if (_productFeedCategory != 'All' &&
          product.category != _productFeedCategory) {
        return false;
      }

      if (query.isNotEmpty) {
        final String localizedText =
            product.searchableContent(_locale.languageCode).join(' ');
        final String haystack =
            '$localizedText ${product.category} ${product.metalType} ${product.purity}'
                .toLowerCase();
        if (!haystack.contains(query)) {
          return false;
        }
      }

      if (_productFeedMetals.isNotEmpty &&
          !_productFeedMetals.contains(product.metalType)) {
        return false;
      }

      if (_productFeedPurities.isNotEmpty &&
          !_productFeedPurities.contains(product.purity)) {
        return false;
      }

      if (_productFeedInStockOnly && !product.isInStock) {
        return false;
      }

      final double estimatedPrice = estimatePrice(product);
      if (_productFeedMinPrice != null && estimatedPrice < _productFeedMinPrice!) {
        return false;
      }
      if (_productFeedMaxPrice != null && estimatedPrice > _productFeedMaxPrice!) {
        return false;
      }

      if (_productFeedMinWeight != null && product.weight < _productFeedMinWeight!) {
        return false;
      }
      if (_productFeedMaxWeight != null && product.weight > _productFeedMaxWeight!) {
        return false;
      }

      return true;
    }).toList(growable: false);

    switch (_productFeedSortOption) {
      case ProductFeedSortOption.latest:
        matched.sort((Product a, Product b) {
          return _productIdScore(b.id).compareTo(_productIdScore(a.id));
        });
        break;
      case ProductFeedSortOption.priceLowToHigh:
        matched.sort((Product a, Product b) {
          return estimatePrice(a).compareTo(estimatePrice(b));
        });
        break;
      case ProductFeedSortOption.priceHighToLow:
        matched.sort((Product a, Product b) {
          return estimatePrice(b).compareTo(estimatePrice(a));
        });
        break;
      case ProductFeedSortOption.popular:
        matched.sort((Product a, Product b) {
          final int featuredCompare =
              (b.isFeatured ? 1 : 0).compareTo(a.isFeatured ? 1 : 0);
          if (featuredCompare != 0) {
            return featuredCompare;
          }
          return _productIdScore(a.id).compareTo(_productIdScore(b.id));
        });
        break;
    }

    return matched;
  }

  bool _setEquals(Set<String> first, Set<String> second) {
    return first.length == second.length && first.containsAll(second);
  }

  int _productIdScore(String id) {
    return int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  void markNotificationRead(String id) {
    final int index = _notifications.indexWhere(
      (ShopNotification item) => item.id == id,
    );
    if (index == -1) {
      return;
    }

    final ShopNotification current = _notifications[index];
    if (current.isRead) {
      return;
    }

    _notifications[index] = current.copyWith(isRead: true);
    notifyListeners();
  }

  void markAllNotificationsRead() {
    bool changed = false;
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
        changed = true;
      }
    }

    if (changed) {
      notifyListeners();
    }
  }

  void _seedNotifications() {
    final bool hindi = _locale.languageCode == 'hi';

    _notifications
      ..clear()
      ..add(
        ShopNotification(
          id: _notificationId(),
          title: hindi ? '${shopInfo.name} में आपका स्वागत है' : 'Welcome to ${shopInfo.name}',
          message: hindi
              ? 'लेटेस्ट ऑफर, लाइव रेट और प्रीमियम डिज़ाइन्स देखें।'
              : 'Explore latest offers, live rates, and premium designs.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
          kind: ShopNotificationKind.general,
          isRead: true,
        ),
      )
      ..add(
        ShopNotification(
          id: _notificationId(),
          title: hindi ? 'आज के दुकान रेट' : 'Today\'s Shop Rates',
          message:
              'Gold 22K ${_rateLabel(_shopRates['Gold22K'] ?? 68250)}, Gold 24K ${_rateLabel(_shopRates['Gold24K'] ?? 74400)}, Silver ${_rateLabel(_shopRates['Silver'] ?? 870)}',
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          kind: ShopNotificationKind.rate,
        ),
      );

    if (offers.isNotEmpty) {
      final ShopOffer offer = offers.first;
      _notifications.add(
        ShopNotification(
          id: _notificationId(),
          title: offer.title,
          message: '${offer.description} (${offer.validUntil})',
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
          kind: ShopNotificationKind.offer,
        ),
      );
    }
  }

  void _addShopRateUpdateNotification({
    required double old22K,
    required double old24K,
    required double oldSilver,
    required double new22K,
    required double new24K,
    required double newSilver,
  }) {
    final bool hindi = _locale.languageCode == 'hi';
    final int delta22 = (new22K - old22K).round();
    final int delta24 = (new24K - old24K).round();
    final int deltaSilver = (newSilver - oldSilver).round();

    final String d22 = _signedDelta(delta22);
    final String d24 = _signedDelta(delta24);
    final String dSilver = _signedDelta(deltaSilver);

    _notifications.insert(
      0,
      ShopNotification(
        id: _notificationId(),
        title: hindi ? 'दुकान रेट अपडेट हुए' : 'Shop Rate Updated',
        message: hindi
            ? 'Shop 22K ${_rateLabel(new22K)} ($d22), 24K ${_rateLabel(new24K)} ($d24), Silver ${_rateLabel(newSilver)} ($dSilver)।'
            : 'Shop 22K ${_rateLabel(new22K)} ($d22), 24K ${_rateLabel(new24K)} ($d24), Silver ${_rateLabel(newSilver)} ($dSilver).',
        createdAt: DateTime.now(),
        kind: ShopNotificationKind.rate,
      ),
    );

    if (_notifications.length > 30) {
      _notifications.removeRange(30, _notifications.length);
    }
  }

  String _notificationId() {
    return '${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(9999)}';
  }

  String _signedDelta(int value) {
    final bool hindi = _locale.languageCode == 'hi';
    if (value == 0) {
      return hindi ? 'कोई बदलाव नहीं' : 'no change';
    }
    return value > 0 ? '+$value' : '$value';
  }

  String _rateLabel(double value) {
    return 'Rs ${value.toStringAsFixed(0)}/10g';
  }

  double _jitter(double value, int delta) {
    final int shift = _random.nextInt((delta * 2) + 1) - delta;
    return value + shift;
  }
}
