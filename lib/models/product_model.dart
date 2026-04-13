import 'dart:ui';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.weight,
    required this.description,
    required this.category,
    required this.metalType,
    required this.purity,
    this.isFeatured = false,
    this.isInStock = true,
    this.localizedNames = const <String, String>{},
    this.localizedDescriptions = const <String, String>{},
  });

  final String id;
  final String name;
  final String imageUrl;
  final double weight;
  final String description;
  final String category;
  final String metalType;
  final String purity;
  final bool isFeatured;
  final bool isInStock;
  final Map<String, String> localizedNames;
  final Map<String, String> localizedDescriptions;

  String get weightLabel => '${weight.toStringAsFixed(1)}g';

  Product copyWith({
    Map<String, String>? localizedNames,
    Map<String, String>? localizedDescriptions,
  }) {
    return Product(
      id: id,
      name: name,
      imageUrl: imageUrl,
      weight: weight,
      description: description,
      category: category,
      metalType: metalType,
      purity: purity,
      isFeatured: isFeatured,
      isInStock: isInStock,
      localizedNames: localizedNames ?? this.localizedNames,
      localizedDescriptions: localizedDescriptions ?? this.localizedDescriptions,
    );
  }

  String localizedNameForLanguage(String languageCode) {
    return _resolveLocalizedValue(localizedNames, languageCode, name);
  }

  String localizedDescriptionForLanguage(String languageCode) {
    return _resolveLocalizedValue(
      localizedDescriptions,
      languageCode,
      description,
    );
  }

  String localizedNameForLocale(Locale locale) {
    return localizedNameForLanguage(locale.languageCode);
  }

  String localizedDescriptionForLocale(Locale locale) {
    return localizedDescriptionForLanguage(locale.languageCode);
  }

  List<String> searchableContent(String languageCode) {
    final Set<String> values = <String>{
      name,
      description,
      localizedNameForLanguage(languageCode),
      localizedDescriptionForLanguage(languageCode),
      ...localizedNames.values,
      ...localizedDescriptions.values,
    };

    return values
        .map((String value) => value.trim())
        .where((String value) => value.isNotEmpty)
        .toList(growable: false);
  }

  String _resolveLocalizedValue(
    Map<String, String> translations,
    String languageCode,
    String fallback,
  ) {
    final String normalized = languageCode.toLowerCase().replaceAll('_', '-');
    if (normalized.isEmpty) {
      return fallback;
    }

    final String? exact = translations[normalized];
    if (exact != null && exact.trim().isNotEmpty) {
      return exact;
    }

    final String baseCode = normalized.split('-').first;
    final String? base = translations[baseCode];
    if (base != null && base.trim().isNotEmpty) {
      return base;
    }

    return fallback;
  }
}
