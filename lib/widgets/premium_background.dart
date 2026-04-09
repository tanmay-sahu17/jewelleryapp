import 'dart:ui';

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
    final Widget content = Padding(padding: padding, child: child);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.appBackground),
      child: Stack(
        children: <Widget>[
          const Positioned(
            top: -90,
            left: -80,
            child: _GlowOrb(color: AppColors.gold, size: 220, opacity: 0.15),
          ),
          const Positioned(
            top: 220,
            right: -100,
            child: _GlowOrb(color: AppColors.silver, size: 240, opacity: 0.08),
          ),
          const Positioned(
            bottom: -110,
            left: 40,
            child: _GlowOrb(color: AppColors.maroon, size: 240, opacity: 0.16),
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
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: opacity),
            ),
          ),
        ),
      ),
    );
  }
}
