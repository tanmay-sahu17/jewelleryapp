import 'package:flutter/material.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return PremiumBackground(
      child: Consumer<ShopProvider>(
        builder: (BuildContext context, ShopProvider provider, Widget? child) {
          final shop = provider.shopInfo;

          return ListView(
            padding: const EdgeInsets.only(top: 10, bottom: 24),
            children: <Widget>[
              Text(
                l10n.visitOurShowroom,
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
                label: l10n.primary,
                phoneNumber: shop.primaryPhone,
                onTap: () => LauncherUtils.call(context, shop.primaryPhone),
              ),
              const SizedBox(height: 8),
              _PhoneTile(
                label: l10n.secondary,
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
                        message: l10n.contactWhatsAppMessage,
                      ),
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                      label: Text(l10n.whatsapp),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => LauncherUtils.email(context, shop.email),
                      icon: const Icon(Icons.email_outlined),
                      label: Text(l10n.email),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.businessHours,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.charcoal,
                  border: Border.all(color: AppColors.border),
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
                            _localizedWeekday(entry.key, l10n),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            _localizedHours(entry.value, l10n),
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
                l10n.findUsOnMap,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFFF5E3), Color(0xFFF2E5CC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.map_outlined,
                        size: 44,
                        color: AppColors.softGold,
                      ),
                      SizedBox(height: 8),
                      Text(l10n.googleMapPlaceholder),
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
                  label: Text(l10n.paymentDetails),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _localizedHours(String value, AppLocalizations l10n) {
    return value.toLowerCase() == 'closed' ? l10n.closed : value;
  }

  String _localizedWeekday(String key, AppLocalizations l10n) {
    switch (key.toLowerCase()) {
      case 'monday':
        return l10n.weekdayMonday;
      case 'tuesday':
        return l10n.weekdayTuesday;
      case 'wednesday':
        return l10n.weekdayWednesday;
      case 'thursday':
        return l10n.weekdayThursday;
      case 'friday':
        return l10n.weekdayFriday;
      case 'saturday':
        return l10n.weekdaySaturday;
      case 'sunday':
        return l10n.weekdaySunday;
      default:
        return key;
    }
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
      shadowColor: AppColors.black.withValues(alpha: 0.05),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: <Widget>[
              Icon(Icons.call, color: AppColors.softGold, size: 19),
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
