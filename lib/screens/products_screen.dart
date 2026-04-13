import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/product_model.dart';
import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/launcher_utils.dart';
import '../widgets/empty_state.dart';
import '../widgets/premium_background.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

enum _ProductSortOption {
  latest,
  priceLowToHigh,
  priceHighToLow,
  popular,
}

String _sortOptionLabel(_ProductSortOption option, AppLocalizations l10n) {
  switch (option) {
    case _ProductSortOption.latest:
      return l10n.sortLatest;
    case _ProductSortOption.priceLowToHigh:
      return l10n.sortPriceLowToHigh;
    case _ProductSortOption.priceHighToLow:
      return l10n.sortPriceHighToLow;
    case _ProductSortOption.popular:
      return l10n.sortPopular;
  }
}

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    super.key,
    this.searchToggleSignal,
  });

  final ValueListenable<int>? searchToggleSignal;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isLoading = true;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _searchText = '';
  String _searchQuery = '';
  int? _lastSearchSignal;

  final List<String> _recentSearches = <String>[];
  String _selectedCategory = 'All';
  Set<String> _selectedMetals = <String>{};
  Set<String> _selectedPurities = <String>{};
  bool _inStockOnly = false;
  RangeValues? _priceRange;
  RangeValues? _weightRange;
  _ProductSortOption _sortOption = _ProductSortOption.latest;

  @override
  void initState() {
    super.initState();
    _attachSearchSignal(widget.searchToggleSignal);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _syncProductFeed();
    });

    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void didUpdateWidget(covariant ProductsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchToggleSignal != widget.searchToggleSignal) {
      _detachSearchSignal(oldWidget.searchToggleSignal);
      _attachSearchSignal(widget.searchToggleSignal);
    }
  }

  @override
  void dispose() {
    _detachSearchSignal(widget.searchToggleSignal);
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _attachSearchSignal(ValueListenable<int>? signal) {
    if (signal == null) {
      return;
    }
    _lastSearchSignal = signal.value;
    signal.addListener(_handleExternalSearchToggle);
  }

  void _detachSearchSignal(ValueListenable<int>? signal) {
    signal?.removeListener(_handleExternalSearchToggle);
  }

  void _handleExternalSearchToggle() {
    final ValueListenable<int>? signal = widget.searchToggleSignal;
    if (!mounted || signal == null) {
      return;
    }

    if (_lastSearchSignal == signal.value) {
      return;
    }
    _lastSearchSignal = signal.value;
    _toggleSearchVisibility();
  }

  void _toggleSearchVisibility() {
    if (_isSearchVisible) {
      _clearSearch();
    }

    setState(() => _isSearchVisible = !_isSearchVisible);
    _syncProductFeed();
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    _searchController.clear();
    _searchText = '';
    _searchQuery = '';
  }

  void _onSearchChanged(String value) {
    setState(() => _searchText = value);

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) {
        return;
      }
      setState(() => _searchQuery = value.trim());
      _syncProductFeed();
    });
  }

  void _commitSearch(String rawQuery) {
    final String query = rawQuery.trim();
    _searchDebounce?.cancel();

    setState(() {
      _searchText = query;
      _searchQuery = query;
      _searchController.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
      _recordRecentSearch(query);
    });

    _syncProductFeed();
  }

  ProductFeedSortOption _toProviderSortOption(_ProductSortOption option) {
    switch (option) {
      case _ProductSortOption.latest:
        return ProductFeedSortOption.latest;
      case _ProductSortOption.priceLowToHigh:
        return ProductFeedSortOption.priceLowToHigh;
      case _ProductSortOption.priceHighToLow:
        return ProductFeedSortOption.priceHighToLow;
      case _ProductSortOption.popular:
        return ProductFeedSortOption.popular;
    }
  }

  void _syncProductFeed() {
    if (!mounted) {
      return;
    }

    final ShopProvider provider = context.read<ShopProvider>();
    final List<Product> allProducts = provider.catalogProducts;
    final Map<String, double> estimatedPriceById = <String, double>{
      for (final Product product in allProducts)
        product.id: provider.estimatePrice(product),
    };

    final RangeValues fullPriceRange = _priceBounds(allProducts, estimatedPriceById);
    final RangeValues fullWeightRange = _weightBounds(allProducts);
    final RangeValues activePriceRange = _clampRange(
      _priceRange ?? fullPriceRange,
      fullPriceRange,
    );
    final RangeValues activeWeightRange = _clampRange(
      _weightRange ?? fullWeightRange,
      fullWeightRange,
    );

    provider.configureProductFeed(
      searchQuery: _searchQuery,
      category: _selectedCategory,
      metals: _selectedMetals,
      purities: _selectedPurities,
      inStockOnly: _inStockOnly,
      minPrice: _isSameRange(activePriceRange, fullPriceRange)
          ? null
          : activePriceRange.start,
      maxPrice: _isSameRange(activePriceRange, fullPriceRange)
          ? null
          : activePriceRange.end,
      minWeight: _isSameRange(activeWeightRange, fullWeightRange)
          ? null
          : activeWeightRange.start,
      maxWeight: _isSameRange(activeWeightRange, fullWeightRange)
          ? null
          : activeWeightRange.end,
      sortOption: _toProviderSortOption(_sortOption),
    );
  }

  void _recordRecentSearch(String query) {
    if (query.isEmpty) {
      return;
    }

    _recentSearches.removeWhere(
      (String value) => value.toLowerCase() == query.toLowerCase(),
    );
    _recentSearches.insert(0, query);

    if (_recentSearches.length > 6) {
      _recentSearches.removeRange(6, _recentSearches.length);
    }
  }

  String _localizedCategoryLabel(String category, AppLocalizations l10n) {
    switch (category) {
      case 'All':
        return l10n.categoryAll;
      case 'Gold':
        return l10n.categoryGold;
      case 'Silver':
        return l10n.categorySilver;
      case 'Rings':
        return l10n.categoryRings;
      case 'Necklaces':
        return l10n.categoryNecklaces;
      case 'Bangles':
        return l10n.categoryBangles;
      case 'Earrings':
        return l10n.categoryEarrings;
      default:
        return category;
    }
  }

  List<String> _buildSuggestions(
    List<Product> products,
    String languageCode,
    AppLocalizations l10n,
  ) {
    final String query = _searchText.trim().toLowerCase();
    if (query.isEmpty) {
      return _recentSearches;
    }

    final Set<String> suggestions = <String>{};
    for (final Product product in products) {
      final String localizedName =
          product.localizedNameForLanguage(languageCode);
      if (localizedName.toLowerCase().contains(query) ||
          product.name.toLowerCase().contains(query)) {
        suggestions.add(localizedName);
      }

      final String localizedCategory =
          _localizedCategoryLabel(product.category, l10n);
      if (localizedCategory.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query)) {
        suggestions.add(localizedCategory);
      }

      if (product.purity.toLowerCase().contains(query)) {
        suggestions.add(product.purity);
      }

      if (suggestions.length >= 7) {
        break;
      }
    }

    return suggestions.toList(growable: false);
  }

  RangeValues _priceBounds(
    List<Product> products,
    Map<String, double> estimatedPriceById,
  ) {
    if (products.isEmpty) {
      return const RangeValues(0, 1000);
    }

    double min = double.infinity;
    double max = 0;
    for (final Product product in products) {
      final double price = estimatedPriceById[product.id] ?? 0;
      if (price < min) {
        min = price;
      }
      if (price > max) {
        max = price;
      }
    }

    if (min == double.infinity) {
      return const RangeValues(0, 1000);
    }

    final double start = (min / 500).floor() * 500;
    final double end = (max / 500).ceil() * 500;
    return RangeValues(start, end <= start ? start + 500 : end);
  }

  RangeValues _weightBounds(List<Product> products) {
    if (products.isEmpty) {
      return const RangeValues(0, 10);
    }

    double min = products.first.weight;
    double max = products.first.weight;
    for (final Product product in products.skip(1)) {
      if (product.weight < min) {
        min = product.weight;
      }
      if (product.weight > max) {
        max = product.weight;
      }
    }

    final double start = (min * 2).floor() / 2;
    final double end = (max * 2).ceil() / 2;
    return RangeValues(start, end <= start ? start + 0.5 : end);
  }

  RangeValues _clampRange(RangeValues value, RangeValues bounds) {
    final double start = value.start.clamp(bounds.start, bounds.end).toDouble();
    final double end = value.end.clamp(bounds.start, bounds.end).toDouble();
    return start > end ? RangeValues(end, start) : RangeValues(start, end);
  }

  bool _isSameRange(RangeValues first, RangeValues second) {
    return (first.start - second.start).abs() < 0.001 &&
        (first.end - second.end).abs() < 0.001;
  }

  int _activeFilterCount({
    required String selectedCategory,
    required RangeValues fullPriceRange,
    required RangeValues fullWeightRange,
    required RangeValues activePriceRange,
    required RangeValues activeWeightRange,
  }) {
    int count = 0;
    if (selectedCategory != 'All') {
      count++;
    }
    if (_selectedMetals.isNotEmpty) {
      count++;
    }
    if (_selectedPurities.isNotEmpty) {
      count++;
    }
    if (_inStockOnly) {
      count++;
    }
    if (!_isSameRange(activePriceRange, fullPriceRange)) {
      count++;
    }
    if (!_isSameRange(activeWeightRange, fullWeightRange)) {
      count++;
    }
    return count;
  }

  Future<void> _openFilterSheet({
    required BuildContext context,
    required List<String> categories,
    required List<String> metals,
    required List<String> purities,
    required RangeValues fullPriceRange,
    required RangeValues fullWeightRange,
  }) async {
  final AppLocalizations l10n = AppLocalizations.of(context)!;
    String draftCategory = _selectedCategory;
    Set<String> draftMetals = Set<String>.from(_selectedMetals)
      ..removeWhere((String value) => !metals.contains(value));
    Set<String> draftPurities = Set<String>.from(_selectedPurities)
      ..removeWhere((String value) => !purities.contains(value));
    bool draftInStockOnly = _inStockOnly;
    RangeValues draftPriceRange = _clampRange(
      _priceRange ?? fullPriceRange,
      fullPriceRange,
    );
    RangeValues draftWeightRange = _clampRange(
      _weightRange ?? fullWeightRange,
      fullWeightRange,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: AppColors.charcoal,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.86,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  6,
                  16,
                  16 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              l10n.filters,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.closeFilters,
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      Text(
                        l10n.applyFiltersSortPref,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        l10n.category,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories.map((String category) {
                          return ChoiceChip(
                            label: Text(_localizedCategoryLabel(category, l10n)),
                            selected: draftCategory == category,
                            onSelected: (_) {
                              setModalState(() => draftCategory = category);
                            },
                          );
                        }).toList(growable: false),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        l10n.metalType,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: metals.map((String metal) {
                          return FilterChip(
                            label: Text(metal),
                            selected: draftMetals.contains(metal),
                            onSelected: (bool selected) {
                              setModalState(() {
                                if (selected) {
                                  draftMetals.add(metal);
                                } else {
                                  draftMetals.remove(metal);
                                }
                              });
                            },
                          );
                        }).toList(growable: false),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        l10n.purity,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: purities.map((String purity) {
                          return FilterChip(
                            label: Text(purity),
                            selected: draftPurities.contains(purity),
                            onSelected: (bool selected) {
                              setModalState(() {
                                if (selected) {
                                  draftPurities.add(purity);
                                } else {
                                  draftPurities.remove(purity);
                                }
                              });
                            },
                          );
                        }).toList(growable: false),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile.adaptive(
                        value: draftInStockOnly,
                        onChanged: (bool value) {
                          setModalState(() => draftInStockOnly = value);
                        },
                        title: Text(l10n.inStockOnly),
                        subtitle: Text(l10n.hideSoldOutProducts),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.estimatedPriceRange,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatRupee(draftPriceRange.start)} - ${formatRupee(draftPriceRange.end)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      RangeSlider(
                        values: draftPriceRange,
                        min: fullPriceRange.start,
                        max: fullPriceRange.end,
                        labels: RangeLabels(
                          formatRupee(draftPriceRange.start),
                          formatRupee(draftPriceRange.end),
                        ),
                        onChanged: (RangeValues values) {
                          setModalState(() {
                            draftPriceRange = _clampRange(values, fullPriceRange);
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.weightRange,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatWeight(draftWeightRange.start)} - ${formatWeight(draftWeightRange.end)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      RangeSlider(
                        values: draftWeightRange,
                        min: fullWeightRange.start,
                        max: fullWeightRange.end,
                        labels: RangeLabels(
                          formatWeight(draftWeightRange.start),
                          formatWeight(draftWeightRange.end),
                        ),
                        onChanged: (RangeValues values) {
                          setModalState(() {
                            draftWeightRange = _clampRange(values, fullWeightRange);
                          });
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setModalState(() {
                                  draftCategory = 'All';
                                  draftMetals = <String>{};
                                  draftPurities = <String>{};
                                  draftInStockOnly = false;
                                  draftPriceRange = fullPriceRange;
                                  draftWeightRange = fullWeightRange;
                                });
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: Text(l10n.reset),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = draftCategory;
                                  _selectedMetals = draftMetals;
                                  _selectedPurities = draftPurities;
                                  _inStockOnly = draftInStockOnly;
                                  _priceRange = _isSameRange(
                                    draftPriceRange,
                                    fullPriceRange,
                                  )
                                      ? null
                                      : draftPriceRange;
                                  _weightRange = _isSameRange(
                                    draftWeightRange,
                                    fullWeightRange,
                                  )
                                      ? null
                                      : draftWeightRange;
                                });
                                Navigator.of(context).pop();
                                _syncProductFeed();
                              },
                              icon: const Icon(Icons.check_rounded),
                              label: Text(l10n.apply),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _openSortSheet(BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: AppColors.charcoal,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      l10n.sortBy,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.closeSortOptions,
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Text(
                l10n.chooseSortArrangement,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              ..._ProductSortOption.values.map(( _ProductSortOption option) {
                final bool isSelected = _sortOption == option;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? AppColors.gold.withValues(alpha: 0.14)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.gold.withValues(alpha: 0.6)
                          : AppColors.border,
                    ),
                  ),
                  child: ListTile(
                    title: Text(_sortOptionLabel(option, l10n)),
                    trailing: Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: isSelected ? AppColors.softGold : AppColors.mutedText,
                    ),
                    onTap: () {
                      setState(() => _sortOption = option);
                      Navigator.of(context).pop();
                      _syncProductFeed();
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  int _resolveGridColumns(double width) {
    if (width > 1120) {
      return 5;
    }
    if (width > 900) {
      return 4;
    }
    if (width > 650) {
      return 3;
    }
    return 2;
  }

  void _resetAllCriteria() {
    setState(() {
      _clearSearch();
      _selectedCategory = 'All';
      _selectedMetals = <String>{};
      _selectedPurities = <String>{};
      _inStockOnly = false;
      _priceRange = null;
      _weightRange = null;
      _sortOption = _ProductSortOption.latest;
    });
    _syncProductFeed();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return PremiumBackground(
      child: Consumer<ShopProvider>(
        builder: (BuildContext context, ShopProvider provider, Widget? child) {
          final List<Product> allProducts = provider.catalogProducts;
          final List<String> categories = allProducts
              .map((Product product) => product.category)
              .toSet()
              .toList()
            ..sort();
          categories.insert(0, 'All');

          if (!categories.contains(_selectedCategory)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              setState(() => _selectedCategory = 'All');
              _syncProductFeed();
            });
          }

          final List<String> metals = allProducts
              .map((Product product) => product.metalType)
              .toSet()
              .toList()
            ..sort();
          final List<String> purities = allProducts
              .map((Product product) => product.purity)
              .toSet()
              .toList()
            ..sort();

          final Map<String, double> estimatedPriceById = <String, double>{
            for (final Product product in allProducts)
              product.id: provider.estimatePrice(product),
          };

          final RangeValues fullPriceRange = _priceBounds(
            allProducts,
            estimatedPriceById,
          );
          final RangeValues fullWeightRange = _weightBounds(allProducts);
          final RangeValues activePriceRange = _clampRange(
            _priceRange ?? fullPriceRange,
            fullPriceRange,
          );
          final RangeValues activeWeightRange = _clampRange(
            _weightRange ?? fullWeightRange,
            fullWeightRange,
          );

          final List<Product> products = provider.productFeed;

          final List<String> suggestions = _buildSuggestions(
            allProducts,
            provider.locale.languageCode,
            l10n,
          );
          final int activeFilterCount = _activeFilterCount(
            selectedCategory: _selectedCategory,
            fullPriceRange: fullPriceRange,
            fullWeightRange: fullWeightRange,
            activePriceRange: activePriceRange,
            activeWeightRange: activeWeightRange,
          );
          final bool hasActiveCriteria =
              _searchQuery.trim().isNotEmpty || activeFilterCount > 0;

          final int crossAxisCount = _resolveGridColumns(
            MediaQuery.sizeOf(context).width - 32,
          );

          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            cacheExtent: 1200,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.discoverCollection,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.browseHandcraftedDesigns,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: AppColors.mutedText),
                      ),
                    ),
                    if (_isSearchVisible) ...<Widget>[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: _onSearchChanged,
                        onSubmitted: _commitSearch,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: l10n.searchHint,
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchText.trim().isEmpty
                              ? null
                              : IconButton(
                                  tooltip: l10n.clearSearch,
                                  onPressed: () {
                                    setState(_clearSearch);
                                    _syncProductFeed();
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                        ),
                      ),
                      if (_searchText.trim().isEmpty &&
                          _recentSearches.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _recentSearches.map((String value) {
                                return ActionChip(
                                  avatar: const Icon(
                                    Icons.history_rounded,
                                    size: 16,
                                  ),
                                  label: Text(value),
                                  onPressed: () => _commitSearch(value),
                                );
                              }).toList(growable: false),
                            ),
                          ),
                        )
                      else if (_searchText.trim().isNotEmpty &&
                          suggestions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: suggestions.map((String value) {
                                return ActionChip(
                                  avatar: const Icon(
                                    Icons.north_west_rounded,
                                    size: 16,
                                  ),
                                  label: Text(value),
                                  onPressed: () => _commitSearch(value),
                                );
                              }).toList(growable: false),
                            ),
                          ),
                        ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _openFilterSheet(
                              context: context,
                              categories: categories,
                              metals: metals,
                              purities: purities,
                              fullPriceRange: fullPriceRange,
                              fullWeightRange: fullWeightRange,
                            ),
                            icon: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                const Icon(Icons.tune_rounded),
                                if (activeFilterCount > 0)
                                  Positioned(
                                    right: -8,
                                    top: -8,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.gold,
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      child: Text(
                                        activeFilterCount > 9
                                            ? '9+'
                                            : '$activeFilterCount',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 9,
                                            ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            label: Text(
                              activeFilterCount == 0
                                  ? l10n.filters
                                  : l10n.filtersWithCount(activeFilterCount),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _openSortSheet(context),
                            icon: const Icon(Icons.swap_vert_rounded),
                            label: Text(
                              _sortOptionLabel(_sortOption, l10n),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _CategoryFilterBar(
                      categories: categories,
                      selectedCategory: _selectedCategory,
                      labelBuilder: (String category) {
                        return _localizedCategoryLabel(category, l10n);
                      },
                      onSelect: (String category) {
                        setState(() => _selectedCategory = category);
                        _syncProductFeed();
                      },
                    ),
                    if (hasActiveCriteria) ...<Widget>[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            if (_searchQuery.trim().isNotEmpty)
                              InputChip(
                                label: Text('${l10n.searchPrefix}: $_searchQuery'),
                                onDeleted: () {
                                  setState(_clearSearch);
                                  _syncProductFeed();
                                },
                              ),
                            if (_selectedCategory != 'All')
                              InputChip(
                                label: Text(
                                  '${l10n.categoryPrefix}: ${_localizedCategoryLabel(_selectedCategory, l10n)}',
                                ),
                                onDeleted: () {
                                  setState(() => _selectedCategory = 'All');
                                  _syncProductFeed();
                                },
                              ),
                            for (final String metal in _selectedMetals)
                              InputChip(
                                label: Text(metal),
                                onDeleted: () {
                                  setState(() => _selectedMetals.remove(metal));
                                  _syncProductFeed();
                                },
                              ),
                            for (final String purity in _selectedPurities)
                              InputChip(
                                label: Text(purity),
                                onDeleted: () {
                                  setState(() => _selectedPurities.remove(purity));
                                  _syncProductFeed();
                                },
                              ),
                            if (_inStockOnly)
                              InputChip(
                                label: Text(l10n.inStockOnly),
                                onDeleted: () {
                                  setState(() => _inStockOnly = false);
                                  _syncProductFeed();
                                },
                              ),
                            if (!_isSameRange(activePriceRange, fullPriceRange))
                              InputChip(
                                label: Text(
                                  '${l10n.pricePrefix}: ${formatRupee(activePriceRange.start)} - ${formatRupee(activePriceRange.end)}',
                                ),
                                onDeleted: () {
                                  setState(() => _priceRange = null);
                                  _syncProductFeed();
                                },
                              ),
                            if (!_isSameRange(activeWeightRange, fullWeightRange))
                              InputChip(
                                label: Text(
                                  '${l10n.weightPrefix}: ${formatWeight(activeWeightRange.start)} - ${formatWeight(activeWeightRange.end)}',
                                ),
                                onDeleted: () {
                                  setState(() => _weightRange = null);
                                  _syncProductFeed();
                                },
                              ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: _resetAllCriteria,
                          icon: const Icon(
                            Icons.cleaning_services_outlined,
                            size: 16,
                          ),
                          label: Text(l10n.clearAll),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.productsFound(provider.productFeedTotalMatches),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              if (_isLoading)
                _ProductShimmerSliverGrid(crossAxisCount: crossAxisCount)
              else if (products.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: Column(
                      children: <Widget>[
                        EmptyState(
                          title: _searchQuery.trim().isEmpty
                              ? l10n.noItemsForFilters
                              : l10n.noMatchingProducts,
                          subtitle: hasActiveCriteria
                              ? l10n.tryLooseningFilters
                              : l10n.tryDifferentCategory,
                        ),
                        if (suggestions.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: suggestions.take(5).map((String value) {
                                return ActionChip(
                                  avatar: const Icon(
                                    Icons.search_rounded,
                                    size: 16,
                                  ),
                                  label: Text(value),
                                  onPressed: () => _commitSearch(value),
                                );
                              }).toList(growable: false),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: <Widget>[
                            if (_selectedCategory != 'All')
                              OutlinedButton(
                                onPressed: () {
                                  setState(() => _selectedCategory = 'All');
                                  _syncProductFeed();
                                },
                                child: Text(l10n.showAllCategories),
                              ),
                            if (_inStockOnly)
                              OutlinedButton(
                                onPressed: () {
                                  setState(() => _inStockOnly = false);
                                  _syncProductFeed();
                                },
                                child: Text(l10n.includeSoldOut),
                              ),
                            if (_selectedMetals.isNotEmpty ||
                                _selectedPurities.isNotEmpty)
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedMetals = <String>{};
                                    _selectedPurities = <String>{};
                                  });
                                  _syncProductFeed();
                                },
                                child: Text(l10n.clearMetalPurity),
                              ),
                            if (!_isSameRange(activePriceRange, fullPriceRange) ||
                                !_isSameRange(activeWeightRange, fullWeightRange))
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _priceRange = null;
                                    _weightRange = null;
                                  });
                                  _syncProductFeed();
                                },
                                child: Text(l10n.resetRanges),
                              ),
                          ],
                        ),
                        if (hasActiveCriteria)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: OutlinedButton.icon(
                              onPressed: _resetAllCriteria,
                              icon: const Icon(Icons.refresh_rounded),
                              label: Text(l10n.resetAllCriteria),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 8),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final Product product = products[index];
                        return RepaintBoundary(
                          child: ProductCard(
                            product: product,
                            onTap: () => _openDetails(context, product),
                            onEnquire: () =>
                                _enquireNow(context, provider, product),
                          ),
                        );
                      },
                      childCount: products.length,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: true,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.58,
                    ),
                  ),
                ),
              if (!_isLoading &&
                  products.isNotEmpty &&
                  (provider.hasMoreProductFeed ||
                      provider.isProductFeedLoadingMore))
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: Center(
                      child: OutlinedButton.icon(
                        onPressed: provider.isProductFeedLoadingMore
                            ? null
                            : provider.loadMoreProductFeed,
                        icon: provider.isProductFeedLoadingMore
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.expand_more_rounded),
                        label: Text(
                          provider.isProductFeedLoadingMore
                              ? l10n.loadingMoreProducts
                              : l10n.loadMoreProducts,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _openDetails(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  Future<void> _enquireNow(
    BuildContext context,
    ShopProvider provider,
    Product product,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String localizedName =
        product.localizedNameForLanguage(provider.locale.languageCode);
    final String message = product.isInStock
        ? l10n.productInquiryInStock(
            localizedName,
            product.weightLabel,
            product.purity,
          )
        : l10n.productInquiryNotify(
            localizedName,
            product.weightLabel,
            product.purity,
          );

    return LauncherUtils.whatsapp(
      context,
      phoneNumber: provider.shopInfo.whatsapp,
      message: message,
    );
  }
}

class _CategoryFilterBar extends StatelessWidget {
  const _CategoryFilterBar({
    required this.categories,
    required this.selectedCategory,
    required this.labelBuilder,
    required this.onSelect,
  });

  final List<String> categories;
  final String selectedCategory;
  final String Function(String value) labelBuilder;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((String category) {
            final bool selected = selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(labelBuilder(category)),
                selected: selected,
                onSelected: (_) => onSelect(category),
              ),
            );
          }).toList(growable: false),
        ),
      ),
    );
  }
}

class _ProductShimmerSliverGrid extends StatelessWidget {
  const _ProductShimmerSliverGrid({required this.crossAxisCount});

  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 22),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Shimmer.fromColors(
              baseColor: AppColors.silver.withValues(alpha: 0.35),
              highlightColor: Colors.white.withValues(alpha: 0.75),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.charcoal,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
              ),
            );
          },
          childCount: crossAxisCount * 4,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.58,
        ),
      ),
    );
  }
}
