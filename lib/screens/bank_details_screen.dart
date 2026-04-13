import 'package:flutter/material.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_background.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentDetails)),
      body: PremiumBackground(
        child: Consumer<ShopProvider>(
          builder:
              (BuildContext context, ShopProvider provider, Widget? child) {
                final bank = provider.bankDetails;
                return ListView(
                  padding: const EdgeInsets.only(top: 12, bottom: 24),
                  children: <Widget>[
                    Text(
                      l10n.advanceBookingOnly,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.softGold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CopyableInfoCard(
                      title: l10n.bankName,
                      value: bank.bankName,
                      onCopy: () => _copy(context, l10n.bankName, bank.bankName),
                    ),
                    const SizedBox(height: 10),
                    _CopyableInfoCard(
                      title: l10n.accountHolderName,
                      value: bank.accountHolder,
                      onCopy: () => _copy(
                        context,
                        l10n.accountHolderName,
                        bank.accountHolder,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _CopyableInfoCard(
                      title: l10n.accountNumber,
                      value: bank.accountNumber,
                      onCopy: () =>
                          _copy(context, l10n.accountNumber, bank.accountNumber),
                    ),
                    const SizedBox(height: 10),
                    _CopyableInfoCard(
                      title: l10n.ifscCode,
                      value: bank.ifscCode,
                      onCopy: () => _copy(context, l10n.ifscCode, bank.ifscCode),
                    ),
                    const SizedBox(height: 10),
                    _CopyableInfoCard(
                      title: l10n.upiId,
                      value: bank.upiId,
                      onCopy: () => _copy(context, l10n.upiId, bank.upiId),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      l10n.qrCode,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: AppColors.charcoal,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.silver),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.qr_code_2_rounded,
                                size: 90,
                                color: AppColors.black,
                              ),
                              SizedBox(height: 8),
                              Text(
                                l10n.qrPlaceholder,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
        ),
      ),
    );
  }

  Future<void> _copy(BuildContext context, String label, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (context.mounted) {
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(l10n.copiedToClipboard(label))),
      );
    }
  }
}

class _CopyableInfoCard extends StatelessWidget {
  const _CopyableInfoCard({
    required this.title,
    required this.value,
    required this.onCopy,
  });

  final String title;
  final String value;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.charcoal,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onCopy,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(value, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.copy_rounded, color: AppColors.softGold),
            ],
          ),
        ),
      ),
    );
  }
}
