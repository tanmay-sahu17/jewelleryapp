import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_background.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Details')),
      body: PremiumBackground(
        child: Consumer<ShopProvider>(
          builder:
              (BuildContext context, ShopProvider provider, Widget? child) {
                final bank = provider.bankDetails;
                return ListView(
                  padding: const EdgeInsets.only(top: 12, bottom: 24),
                  children: <Widget>[
                    Text(
                      'For advance booking or token amount only',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.softGold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CopyableInfoCard(
                      title: 'Bank Name',
                      value: bank.bankName,
                      onCopy: () => _copy(context, 'Bank Name', bank.bankName),
                    ),
                    const SizedBox(height: 10),
                    _CopyableInfoCard(
                      title: 'Account Holder Name',
                      value: bank.accountHolder,
                      onCopy: () => _copy(
                        context,
                        'Account Holder Name',
                        bank.accountHolder,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _CopyableInfoCard(
                      title: 'Account Number',
                      value: bank.accountNumber,
                      onCopy: () =>
                          _copy(context, 'Account Number', bank.accountNumber),
                    ),
                    const SizedBox(height: 10),
                    _CopyableInfoCard(
                      title: 'IFSC Code',
                      value: bank.ifscCode,
                      onCopy: () => _copy(context, 'IFSC Code', bank.ifscCode),
                    ),
                    const SizedBox(height: 10),
                    _CopyableInfoCard(
                      title: 'UPI ID',
                      value: bank.upiId,
                      onCopy: () => _copy(context, 'UPI ID', bank.upiId),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'QR Code',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: AppColors.charcoal,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.3),
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
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.qr_code_2_rounded,
                                size: 90,
                                color: AppColors.black,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'QR Placeholder',
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$label copied to clipboard.')));
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
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
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
              const Icon(Icons.copy_rounded, color: AppColors.softGold),
            ],
          ),
        ),
      ),
    );
  }
}
