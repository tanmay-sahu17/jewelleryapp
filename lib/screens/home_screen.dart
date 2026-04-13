import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
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
import 'notifications_screen.dart';
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
  final ValueNotifier<int> _productsSearchTrigger = ValueNotifier<int>(0);
  bool _isProductsSearchVisible = false;

  void _setIndex(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() {
      // Keep AppBar icon state in sync when leaving Products tab.
      if (_currentIndex == 1 && index != 1) {
        _isProductsSearchVisible = false;
      }
      _currentIndex = index;
    });
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

  void _handleThemeToggle(bool value) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    context.read<ShopProvider>().setDarkMode(value);
    HapticFeedback.selectionClick();

    final String modeLabel = value ? l10n.darkModeEnabled : l10n.lightModeEnabled;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1100),
          content: Text(modeLabel),
        ),
      );
  }

  void _handleLocaleToggle(String languageCode) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Locale nextLocale = Locale(languageCode);
    context.read<ShopProvider>().setLocale(nextLocale);
    HapticFeedback.selectionClick();

    final String message = languageCode == 'hi'
        ? l10n.languageChangedToHindi
        : l10n.languageChangedToEnglish;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1100),
          content: Text(message),
        ),
      );
  }

  String _titleForIndex(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.appTitle;
      case 1:
        return l10n.productsTab;
      case 2:
        return l10n.offersTab;
      case 3:
        return l10n.contactUs;
      default:
        return l10n.appTitle;
    }
  }

  @override
  void dispose() {
    _productsSearchTrigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<Widget> tabs = <Widget>[
      const _HomeTabContent(),
      ProductsScreen(searchToggleSignal: _productsSearchTrigger),
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
          border: Border(
            top: BorderSide(color: AppColors.gold.withValues(alpha: 0.25)),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.11),
              blurRadius: 14,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _setIndex,
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.gold,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home, color: Colors.white),
              label: l10n.homeTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.grid_view_outlined),
              selectedIcon: const Icon(
                Icons.grid_view_rounded,
                color: Colors.white,
              ),
              label: l10n.productsTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.local_offer_outlined),
              selectedIcon: const Icon(
                Icons.local_offer_rounded,
                color: Colors.white,
              ),
              label: l10n.offersTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.support_agent_outlined),
              selectedIcon: const Icon(Icons.support_agent, color: Colors.white),
              label: l10n.contactTab,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (_currentIndex == 0) {
      final String shopName = context.read<ShopProvider>().shopInfo.name;
      final int unreadCount = context.select<ShopProvider, int>(
        (ShopProvider provider) => provider.unreadNotificationCount,
      );

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
                color: Colors.white.withValues(alpha: 0.75),
              ),
              child: Icon(
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
                  l10n.premiumGoldSilver,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.notifications,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                const Icon(Icons.notifications_none_rounded),
                if (unreadCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softGold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : '$unreadCount',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 6),
        ],
      );
    }

    if (_currentIndex == 1) {
      return AppBar(
        title: Text(
          _titleForIndex(l10n, _currentIndex),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: <Widget>[
          IconButton(
            tooltip: _isProductsSearchVisible
                ? l10n.closeSearch
                : l10n.searchProducts,
            onPressed: () {
              _productsSearchTrigger.value = _productsSearchTrigger.value + 1;
              setState(() {
                _isProductsSearchVisible = !_isProductsSearchVisible;
              });
            },
            icon: Icon(
              _isProductsSearchVisible
                  ? Icons.close_rounded
                  : Icons.search_rounded,
            ),
          ),
          const SizedBox(width: 6),
        ],
      );
    }

    return AppBar(
      title: Text(
        _titleForIndex(l10n, _currentIndex),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final shopInfo = context.read<ShopProvider>().shopInfo;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool isDarkMode = context.select<ShopProvider, bool>(
      (ShopProvider provider) => provider.isDarkMode,
    );
    final String currentLanguageCode = context.select<ShopProvider, String>(
      (ShopProvider provider) => provider.locale.languageCode,
    );

    return Drawer(
      backgroundColor: AppColors.charcoal.withValues(alpha: 0.98),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            AppColors.gold.withValues(alpha: 0.22),
                            AppColors.canvas,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 27,
                            backgroundColor: Colors.white,
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
                    Divider(
                      height: 1,
                      color: AppColors.border.withValues(alpha: 0.85),
                    ),
                    _DrawerTile(
                      icon: Icons.home_outlined,
                      label: l10n.homeTab,
                      onTap: () {
                        Navigator.of(context).pop();
                        _setIndex(0);
                      },
                    ),
                    _DrawerTile(
                      icon: Icons.grid_view_outlined,
                      label: l10n.productsTab,
                      onTap: () {
                        Navigator.of(context).pop();
                        _setIndex(1);
                      },
                    ),
                    _DrawerTile(
                      icon: Icons.local_offer_outlined,
                      label: l10n.offersTab,
                      onTap: () {
                        Navigator.of(context).pop();
                        _setIndex(2);
                      },
                    ),
                    _DrawerTile(
                      icon: Icons.call_outlined,
                      label: l10n.contactUs,
                      onTap: () {
                        Navigator.of(context).pop();
                        _setIndex(3);
                      },
                    ),
                    _DrawerTile(
                      icon: Icons.account_balance_outlined,
                      label: l10n.bankDetails,
                      onTap: () {
                        Navigator.of(context).pop();
                        _openBankDetails();
                      },
                    ),
                    _DrawerTile(
                      icon: Icons.info_outline_rounded,
                      label: l10n.aboutShop,
                      onTap: () {
                        Navigator.of(context).pop();
                        _openAbout();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.language_rounded,
                            color: AppColors.softGold,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            l10n.language,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ChoiceChip(
                              label: Text(l10n.english),
                              selected: currentLanguageCode == 'en',
                              onSelected: (_) => _handleLocaleToggle('en'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ChoiceChip(
                              label: Text(l10n.hindi),
                              selected: currentLanguageCode == 'hi',
                              onSelected: (_) => _handleLocaleToggle('hi'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 4, 10, 6),
                      child: SwitchListTile.adaptive(
                        value: isDarkMode,
                        onChanged: _handleThemeToggle,
                        secondary: Icon(
                          isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: AppColors.softGold,
                        ),
                        title: Text(
                          l10n.darkMode,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          isDarkMode ? l10n.enabled : l10n.disabled,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        activeThumbColor: AppColors.gold,
                        activeTrackColor: AppColors.gold.withValues(alpha: 0.4),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Text(
                        l10n.themeAppliesInstantly,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: AppColors.mutedText),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
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
                          label: Text(l10n.callShowroom),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeTabContent extends StatelessWidget {
  const _HomeTabContent();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return PremiumBackground(
      child: Consumer<ShopProvider>(
        builder:
            (BuildContext context, ShopProvider shopProvider, Widget? child) {
              final List<Product> featuredProducts =
                  shopProvider.featuredProducts;
              final _ShopStatusInfo shopStatus = _ShopStatusInfo
                  .fromBusinessHours(
                    shopProvider.shopInfo.businessHours,
                    DateTime.now(),
                  );

              return RefreshIndicator(
                color: AppColors.gold,
                onRefresh: shopProvider.refreshHomeData,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  children: <Widget>[
                    _ShopStatusBanner(status: shopStatus),
                    const SizedBox(height: 12),
                    LiveRateTicker(rates: shopProvider.liveRates),
                    const SizedBox(height: 14),
                    RateCard(
                      rates: shopProvider.shopRates,
                      lastUpdatedAt: shopProvider.shopRatesLastUpdatedAt,
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(
                      title: l10n.limitedTimeOffers,
                      subtitle: l10n.freshFestiveDeals,
                    ),
                    const SizedBox(height: 10),
                    OfferBanner(offers: shopProvider.offers),
                    const SizedBox(height: 22),
                    _SectionTitle(
                      title: l10n.featuredCollection,
                      subtitle: l10n.handpickedPremiumDesigns,
                    ),
                    const SizedBox(height: 10),
                    if (featuredProducts.isEmpty)
                      EmptyState(
                        title: l10n.noFeaturedProductsYet,
                        subtitle: l10n.newLuxuryPiecesSoon,
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String localizedName =
        product.localizedNameForLanguage(provider.locale.languageCode);
    return LauncherUtils.whatsapp(
      context,
      phoneNumber: provider.shopInfo.whatsapp,
      message: l10n.homeWhatsAppMessage(
        localizedName,
        product.weightLabel,
        product.purity,
      ),
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
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.softGold,
      ),
      onTap: onTap,
    );
  }
}

class _ShopStatusBanner extends StatelessWidget {
  const _ShopStatusBanner({required this.status});

  final _ShopStatusInfo status;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color statusColor = status.isOpen
        ? const Color(0xFF2ECC71)
        : const Color(0xFFE74C3C);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.charcoal.withValues(alpha: 0.97),
        border: Border.all(color: statusColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  status.isOpen ? l10n.shopOpenNow : l10n.shopClosedNow,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  '${status.localizedMessage(l10n)} • ${l10n.todayLabel}: ${status.localizedTodayHours(l10n)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopStatusInfo {
  const _ShopStatusInfo({
    required this.isOpen,
    required this.todayHours,
    required this.message,
  });

  final bool isOpen;
  final String todayHours;
  final String message;

  static _ShopStatusInfo fromBusinessHours(
    Map<String, String> businessHours,
    DateTime now,
  ) {
    final String weekday = _weekdayName(now.weekday);
    final String todayHours = businessHours[weekday] ?? 'Closed';

    if (todayHours.toLowerCase() == 'closed') {
      return const _ShopStatusInfo(
        isOpen: false,
        todayHours: 'Closed',
        message: 'closedToday',
      );
    }

    final List<String> range = todayHours.split('-');
    if (range.length != 2) {
      return _ShopStatusInfo(
        isOpen: false,
        todayHours: todayHours,
        message: 'checkBusinessHours',
      );
    }

    final DateFormat formatter = DateFormat('h:mm a');

    try {
      final DateTime startParsed = formatter.parse(range[0].trim());
      final DateTime endParsed = formatter.parse(range[1].trim());

      final DateTime start = DateTime(
        now.year,
        now.month,
        now.day,
        startParsed.hour,
        startParsed.minute,
      );

      DateTime end = DateTime(
        now.year,
        now.month,
        now.day,
        endParsed.hour,
        endParsed.minute,
      );

      if (end.isBefore(start)) {
        end = end.add(const Duration(days: 1));
      }

      final bool isOpen = !now.isBefore(start) && now.isBefore(end);
      final String message = isOpen
          ? 'closesAt:${formatter.format(end)}'
          : now.isBefore(start)
          ? 'opensAt:${formatter.format(start)}'
          : 'opensTomorrowAt:${formatter.format(start)}';

      return _ShopStatusInfo(
        isOpen: isOpen,
        todayHours: todayHours,
        message: message,
      );
    } catch (_) {
      return _ShopStatusInfo(
        isOpen: false,
        todayHours: todayHours,
        message: 'checkBusinessHours',
      );
    }
  }

  String localizedTodayHours(AppLocalizations l10n) {
    return todayHours.toLowerCase() == 'closed' ? l10n.closed : todayHours;
  }

  String localizedMessage(AppLocalizations l10n) {
    if (message == 'closedToday') {
      return l10n.shopClosedToday;
    }
    if (message == 'checkBusinessHours') {
      return l10n.checkBusinessHours;
    }
    if (message.startsWith('closesAt:')) {
      return l10n.closesAt(message.substring('closesAt:'.length));
    }
    if (message.startsWith('opensAt:')) {
      return l10n.opensAt(message.substring('opensAt:'.length));
    }
    if (message.startsWith('opensTomorrowAt:')) {
      return l10n.opensTomorrowAt(message.substring('opensTomorrowAt:'.length));
    }
    return message;
  }

  static String _weekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }
}
