import 'package:flutter/material.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';

import '../theme/app_theme.dart';
import '../widgets/premium_background.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: PremiumBackground(
        child: ListView(
          padding: const EdgeInsets.only(top: 12, bottom: 24),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.charcoal,
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                l10n.heritageOfTrust,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.aboutDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            _PointCard(
              icon: Icons.verified_outlined,
              title: l10n.certifiedPurity,
              subtitle: l10n.certifiedPuritySubtitle,
            ),
            const SizedBox(height: 10),
            _PointCard(
              icon: Icons.auto_awesome_outlined,
              title: l10n.exclusiveDesigns,
              subtitle: l10n.exclusiveDesignsSubtitle,
            ),
            const SizedBox(height: 10),
            _PointCard(
              icon: Icons.groups_2_outlined,
              title: l10n.familyCentricService,
              subtitle: l10n.familyCentricServiceSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  const _PointCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.charcoal,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withValues(alpha: 0.14),
            ),
            child: Icon(icon, color: AppColors.softGold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
