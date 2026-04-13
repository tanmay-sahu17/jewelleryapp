import 'package:flutter/material.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class RateCard extends StatefulWidget {
  const RateCard({
    super.key,
    required this.rates,
    this.lastUpdatedAt,
  });

  final Map<String, double> rates;
  final DateTime? lastUpdatedAt;

  @override
  State<RateCard> createState() => _RateCardState();
}

class _RateCardState extends State<RateCard> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(1.4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.gold,
            AppColors.gold.withValues(alpha: 0.65),
            AppColors.silver,
            AppColors.gold.withValues(alpha: 0.82),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.14),
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.charcoal,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.todaysShopRate,
              style: textTheme.titleLarge?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.bestValuePricing,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              _lastUpdatedLabel(),
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.softGold,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            _rateRow(
              icon: Icons.workspace_premium_rounded,
              title: l10n.gold22k,
              value: widget.rates['Gold22K'] ?? 68250,
            ),
            const SizedBox(height: 10),
            _rateRow(
              icon: Icons.stars_rounded,
              title: l10n.gold24k,
              value: widget.rates['Gold24K'] ?? 74400,
            ),
            const SizedBox(height: 10),
            _rateRow(
              icon: Icons.diamond_outlined,
              title: l10n.silver,
              value: widget.rates['Silver'] ?? 870,
            ),
          ],
        ),
      ),
    );
  }

  String _lastUpdatedLabel() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final DateTime? updatedAt = widget.lastUpdatedAt;
    if (updatedAt == null) {
      return l10n.lastUpdatedUnknown;
    }

    return l10n.lastUpdatedAt(DateFormat('h:mm a').format(updatedAt));
  }

  Widget _rateRow({
    required IconData icon,
    required String title,
    required double value,
  }) {
    return Row(
      children: <Widget>[
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.gold.withValues(alpha: 0.14),
          ),
          child: Icon(icon, color: AppColors.softGold, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        Text(
          formatRupee(value, suffix: '/10g'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.cream,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
