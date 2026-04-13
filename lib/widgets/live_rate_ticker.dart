import 'package:flutter/material.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';

import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class LiveRateTicker extends StatefulWidget {
  const LiveRateTicker({super.key, required this.rates});

  final Map<String, double> rates;

  @override
  State<LiveRateTicker> createState() => _LiveRateTickerState();
}

class _LiveRateTickerState extends State<LiveRateTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final TextStyle textStyle = Theme.of(context).textTheme.titleMedium!
        .copyWith(
          color: AppColors.cream,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.35,
        );

    final String tickerText = l10n.liveRateTickerText(
      formatRupee(widget.rates['Gold22K'] ?? 68500, suffix: '/10g'),
      formatRupee(widget.rates['Gold24K'] ?? 74700, suffix: '/10g'),
      formatRupee(widget.rates['Silver'] ?? 890, suffix: '/10g'),
    );

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.charcoal.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double textWidth = _measureTextWidth(
            context,
            tickerText,
            textStyle,
          );
          final double travelDistance = constraints.maxWidth + textWidth + 90;

          return AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              final double baseLeft =
                  -textWidth + (travelDistance * _controller.value);

              return Stack(
                children: <Widget>[
                  Positioned(
                    left: baseLeft,
                    top: 11,
                    child: _ShimmerTickerText(
                      text: tickerText,
                      style: textStyle,
                    ),
                  ),
                  Positioned(
                    left: baseLeft - travelDistance,
                    top: 11,
                    child: _ShimmerTickerText(
                      text: tickerText,
                      style: textStyle,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  double _measureTextWidth(BuildContext context, String text, TextStyle style) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();

    return painter.width;
  }
}

class _ShimmerTickerText extends StatelessWidget {
  const _ShimmerTickerText({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(color: AppColors.cream),
    );
  }
}
