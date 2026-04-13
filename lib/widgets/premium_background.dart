import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PremiumBackground extends StatelessWidget {
  const PremiumBackground({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.useSafeArea = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    // Register dependency on Theme so background repaints immediately on mode toggle.
    final Brightness _ = Theme.of(context).brightness;
    final Widget content = Padding(padding: padding, child: child);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(gradient: AppColors.appBackground),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -100,
            left: -90,
            child: _GlowOrb(color: AppColors.gold, size: 250, opacity: 0.12),
          ),
          Positioned(
            top: 160,
            right: -110,
            child: _GlowOrb(color: AppColors.silver, size: 260, opacity: 0.28),
          ),
          Positioned(
            bottom: -120,
            left: 30,
            child: _GlowOrb(color: AppColors.maroon, size: 250, opacity: 0.1),
          ),
          Positioned(
            top: 22,
            right: 22,
            child: IgnorePointer(
              child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.18),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: useSafeArea ? SafeArea(child: content) : content,
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.color,
    required this.size,
    required this.opacity,
  });

  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0),
            ],
            stops: const <double>[0.15, 1],
          ),
        ),
      ),
    );
  }
}
