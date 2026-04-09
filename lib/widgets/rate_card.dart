import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class RateCard extends StatefulWidget {
  const RateCard({super.key, required this.rates});

  final Map<String, double> rates;

  @override
  State<RateCard> createState() => _RateCardState();
}

class _RateCardState extends State<RateCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double shift = (_controller.value * 2) - 1;

        return Container(
          padding: const EdgeInsets.all(1.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment(-1 + shift, -1),
              end: Alignment(1 - shift, 1),
              colors: const <Color>[
                AppColors.gold,
                AppColors.softGold,
                AppColors.silver,
                AppColors.gold,
              ],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.22),
                blurRadius: 18,
                spreadRadius: 0,
                offset: const Offset(0, 6),
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
                  "Today's Shop Rate",
                  style: textTheme.titleLarge?.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  'Best value pricing for in-store purchase.',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                _rateRow(
                  icon: Icons.workspace_premium_rounded,
                  title: 'Gold 22K',
                  value: widget.rates['Gold22K'] ?? 6825,
                ),
                const SizedBox(height: 10),
                _rateRow(
                  icon: Icons.stars_rounded,
                  title: 'Gold 24K',
                  value: widget.rates['Gold24K'] ?? 7440,
                ),
                const SizedBox(height: 10),
                _rateRow(
                  icon: Icons.diamond_outlined,
                  title: 'Silver',
                  value: widget.rates['Silver'] ?? 87,
                ),
              ],
            ),
          ),
        );
      },
    );
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
            color: AppColors.gold.withValues(alpha: 0.13),
          ),
          child: Icon(icon, color: AppColors.softGold, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        Text(
          formatRupee(value, suffix: '/g'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.softGold,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
