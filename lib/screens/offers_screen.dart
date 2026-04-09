import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/offer_model.dart';
import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/premium_background.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  static const List<List<Color>> _overlayGradients = <List<Color>>[
    <Color>[Color(0xFF5A1E1E), Color(0xFFC48D2F)],
    <Color>[Color(0xFF2A1A1A), Color(0xFFD4A017)],
    <Color>[Color(0xFF331F1A), Color(0xFFBE7D2E)],
    <Color>[Color(0xFF261E1E), Color(0xFF9E7C33)],
  ];

  @override
  Widget build(BuildContext context) {
    return PremiumBackground(
      child: Consumer<ShopProvider>(
        builder: (BuildContext context, ShopProvider provider, Widget? child) {
          if (provider.offers.isEmpty) {
            return const EmptyState(
              title: 'No active offers right now',
              subtitle: 'Please check back soon for upcoming discounts.',
              icon: Icons.local_offer_outlined,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(top: 10, bottom: 22),
            itemCount: provider.offers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (BuildContext context, int index) {
              final ShopOffer offer = provider.offers[index];
              return _OfferListCard(
                offer: offer,
                gradient: _overlayGradients[index % _overlayGradients.length],
              );
            },
          );
        },
      ),
    );
  }
}

class _OfferListCard extends StatelessWidget {
  const _OfferListCard({required this.offer, required this.gradient});

  final ShopOffer offer;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: offer.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[
                          Colors.black.withValues(alpha: 0.75),
                          gradient.last.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          offer.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          offer.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: AppColors.charcoal,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      offer.validUntil,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.softGold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showOfferInfo(context),
                    child: const Text('Know More'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfferInfo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.charcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(offer.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(
                offer.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text(
                offer.validUntil,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.softGold,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
