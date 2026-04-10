import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/product_model.dart';
import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import '../utils/launcher_utils.dart';
import '../widgets/empty_state.dart';
import '../widgets/premium_background.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PremiumBackground(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Discover Our Collection',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Browse handcrafted gold and silver jewellery designs.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 10),
          const _CategoryFilterBar(),
          const SizedBox(height: 12),
          Expanded(
            child: Consumer<ShopProvider>(
              builder:
                  (BuildContext context, ShopProvider provider, Widget? child) {
                    if (_isLoading) {
                      return const _ProductShimmerGrid();
                    }

                    final List<Product> products = provider.filteredProducts;
                    if (products.isEmpty) {
                      return const EmptyState(
                        title: 'No items found for this filter',
                        subtitle:
                            'Try a different category to explore more designs.',
                      );
                    }

                    return LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                            final double width = constraints.maxWidth;
                            int crossAxisCount = 2;
                            if (width > 1120) {
                              crossAxisCount = 5;
                            } else if (width > 900) {
                              crossAxisCount = 4;
                            } else if (width > 650) {
                              crossAxisCount = 3;
                            }

                            return GridView.builder(
                              padding: const EdgeInsets.only(bottom: 22),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.58,
                                  ),
                              itemCount: products.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Product product = products[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () => _openDetails(context, product),
                                  onEnquire: () =>
                                      _enquireNow(context, provider, product),
                                );
                              },
                            );
                          },
                    );
                  },
            ),
          ),
        ],
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
    return LauncherUtils.whatsapp(
      context,
      phoneNumber: provider.shopInfo.whatsapp,
      message:
          'Hello Gulab Jewellers, I want details for ${product.name} (${product.weightLabel}, ${product.purity}).',
    );
  }
}

class _CategoryFilterBar extends StatelessWidget {
  const _CategoryFilterBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (BuildContext context, ShopProvider provider, Widget? child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: provider.categories.map((String category) {
              final bool selected = provider.selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) => provider.setCategory(category),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _ProductShimmerGrid extends StatelessWidget {
  const _ProductShimmerGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        int crossAxisCount = 2;
        if (width > 1120) {
          crossAxisCount = 5;
        } else if (width > 900) {
          crossAxisCount = 4;
        } else if (width > 650) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          itemCount: crossAxisCount * 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.58,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Shimmer.fromColors(
              baseColor: AppColors.charcoal,
              highlightColor: AppColors.cream.withValues(alpha: 0.12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.charcoal,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
