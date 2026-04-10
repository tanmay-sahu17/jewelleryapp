import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/product_model.dart';
import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/launcher_utils.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final ShopProvider provider = context.watch<ShopProvider>();
    final double estimate = provider.estimatePrice(product);
    final double rate = _currentRate(provider);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            stretch: true,
            title: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            actions: <Widget>[
              IconButton(
                tooltip: 'Share',
                onPressed: () => _shareProduct(estimate),
                icon: const Icon(Icons.share_outlined),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Hero(
                    tag: 'product-${product.id}',
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[
                          Colors.black.withValues(alpha: 0.75),
                          Colors.black.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.appBackground,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        _DetailBadge(label: product.metalType),
                        _DetailBadge(label: product.purity),
                        _DetailBadge(label: product.weightLabel),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Design Description',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.charcoal,
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Estimated Price',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formatRupee(estimate),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: AppColors.softGold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${formatRupee(rate, suffix: '/10g')} × ${product.weightLabel} ÷ 10',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _rateCaption(),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.softGold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => LauncherUtils.call(
                              context,
                              provider.shopInfo.primaryPhone,
                            ),
                            icon: const Icon(Icons.call_outlined),
                            label: const Text('Call Us'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => LauncherUtils.whatsapp(
                              context,
                              phoneNumber: provider.shopInfo.whatsapp,
                              message:
                                  'Hi, I would like details for ${product.name} (${product.weightLabel}).',
                            ),
                            icon: const Icon(Icons.chat_bubble_outline_rounded),
                            label: const Text('WhatsApp Enquiry'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _shareProduct(estimate),
                        icon: const Icon(Icons.ios_share_outlined),
                        label: const Text('Share Product'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _currentRate(ShopProvider provider) {
    if (product.metalType == 'Silver') {
      return provider.liveRates['Silver'] ?? 890;
    }

    if (product.purity.contains('24')) {
      return provider.liveRates['Gold24K'] ?? 74700;
    }

    return provider.liveRates['Gold22K'] ?? 68500;
  }

  String _rateCaption() {
    if (product.metalType == 'Silver') {
      return 'Based on today\'s Silver live rate (10g basis)';
    }
    if (product.purity.contains('24')) {
      return 'Based on today\'s Gold 24K live rate (10g basis)';
    }
    return 'Based on today\'s Gold 22K live rate (10g basis)';
  }

  Future<void> _shareProduct(double estimatePrice) {
    return Share.share(
      'Check out ${product.name} from Gulab Jewellers. '
      'Weight: ${product.weightLabel}, Purity: ${product.purity}, '
      'Estimated price: ${formatRupee(estimatePrice)}.',
      subject: product.name,
    );
  }
}

class _DetailBadge extends StatelessWidget {
  const _DetailBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.charcoal,
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.softGold,
        ),
      ),
    );
  }
}
