import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ShopProvider provider = context.watch<ShopProvider>();
    final String localizedName =
      product.localizedNameForLanguage(provider.locale.languageCode);
    final String localizedDescription =
      product.localizedDescriptionForLanguage(provider.locale.languageCode);
    final double estimate = provider.estimatePrice(product);
    final double rate = _currentRate(provider);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.canvas.withValues(alpha: 0.92),
            title: Text(
              localizedName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            actions: <Widget>[
              IconButton(
                tooltip: l10n.share,
                onPressed: () => _shareProduct(estimate, localizedName, context),
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
                      memCacheWidth: 1400,
                      maxWidthDiskCache: 1800,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[
                          AppColors.maroon.withValues(alpha: 0.68),
                          AppColors.maroon.withValues(alpha: 0.16),
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOutCubic,
              decoration: BoxDecoration(
                gradient: AppColors.appBackground,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      localizedName,
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
                      l10n.designDescription,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizedDescription,
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
                          color: AppColors.gold.withValues(alpha: 0.3),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            l10n.estimatedPrice,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formatRupee(estimate),
                            style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: AppColors.cream),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${formatRupee(rate, suffix: '/10g')} × ${product.weightLabel} ÷ 10',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _rateCaption(context),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.softGold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.priceEstimateDisclaimer,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.mutedText,
                                  height: 1.35,
                                ),
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
                            label: Text(l10n.callUs),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => LauncherUtils.whatsapp(
                              context,
                              phoneNumber: provider.shopInfo.whatsapp,
                              message: l10n.productDetailsWhatsAppMessage(
                                localizedName,
                                product.weightLabel,
                              ),
                            ),
                            icon: const Icon(Icons.chat_bubble_outline_rounded),
                            label: Text(l10n.whatsappEnquiry),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _shareProduct(estimate, localizedName, context),
                        icon: const Icon(Icons.ios_share_outlined),
                        label: Text(l10n.shareProduct),
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

  String _rateCaption(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (product.metalType == 'Silver') {
      return l10n.rateCaptionSilver;
    }
    if (product.purity.contains('24')) {
      return l10n.rateCaptionGold24;
    }
    return l10n.rateCaptionGold22;
  }

  Future<void> _shareProduct(
    double estimatePrice,
    String localizedName,
    BuildContext context,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Share.share(
      l10n.shareProductText(
        localizedName,
        product.weightLabel,
        product.purity,
        formatRupee(estimatePrice),
      ),
      subject: localizedName,
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
        border: Border.all(color: AppColors.border),
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
