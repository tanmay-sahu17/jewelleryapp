import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/offer_model.dart';
import '../theme/app_theme.dart';

class OfferBanner extends StatefulWidget {
  const OfferBanner({super.key, required this.offers, this.height = 188});

  final List<ShopOffer> offers;
  final double height;

  @override
  State<OfferBanner> createState() => _OfferBannerState();
}

class _OfferBannerState extends State<OfferBanner> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _activeIndex = 0;

  static const List<List<Color>> _gradients = <List<Color>>[
    <Color>[Color(0xFF5A1E1E), Color(0xFFB8852F)],
    <Color>[Color(0xFF3D2618), Color(0xFFD4A017)],
    <Color>[Color(0xFF2E1E1E), Color(0xFFC07A2A)],
    <Color>[Color(0xFF2F2520), Color(0xFF9C7A31)],
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.offers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.offers.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final ShopOffer offer = widget.offers[index];
            final List<Color> gradient = _gradients[index % _gradients.length];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: offer.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (BuildContext context, String _) =>
                          Container(color: gradient.first),
                      errorWidget:
                          (BuildContext context, String _, Object __) =>
                              Container(color: gradient.last),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: <Color>[
                            Colors.black.withValues(alpha: 0.75),
                            gradient.last.withValues(alpha: 0.25),
                            Colors.transparent,
                          ],
                          stops: const <double>[0.0, 0.65, 1.0],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Spacer(),
                          Text(
                            offer.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppColors.cream,
                                  fontSize: 20,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            offer.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            offer.validUntil,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.softGold,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: 0.9,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 700),
            enlargeCenterPage: true,
            onPageChanged: (int index, CarouselPageChangedReason reason) {
              setState(() => _activeIndex = index);
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(
            widget.offers.length,
            (int index) => AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _activeIndex == index ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _activeIndex == index
                    ? AppColors.gold
                    : AppColors.cream.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
