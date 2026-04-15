import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';

import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/premium_background.dart';

enum _CalculatorMetal {
  gold22k,
  gold24k,
  silver,
}

class PriceCalculatorScreen extends StatefulWidget {
  const PriceCalculatorScreen({super.key});

  @override
  State<PriceCalculatorScreen> createState() => _PriceCalculatorScreenState();
}

class _PriceCalculatorScreenState extends State<PriceCalculatorScreen> {
  static const List<_CalculatorMetal> _metals = <_CalculatorMetal>[
    _CalculatorMetal.gold22k,
    _CalculatorMetal.gold24k,
    _CalculatorMetal.silver,
  ];

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _makingController = TextEditingController();

  _CalculatorMetal _selectedMetal = _CalculatorMetal.gold22k;
  double? _shopRate;
  double? _metalValue;
  double? _makingCharges;
  double? _estimatedTotal;

  @override
  void dispose() {
    _weightController.dispose();
    _makingController.dispose();
    super.dispose();
  }

  void _calculateEstimate(ShopProvider provider) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();

    final double? weight = double.tryParse(_weightController.text.trim());
    final double? makingPercent = double.tryParse(_makingController.text.trim());

    if (weight == null || weight <= 0) {
      _showSnack(l10n.calculatorInvalidWeight);
      return;
    }

    if (makingPercent == null || makingPercent < 0) {
      _showSnack(l10n.calculatorInvalidMaking);
      return;
    }

    final String rateKey = _rateKeyForMetal(_selectedMetal);

    final double rate = provider.shopRates[rateKey] ?? 0;
    final double metalValue = (rate / 10) * weight;
    final double makingCharges = metalValue * (makingPercent / 100);
    final double total = metalValue + makingCharges;

    setState(() {
      _shopRate = rate;
      _metalValue = metalValue;
      _makingCharges = makingCharges;
      _estimatedTotal = total;
    });
  }

  String _rateKeyForMetal(_CalculatorMetal metal) {
    return switch (metal) {
      _CalculatorMetal.gold22k => 'Gold22K',
      _CalculatorMetal.gold24k => 'Gold24K',
      _CalculatorMetal.silver => 'Silver',
    };
  }

  String _metalLabel(_CalculatorMetal metal, AppLocalizations l10n) {
    return switch (metal) {
      _CalculatorMetal.gold22k => l10n.gold22k,
      _CalculatorMetal.gold24k => l10n.gold24k,
      _CalculatorMetal.silver => l10n.silver,
    };
  }

  Widget _buildMetalChip(_CalculatorMetal metal, AppLocalizations l10n) {
    final bool isSelected = _selectedMetal == metal;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (isSelected) {
          return;
        }
        setState(() => _selectedMetal = metal);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.gold.withValues(alpha: 0.16)
              : AppColors.charcoal.withValues(alpha: 0.75),
          border: Border.all(
            color: isSelected
                ? AppColors.gold.withValues(alpha: 0.86)
                : AppColors.border,
          ),
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _metalLabel(metal, l10n),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.cream : AppColors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.gold,
            AppColors.gold.withValues(alpha: 0.6),
            AppColors.silver,
            AppColors.gold.withValues(alpha: 0.75),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          color: AppColors.charcoal,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.14),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
              ),
              child: Icon(
                Icons.calculate_outlined,
                color: AppColors.softGold,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.priceCalculator,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 21),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.priceCalculatorSubtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard(
    AppLocalizations l10n,
    ShopProvider provider,
    double selectedRate,
  ) {
    return Container(
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.border,
            AppColors.gold.withValues(alpha: 0.44),
            AppColors.border,
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          color: AppColors.charcoal.withValues(alpha: 0.98),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(l10n.calculatorMetal, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _metals
                  .map((final _CalculatorMetal metal) => _buildMetalChip(metal, l10n))
                  .toList(growable: false),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.gold.withValues(alpha: 0.12),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.34)),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.local_offer_outlined, size: 18, color: AppColors.softGold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.calculatorRatePer10g,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mutedText,
                      ),
                    ),
                  ),
                  Text(
                    formatRupee(selectedRate, suffix: '/10g'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.cream,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
              ],
              decoration: InputDecoration(
                labelText: l10n.calculatorWeight,
                hintText: l10n.calculatorWeightHint,
                prefixIcon: const Icon(Icons.scale_outlined),
                suffixText: 'g',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _makingController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: l10n.calculatorMakingPercent,
                hintText: l10n.calculatorMakingHint,
                prefixIcon: const Icon(Icons.percent_rounded),
                suffixText: '%',
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _calculateEstimate(provider),
                icon: const Icon(Icons.calculate_outlined),
                label: Text(l10n.calculatorCalculate),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(1.3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.gold.withValues(alpha: 0.95),
            AppColors.silver,
            AppColors.gold.withValues(alpha: 0.76),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          color: AppColors.charcoal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.calculatorEstimatedTotal,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.softGold,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatRupee(_estimatedTotal ?? 0),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.cream,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            _PriceRow(
              label: l10n.calculatorRatePer10g,
              value: formatRupee(_shopRate ?? 0, suffix: '/10g'),
            ),
            const SizedBox(height: 8),
            _PriceRow(
              label: l10n.calculatorMetalValue,
              value: formatRupee(_metalValue ?? 0),
            ),
            const SizedBox(height: 8),
            _PriceRow(
              label: l10n.calculatorMakingCharges,
              value: formatRupee(_makingCharges ?? 0),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.priceCalculator)),
      body: PremiumBackground(
        child: Consumer<ShopProvider>(
          builder: (BuildContext context, ShopProvider provider, Widget? child) {
            final double selectedRate =
                provider.shopRates[_rateKeyForMetal(_selectedMetal)] ?? 0;

            return ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(top: 12, bottom: 22),
              children: <Widget>[
                _buildHeaderCard(l10n),
                const SizedBox(height: 14),
                _buildFormCard(l10n, provider, selectedRate),
                if (_estimatedTotal != null) ...<Widget>[
                  const SizedBox(height: 14),
                  _buildResultCard(l10n),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextStyle? labelStyle = Theme.of(context).textTheme.bodyMedium;
    final TextStyle? valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: AppColors.cream,
      fontWeight: FontWeight.w800,
    );

    return Row(
      children: <Widget>[
        Expanded(child: Text(label, style: labelStyle)),
        const SizedBox(width: 10),
        Text(value, style: valueStyle),
      ],
    );
  }
}
