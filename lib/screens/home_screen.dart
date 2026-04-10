import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import '../utils/launcher_utils.dart';
import '../widgets/empty_state.dart';
import '../widgets/live_rate_ticker.dart';
import '../widgets/offer_banner.dart';
import '../widgets/premium_background.dart';
import '../widgets/product_card.dart';
import '../widgets/rate_card.dart';
import 'about_screen.dart';
import 'bank_details_screen.dart';
import 'contact_screen.dart';
import 'offers_screen.dart';
import 'product_detail_screen.dart';
import 'products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<String> _titles = <String>[
    'Gulab Jewellers',
    'Products',
    'Offers',
    'Contact Us',
  ];

  void _setIndex(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _openBankDetails() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const BankDetailsScreen()));
  }

  void _openAbout() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AboutScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = <Widget>[
      const _HomeTabContent(),
      const ProductsScreen(),
      const OffersScreen(),
      ContactScreen(onOpenBankDetails: _openBankDetails),
    ];

    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: tabs[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.charcoal,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _setIndex,
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.gold.withValues(alpha: 0.25),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_offer_outlined),
              selectedIcon: Icon(Icons.local_offer_rounded),
              label: 'Offers',
            ),
            NavigationDestination(
              icon: Icon(Icons.support_agent_outlined),
              selectedIcon: Icon(Icons.support_agent),
              label: 'Contact',
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    if (_currentIndex == 0) {
      final String shopName = context.read<ShopProvider>().shopInfo.name;

      return AppBar(
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 1.3),
                color: AppColors.charcoal,
              ),
              child: const Icon(
                Icons.diamond,
                color: AppColors.softGold,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  shopName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 22),
                ),
                Text(
                  'Premium Gold & Silver',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications.')),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 6),
        ],
      );
    }

    return AppBar(
      title: Text(
        _titles[_currentIndex],
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final shopInfo = context.read<ShopProvider>().shopInfo;

    return Drawer(
      backgroundColor: AppColors.charcoal,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    AppColors.gold.withValues(alpha: 0.24),
                    AppColors.charcoal,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 27,
                    backgroundColor: AppColors.black,
                    child: Icon(
                      Icons.diamond,
                      color: AppColors.softGold,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    shopInfo.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shopInfo.address,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _DrawerTile(
              icon: Icons.home_outlined,
              label: 'Home',
              onTap: () {
                Navigator.of(context).pop();
                _setIndex(0);
              },
            ),
            _DrawerTile(
              icon: Icons.grid_view_outlined,
              label: 'Products',
              onTap: () {
                Navigator.of(context).pop();
                _setIndex(1);
              },
            ),
            _DrawerTile(
              icon: Icons.local_offer_outlined,
              label: 'Offers',
              onTap: () {
                Navigator.of(context).pop();
                _setIndex(2);
              },
            ),
            _DrawerTile(
              icon: Icons.call_outlined,
              label: 'Contact Us',
              onTap: () {
                Navigator.of(context).pop();
                _setIndex(3);
              },
            ),
            _DrawerTile(
              icon: Icons.account_balance_outlined,
              label: 'Bank Details',
              onTap: () {
                Navigator.of(context).pop();
                _openBankDetails();
              },
            ),
            _DrawerTile(
              icon: Icons.info_outline_rounded,
              label: 'About Shop',
              onTap: () {
                Navigator.of(context).pop();
                _openAbout();
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    final String phone = context
                        .read<ShopProvider>()
                        .shopInfo
                        .primaryPhone;
                    LauncherUtils.call(context, phone);
                  },
                  icon: const Icon(Icons.phone_outlined),
                  label: const Text('Call Showroom'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabContent extends StatelessWidget {
  const _HomeTabContent();

  @override
  Widget build(BuildContext context) {
    return PremiumBackground(
      child: Consumer<ShopProvider>(
        builder:
            (BuildContext context, ShopProvider shopProvider, Widget? child) {
              final List<Product> featuredProducts =
                  shopProvider.featuredProducts;

              return RefreshIndicator(
                color: AppColors.gold,
                onRefresh: shopProvider.refreshHomeData,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  children: <Widget>[
                    LiveRateTicker(rates: shopProvider.liveRates),
                    const SizedBox(height: 14),
                    RateCard(rates: shopProvider.shopRates),
                    const SizedBox(height: 20),
                    _SectionTitle(
                      title: 'Limited Time Offers',
                      subtitle: 'Fresh festive deals updated daily',
                    ),
                    const SizedBox(height: 10),
                    OfferBanner(offers: shopProvider.offers),
                    const SizedBox(height: 22),
                    _SectionTitle(
                      title: 'Featured Collection',
                      subtitle: 'Handpicked premium designs for you',
                    ),
                    const SizedBox(height: 10),
                    if (featuredProducts.isEmpty)
                      const EmptyState(
                        title: 'No featured products yet',
                        subtitle: 'New luxury pieces will be added shortly.',
                      )
                    else
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                              final double width = constraints.maxWidth;
                              int crossAxisCount = 2;
                              if (width > 980) {
                                crossAxisCount = 4;
                              } else if (width > 680) {
                                crossAxisCount = 3;
                              }

                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: featuredProducts.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 0.58,
                                    ),
                                itemBuilder: (BuildContext context, int index) {
                                  final Product product =
                                      featuredProducts[index];
                                  return ProductCard(
                                    product: product,
                                    onTap: () =>
                                        _openProductDetails(context, product),
                                    onEnquire: () =>
                                        _openWhatsApp(context, product),
                                  );
                                },
                              );
                            },
                      ),
                  ],
                ),
              );
            },
      ),
    );
  }

  Future<void> _openWhatsApp(BuildContext context, Product product) {
    final ShopProvider provider = context.read<ShopProvider>();
    return LauncherUtils.whatsapp(
      context,
      phoneNumber: provider.shopInfo.whatsapp,
      message:
          'Namaste, I want to enquire about ${product.name} (${product.weightLabel}, ${product.purity}).',
    );
  }

  void _openProductDetails(BuildContext context, Product product) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return ProductDetailScreen(product: product);
            },
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              final Animation<double> fade = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );

              final Animation<Offset> slide = Tween<Offset>(
                begin: const Offset(0.06, 0.02),
                end: Offset.zero,
              ).animate(fade);

              return FadeTransition(
                opacity: fade,
                child: SlideTransition(position: slide, child: child),
              );
            },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.softGold),
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.silver,
      ),
      onTap: onTap,
    );
  }
}
