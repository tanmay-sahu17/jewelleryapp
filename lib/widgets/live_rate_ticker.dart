import 'package:flutter/material.dart';

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
    final TextStyle textStyle = Theme.of(context).textTheme.titleMedium!
        .copyWith(
          color: AppColors.cream,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.35,
        );

    final String tickerText =
      'Gold 22K: ${formatRupee(widget.rates['Gold22K'] ?? 68500, suffix: '/10g')}   |   '
      'Gold 24K: ${formatRupee(widget.rates['Gold24K'] ?? 74700, suffix: '/10g')}   |   '
      'Silver: ${formatRupee(widget.rates['Silver'] ?? 890, suffix: '/10g')}   |   '
      'Updated Live Rates (10g)';

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.charcoal.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
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
                      controller: _controller,
                      text: tickerText,
                      style: textStyle,
                    ),
                  ),
                  Positioned(
                    left: baseLeft - travelDistance,
                    top: 11,
                    child: _ShimmerTickerText(
                      controller: _controller,
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
    required this.controller,
    required this.text,
    required this.style,
  });

  final AnimationController controller;
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        final double slide = (bounds.width * 2) * controller.value;
        return LinearGradient(
          colors: const <Color>[
            AppColors.gold,
            AppColors.softGold,
            Colors.white,
            AppColors.gold,
          ],
          stops: const <double>[0.0, 0.35, 0.52, 1.0],
          transform: _SlidingGradientTransform(slide),
        ).createShader(bounds);
      },
      child: Text(text, style: style),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(slidePercent - bounds.width, 0, 0);
  }
}
