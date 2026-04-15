import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';

import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onEnquire,
    this.onQuickLook,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onEnquire;
  final VoidCallback? onQuickLook;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String languageCode = Localizations.localeOf(context).languageCode;
    final String localizedName = product.localizedNameForLanguage(languageCode);
    final String localizedDescription =
        product.localizedDescriptionForLanguage(languageCode);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Hero(
                    tag: 'product-${product.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        memCacheWidth: 520,
                        maxWidthDiskCache: 900,
                        placeholder: (BuildContext context, String _) =>
                            Container(
                              color: AppColors.silver.withValues(alpha: 0.25),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                        errorWidget:
                            (BuildContext context, String _, Object __) =>
                                Container(
                                  color: AppColors.silver.withValues(alpha: 0.2),
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: AppColors.softGold,
                                    size: 32,
                                  ),
                                ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: product.isInStock
                            ? AppColors.softGold.withValues(alpha: 0.9)
                            : const Color(0xFFD95B5B),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.black.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Text(
                        product.isInStock ? l10n.inStock : l10n.soldOut,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: product.isInStock
                              ? AppColors.black
                              : Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: product.metalType == 'Gold'
                            ? AppColors.gold.withValues(alpha: 0.9)
                            : AppColors.silver.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.black.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Text(
                        product.metalType,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizedName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatWeight(product.weight)} • ${product.purity}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    localizedDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  if (onQuickLook != null)
                    Row(
                      children: <Widget>[
                        Tooltip(
                          message: l10n.quickLook,
                          child: SizedBox(
                            width: 44,
                            height: 38,
                            child: OutlinedButton(
                              onPressed: onQuickLook,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(44, 38),
                                padding: EdgeInsets.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Icon(
                                Icons.visibility_outlined,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onEnquire,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(38),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              product.isInStock
                                  ? l10n.enquireNow
                                  : l10n.notifyMe,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onEnquire,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(38),
                        ),
                        child: Text(
                          product.isInStock ? l10n.enquireNow : l10n.notifyMe,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
