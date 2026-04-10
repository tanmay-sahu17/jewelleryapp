import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import '../utils/launcher_utils.dart';
import '../widgets/premium_background.dart';
import 'bank_details_screen.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key, this.onOpenBankDetails});

  final VoidCallback? onOpenBankDetails;

  @override
  Widget build(BuildContext context) {
    return PremiumBackground(
      child: Consumer<ShopProvider>(
        builder: (BuildContext context, ShopProvider provider, Widget? child) {
          final shop = provider.shopInfo;

          return ListView(
            padding: const EdgeInsets.only(top: 10, bottom: 24),
            children: <Widget>[
              Text(
                'Visit Our Showroom',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.location_on_outlined,
                title: shop.name,
                subtitle: shop.address,
              ),
              const SizedBox(height: 12),
              _PhoneTile(
                label: 'Primary',
                phoneNumber: shop.primaryPhone,
                onTap: () => LauncherUtils.call(context, shop.primaryPhone),
              ),
              const SizedBox(height: 8),
              _PhoneTile(
                label: 'Secondary',
                phoneNumber: shop.secondaryPhone,
                onTap: () => LauncherUtils.call(context, shop.secondaryPhone),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => LauncherUtils.whatsapp(
                        context,
                        phoneNumber: shop.whatsapp,
                        message:
                            'Hi Gulab Jewellers, I want to know more about your latest collection.',
                      ),
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                      label: const Text('WhatsApp'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => LauncherUtils.email(context, shop.email),
                      icon: const Icon(Icons.email_outlined),
                      label: const Text('Email'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Business Hours',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.charcoal,
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                ),
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(1.1),
                    1: FlexColumnWidth(1.5),
                  },
                  children: shop.businessHours.entries.map((entry) {
                    return TableRow(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            entry.key,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            entry.value,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Find Us On Map',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF1D1812), Color(0xFF151515)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.map_outlined,
                        size: 44,
                        color: AppColors.softGold,
                      ),
                      SizedBox(height: 8),
                      Text('Google Map Preview Placeholder'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (onOpenBankDetails != null) {
                      onOpenBankDetails!();
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const BankDetailsScreen(),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.account_balance_outlined),
                  label: const Text('Payment Details'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: AppColors.softGold, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneTile extends StatelessWidget {
  const _PhoneTile({
    required this.label,
    required this.phoneNumber,
    required this.onTap,
  });

  final String label;
  final String phoneNumber;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.charcoal,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: <Widget>[
              const Icon(Icons.call, color: AppColors.softGold, size: 19),
              const SizedBox(width: 10),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Text(phoneNumber, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
