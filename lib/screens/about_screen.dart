import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/premium_background.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Shop')),
      body: PremiumBackground(
        child: ListView(
          padding: const EdgeInsets.only(top: 12, bottom: 24),
          children: <Widget>[
            Text(
              'A Heritage of Trust',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Gulab Jewellers brings together timeless craftsmanship and modern taste in premium gold and silver jewellery. Every design is curated for elegance, purity, and family trust.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            _PointCard(
              icon: Icons.verified_outlined,
              title: 'Certified Purity',
              subtitle:
                  'We prioritize hallmarked jewellery and transparent pricing every day.',
            ),
            const SizedBox(height: 10),
            _PointCard(
              icon: Icons.auto_awesome_outlined,
              title: 'Exclusive Designs',
              subtitle:
                  'From bridal sets to daily wear, every collection is selected with finesse.',
            ),
            const SizedBox(height: 10),
            _PointCard(
              icon: Icons.groups_2_outlined,
              title: 'Family-Centric Service',
              subtitle:
                  'Warm guidance, honest recommendations, and personalized assistance.',
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
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
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
