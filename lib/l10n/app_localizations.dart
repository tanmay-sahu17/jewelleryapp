import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'package:shri_jewellers/l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Gulab Jewellers'**
  String get appTitle;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @productsTab.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTab;

  /// No description provided for @offersTab.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offersTab;

  /// No description provided for @contactTab.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactTab;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @premiumGoldSilver.
  ///
  /// In en, this message translates to:
  /// **'Premium Gold & Silver'**
  String get premiumGoldSilver;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @closeSearch.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get closeSearch;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchProducts;

  /// No description provided for @darkModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Dark mode enabled'**
  String get darkModeEnabled;

  /// No description provided for @lightModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Light mode enabled'**
  String get lightModeEnabled;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @themeAppliesInstantly.
  ///
  /// In en, this message translates to:
  /// **'Theme applies instantly across all screens.'**
  String get themeAppliesInstantly;

  /// No description provided for @callShowroom.
  ///
  /// In en, this message translates to:
  /// **'Call Showroom'**
  String get callShowroom;

  /// No description provided for @bankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get bankDetails;

  /// No description provided for @aboutShop.
  ///
  /// In en, this message translates to:
  /// **'About Shop'**
  String get aboutShop;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @languageChangedToEnglish.
  ///
  /// In en, this message translates to:
  /// **'Language changed to English'**
  String get languageChangedToEnglish;

  /// No description provided for @languageChangedToHindi.
  ///
  /// In en, this message translates to:
  /// **'Language changed to Hindi'**
  String get languageChangedToHindi;

  /// No description provided for @limitedTimeOffers.
  ///
  /// In en, this message translates to:
  /// **'Limited Time Offers'**
  String get limitedTimeOffers;

  /// No description provided for @freshFestiveDeals.
  ///
  /// In en, this message translates to:
  /// **'Fresh festive deals updated daily'**
  String get freshFestiveDeals;

  /// No description provided for @featuredCollection.
  ///
  /// In en, this message translates to:
  /// **'Featured Collection'**
  String get featuredCollection;

  /// No description provided for @handpickedPremiumDesigns.
  ///
  /// In en, this message translates to:
  /// **'Handpicked premium designs for you'**
  String get handpickedPremiumDesigns;

  /// No description provided for @noFeaturedProductsYet.
  ///
  /// In en, this message translates to:
  /// **'No featured products yet'**
  String get noFeaturedProductsYet;

  /// No description provided for @newLuxuryPiecesSoon.
  ///
  /// In en, this message translates to:
  /// **'New luxury pieces will be added shortly.'**
  String get newLuxuryPiecesSoon;

  /// No description provided for @homeWhatsAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Namaste, I want to enquire about {name} ({weight}, {purity}).'**
  String homeWhatsAppMessage(Object name, Object weight, Object purity);

  /// No description provided for @shopOpenNow.
  ///
  /// In en, this message translates to:
  /// **'Shop Open Now'**
  String get shopOpenNow;

  /// No description provided for @shopClosedNow.
  ///
  /// In en, this message translates to:
  /// **'Shop Closed Now'**
  String get shopClosedNow;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @shopClosedToday.
  ///
  /// In en, this message translates to:
  /// **'Shop is closed today'**
  String get shopClosedToday;

  /// No description provided for @checkBusinessHours.
  ///
  /// In en, this message translates to:
  /// **'Check business hours'**
  String get checkBusinessHours;

  /// No description provided for @closesAt.
  ///
  /// In en, this message translates to:
  /// **'Closes at {time}'**
  String closesAt(Object time);

  /// No description provided for @opensAt.
  ///
  /// In en, this message translates to:
  /// **'Opens at {time}'**
  String opensAt(Object time);

  /// No description provided for @opensTomorrowAt.
  ///
  /// In en, this message translates to:
  /// **'Opens tomorrow at {time}'**
  String opensTomorrowAt(Object time);

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @productInquiryInStock.
  ///
  /// In en, this message translates to:
  /// **'Hello Gulab Jewellers, I want details for {name} ({weight}, {purity}).'**
  String productInquiryInStock(Object name, Object weight, Object purity);

  /// No description provided for @productInquiryNotify.
  ///
  /// In en, this message translates to:
  /// **'Hello Gulab Jewellers, please notify me when {name} ({weight}, {purity}) is available again.'**
  String productInquiryNotify(Object name, Object weight, Object purity);

  /// No description provided for @visitOurShowroom.
  ///
  /// In en, this message translates to:
  /// **'Visit Our Showroom'**
  String get visitOurShowroom;

  /// No description provided for @primary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// No description provided for @secondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get secondary;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @businessHours.
  ///
  /// In en, this message translates to:
  /// **'Business Hours'**
  String get businessHours;

  /// No description provided for @findUsOnMap.
  ///
  /// In en, this message translates to:
  /// **'Find Us On Map'**
  String get findUsOnMap;

  /// No description provided for @googleMapPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Google Map Preview Placeholder'**
  String get googleMapPlaceholder;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get paymentDetails;

  /// No description provided for @contactWhatsAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi Gulab Jewellers, I want to know more about your latest collection.'**
  String get contactWhatsAppMessage;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Shop'**
  String get aboutTitle;

  /// No description provided for @heritageOfTrust.
  ///
  /// In en, this message translates to:
  /// **'A Heritage of Trust'**
  String get heritageOfTrust;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Gulab Jewellers brings together timeless craftsmanship and modern taste in premium gold and silver jewellery. Every design is curated for elegance, purity, and family trust.'**
  String get aboutDescription;

  /// No description provided for @certifiedPurity.
  ///
  /// In en, this message translates to:
  /// **'Certified Purity'**
  String get certifiedPurity;

  /// No description provided for @certifiedPuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We prioritize hallmarked jewellery and transparent pricing every day.'**
  String get certifiedPuritySubtitle;

  /// No description provided for @exclusiveDesigns.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Designs'**
  String get exclusiveDesigns;

  /// No description provided for @exclusiveDesignsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'From bridal sets to daily wear, every collection is selected with finesse.'**
  String get exclusiveDesignsSubtitle;

  /// No description provided for @familyCentricService.
  ///
  /// In en, this message translates to:
  /// **'Family-Centric Service'**
  String get familyCentricService;

  /// No description provided for @familyCentricServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Warm guidance, honest recommendations, and personalized assistance.'**
  String get familyCentricServiceSubtitle;

  /// No description provided for @advanceBookingOnly.
  ///
  /// In en, this message translates to:
  /// **'For advance booking or token amount only'**
  String get advanceBookingOnly;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @accountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accountHolderName;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @ifscCode.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifscCode;

  /// No description provided for @upiId.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiId;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @qrPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'QR Placeholder'**
  String get qrPlaceholder;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'{label} copied to clipboard.'**
  String copiedToClipboard(Object label);

  /// No description provided for @offersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No active offers right now'**
  String get offersEmptyTitle;

  /// No description provided for @offersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check back soon for upcoming discounts.'**
  String get offersEmptySubtitle;

  /// No description provided for @knowMore.
  ///
  /// In en, this message translates to:
  /// **'Know More'**
  String get knowMore;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @notificationsMarkedRead.
  ///
  /// In en, this message translates to:
  /// **'{count} notifications marked as read.'**
  String notificationsMarkedRead(int count);

  /// No description provided for @markAll.
  ///
  /// In en, this message translates to:
  /// **'Mark all'**
  String get markAll;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Updates and offer alerts will appear here.'**
  String get notificationsEmptySubtitle;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(int hours);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgo(int days);

  /// No description provided for @designDescription.
  ///
  /// In en, this message translates to:
  /// **'Design Description'**
  String get designDescription;

  /// No description provided for @estimatedPrice.
  ///
  /// In en, this message translates to:
  /// **'Estimated Price'**
  String get estimatedPrice;

  /// No description provided for @priceEstimateDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Please note: This amount is an indicative estimate based on current metal rates. Final in-store billing may vary after applicable making charges and GST.'**
  String get priceEstimateDisclaimer;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get callUs;

  /// No description provided for @whatsappEnquiry.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Enquiry'**
  String get whatsappEnquiry;

  /// No description provided for @shareProduct.
  ///
  /// In en, this message translates to:
  /// **'Share Product'**
  String get shareProduct;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @productDetailsWhatsAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi, I would like details for {name} ({weight}).'**
  String productDetailsWhatsAppMessage(Object name, Object weight);

  /// No description provided for @rateCaptionSilver.
  ///
  /// In en, this message translates to:
  /// **'Based on today\'s Silver live rate (10g basis)'**
  String get rateCaptionSilver;

  /// No description provided for @rateCaptionGold24.
  ///
  /// In en, this message translates to:
  /// **'Based on today\'s Gold 24K live rate (10g basis)'**
  String get rateCaptionGold24;

  /// No description provided for @rateCaptionGold22.
  ///
  /// In en, this message translates to:
  /// **'Based on today\'s Gold 22K live rate (10g basis)'**
  String get rateCaptionGold22;

  /// No description provided for @shareProductText.
  ///
  /// In en, this message translates to:
  /// **'Check out {name} from Gulab Jewellers. Weight: {weight}, Purity: {purity}, Estimated price: {price}.'**
  String shareProductText(Object name, Object weight, Object purity, Object price);

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @soldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get soldOut;

  /// No description provided for @enquireNow.
  ///
  /// In en, this message translates to:
  /// **'Enquire Now'**
  String get enquireNow;

  /// No description provided for @notifyMe.
  ///
  /// In en, this message translates to:
  /// **'Notify Me'**
  String get notifyMe;

  /// No description provided for @liveRateTickerText.
  ///
  /// In en, this message translates to:
  /// **'Gold 22K: {gold22}   |   Gold 24K: {gold24}   |   Silver: {silver}   |   Updated Live Rates (10g)'**
  String liveRateTickerText(Object gold22, Object gold24, Object silver);

  /// No description provided for @todaysShopRate.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Shop Rate (10g)'**
  String get todaysShopRate;

  /// No description provided for @bestValuePricing.
  ///
  /// In en, this message translates to:
  /// **'Best value pricing for in-store purchase (10g basis).'**
  String get bestValuePricing;

  /// No description provided for @lastUpdatedUnknown.
  ///
  /// In en, this message translates to:
  /// **'Last updated: --'**
  String get lastUpdatedUnknown;

  /// No description provided for @lastUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String lastUpdatedAt(Object time);

  /// No description provided for @gold22k.
  ///
  /// In en, this message translates to:
  /// **'Gold 22K'**
  String get gold22k;

  /// No description provided for @gold24k.
  ///
  /// In en, this message translates to:
  /// **'Gold 24K'**
  String get gold24k;

  /// No description provided for @silver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get silver;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @filtersWithCount.
  ///
  /// In en, this message translates to:
  /// **'Filters ({count})'**
  String filtersWithCount(int count);

  /// No description provided for @closeFilters.
  ///
  /// In en, this message translates to:
  /// **'Close filters'**
  String get closeFilters;

  /// No description provided for @applyFiltersSortPref.
  ///
  /// In en, this message translates to:
  /// **'Apply filters and sorting preferences.'**
  String get applyFiltersSortPref;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get categoryGold;

  /// No description provided for @categorySilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get categorySilver;

  /// No description provided for @categoryRings.
  ///
  /// In en, this message translates to:
  /// **'Rings'**
  String get categoryRings;

  /// No description provided for @categoryNecklaces.
  ///
  /// In en, this message translates to:
  /// **'Necklaces'**
  String get categoryNecklaces;

  /// No description provided for @categoryBangles.
  ///
  /// In en, this message translates to:
  /// **'Bangles'**
  String get categoryBangles;

  /// No description provided for @categoryEarrings.
  ///
  /// In en, this message translates to:
  /// **'Earrings'**
  String get categoryEarrings;

  /// No description provided for @metalType.
  ///
  /// In en, this message translates to:
  /// **'Metal Type'**
  String get metalType;

  /// No description provided for @purity.
  ///
  /// In en, this message translates to:
  /// **'Purity'**
  String get purity;

  /// No description provided for @inStockOnly.
  ///
  /// In en, this message translates to:
  /// **'In Stock only'**
  String get inStockOnly;

  /// No description provided for @hideSoldOutProducts.
  ///
  /// In en, this message translates to:
  /// **'Hide sold out products'**
  String get hideSoldOutProducts;

  /// No description provided for @estimatedPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Estimated Price Range'**
  String get estimatedPriceRange;

  /// No description provided for @weightRange.
  ///
  /// In en, this message translates to:
  /// **'Weight Range'**
  String get weightRange;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @closeSortOptions.
  ///
  /// In en, this message translates to:
  /// **'Close sort options'**
  String get closeSortOptions;

  /// No description provided for @chooseSortArrangement.
  ///
  /// In en, this message translates to:
  /// **'Choose how products should be arranged.'**
  String get chooseSortArrangement;

  /// No description provided for @sortLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get sortLatest;

  /// No description provided for @sortPriceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceLowToHigh;

  /// No description provided for @sortPriceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceHighToLow;

  /// No description provided for @sortPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get sortPopular;

  /// No description provided for @discoverCollection.
  ///
  /// In en, this message translates to:
  /// **'Discover Our Collection'**
  String get discoverCollection;

  /// No description provided for @browseHandcraftedDesigns.
  ///
  /// In en, this message translates to:
  /// **'Browse handcrafted gold and silver jewellery designs.'**
  String get browseHandcraftedDesigns;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products, category, metal, purity...'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @searchPrefix.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchPrefix;

  /// No description provided for @categoryPrefix.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryPrefix;

  /// No description provided for @pricePrefix.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get pricePrefix;

  /// No description provided for @weightPrefix.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightPrefix;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @productsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} products found'**
  String productsFound(int count);

  /// No description provided for @noItemsForFilters.
  ///
  /// In en, this message translates to:
  /// **'No items found for these filters'**
  String get noItemsForFilters;

  /// No description provided for @noMatchingProducts.
  ///
  /// In en, this message translates to:
  /// **'No matching products found'**
  String get noMatchingProducts;

  /// No description provided for @tryLooseningFilters.
  ///
  /// In en, this message translates to:
  /// **'Try loosening filters, changing category, or adjusting price and weight ranges.'**
  String get tryLooseningFilters;

  /// No description provided for @tryDifferentCategory.
  ///
  /// In en, this message translates to:
  /// **'Try a different category to explore more designs.'**
  String get tryDifferentCategory;

  /// No description provided for @showAllCategories.
  ///
  /// In en, this message translates to:
  /// **'Show all categories'**
  String get showAllCategories;

  /// No description provided for @includeSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Include sold out'**
  String get includeSoldOut;

  /// No description provided for @clearMetalPurity.
  ///
  /// In en, this message translates to:
  /// **'Clear metal and purity'**
  String get clearMetalPurity;

  /// No description provided for @resetRanges.
  ///
  /// In en, this message translates to:
  /// **'Reset ranges'**
  String get resetRanges;

  /// No description provided for @resetAllCriteria.
  ///
  /// In en, this message translates to:
  /// **'Reset all criteria'**
  String get resetAllCriteria;

  /// No description provided for @loadingMoreProducts.
  ///
  /// In en, this message translates to:
  /// **'Loading more products...'**
  String get loadingMoreProducts;

  /// No description provided for @loadMoreProducts.
  ///
  /// In en, this message translates to:
  /// **'Load more products'**
  String get loadMoreProducts;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Timeless Gold & Silver Elegance'**
  String get splashTagline;

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
