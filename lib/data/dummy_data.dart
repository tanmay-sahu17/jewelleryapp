import '../models/offer_model.dart';
import '../models/product_model.dart';

class ShopInfo {
  const ShopInfo({
    required this.name,
    required this.address,
    required this.primaryPhone,
    required this.secondaryPhone,
    required this.whatsapp,
    required this.email,
    required this.businessHours,
  });

  final String name;
  final String address;
  final String primaryPhone;
  final String secondaryPhone;
  final String whatsapp;
  final String email;
  final Map<String, String> businessHours;
}

class BankDetails {
  const BankDetails({
    required this.bankName,
    required this.accountHolder,
    required this.accountNumber,
    required this.ifscCode,
    required this.upiId,
  });

  final String bankName;
  final String accountHolder;
  final String accountNumber;
  final String ifscCode;
  final String upiId;
}

class DummyData {
  static const List<String> categories = <String>[
    'All',
    'Gold',
    'Silver',
    'Rings',
    'Necklaces',
    'Bangles',
    'Earrings',
  ];

  static const Map<String, double> liveRates = <String, double>{
    'Gold22K': 68500,
    'Gold24K': 74700,
    'Silver': 890,
  };

  static const Map<String, double> shopRates = <String, double>{
    'Gold22K': 68250,
    'Gold24K': 74400,
    'Silver': 870,
  };

  static final List<Product> products = <Product>[
    const Product(
      id: 'p1',
      name: 'Rajwadi Gold Ring',
      imageUrl:
          'https://images.unsplash.com/photo-1603974372039-adc49044b6bd?auto=format&fit=crop&w=1200&q=80',
      weight: 5.2,
      description:
          'Intricate floral motifs with a high-polish finish for wedding and festive wear.',
      category: 'Rings',
      metalType: 'Gold',
      purity: '22K',
      isFeatured: true,
    ),
    const Product(
      id: 'p2',
      name: 'Temple Necklace Set',
      imageUrl:
          'https://images.unsplash.com/photo-1611652022419-a9419f74343d?auto=format&fit=crop&w=1200&q=80',
      weight: 38.5,
      description:
          'Grand temple-style necklace crafted for premium traditional looks.',
      category: 'Necklaces',
      metalType: 'Gold',
      purity: '22K',
      isFeatured: true,
    ),
    const Product(
      id: 'p3',
      name: 'Classic Silver Kada',
      imageUrl:
          'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=1200&q=80',
      weight: 24.0,
      description:
          'Solid handcrafted kada in hallmarked silver with clean contour edges.',
      category: 'Bangles',
      metalType: 'Silver',
      purity: '925 Silver',
      isFeatured: true,
    ),
    const Product(
      id: 'p4',
      name: 'Peacock Jhumka',
      imageUrl:
          'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=1200&q=80',
      weight: 9.3,
      description:
          'Statement jhumkas with peacock emboss detailing and antique finish.',
      category: 'Earrings',
      metalType: 'Gold',
      purity: '22K',
      isFeatured: true,
    ),
    const Product(
      id: 'p5',
      name: 'Minimal Silver Ring',
      imageUrl:
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=1200&q=80',
      weight: 3.1,
      description:
          'Elegant everyday silver ring with smooth matte-polish blend.',
      category: 'Rings',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p6',
      name: 'Bridal Choker Gold',
      imageUrl:
          'https://images.unsplash.com/photo-1622396636133-ba43f812bc35?auto=format&fit=crop&w=1200&q=80',
      weight: 31.8,
      description:
          'Layered bridal choker with premium hand-carved gold textures.',
      category: 'Necklaces',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p7',
      name: 'Wave Pattern Bangles',
      imageUrl:
          'https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?auto=format&fit=crop&w=1200&q=80',
      weight: 18.4,
      description:
          'Pair of bangles featuring modern wave textures and lightweight comfort.',
      category: 'Bangles',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p8',
      name: 'Silver Drop Earrings',
      imageUrl:
          'https://images.unsplash.com/photo-1589128777073-263566ae5e4d?auto=format&fit=crop&w=1200&q=80',
      weight: 6.7,
      description:
          'Contemporary silver drops designed for office and casual evenings.',
      category: 'Earrings',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p9',
      name: 'Navratna Gold Ring',
      imageUrl:
          'https://images.unsplash.com/photo-1543294001-f7cd5d7fb516?auto=format&fit=crop&w=1200&q=80',
      weight: 6.4,
      description: 'Premium navratna ring inspired by heritage royal artistry.',
      category: 'Rings',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p10',
      name: 'Sterling Silver Chain',
      imageUrl:
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=1200&q=80',
      weight: 14.6,
      description:
          'Unisex sterling chain with a premium clasp and mirror polish.',
      category: 'Necklaces',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
  ];

  static final List<ShopOffer> offers = <ShopOffer>[
    const ShopOffer(
      id: 'o1',
      title: 'Making Charges Off on Bangles',
      description:
          'Enjoy 0% making charges on selected gold bangles this month.',
      validUntil: 'Valid till 30 Apr 2026',
      imageUrl:
          'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=1400&q=80',
    ),
    const ShopOffer(
      id: 'o2',
      title: 'Exchange Old Gold',
      description:
          'Bring your old jewellery and get instant value upgrade on new designs.',
      validUntil: 'Valid till 15 May 2026',
      imageUrl:
          'https://images.unsplash.com/photo-1603974372039-adc49044b6bd?auto=format&fit=crop&w=1400&q=80',
    ),
    const ShopOffer(
      id: 'o3',
      title: 'Festival Discount 5%',
      description:
          'Flat 5% discount on diamond-studded collections and premium sets.',
      validUntil: 'Valid till 10 Jun 2026',
      imageUrl:
          'https://images.unsplash.com/photo-1621961458348-f013d219b50c?auto=format&fit=crop&w=1400&q=80',
    ),
    const ShopOffer(
      id: 'o4',
      title: 'Silver Saturday',
      description:
          'Special weekend rates on hallmarked silver jewellery and pooja articles.',
      validUntil: 'Every Saturday',
      imageUrl:
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=1400&q=80',
    ),
  ];

  static const ShopInfo shopInfo = ShopInfo(
    name: 'Gulab Jewellers',
    address:
      'Sadar Bazar, Bhatapara, Dist - Bhatapara-Balodabazar, 493118',
    primaryPhone: '+91 62659 20397',
    secondaryPhone: '+91 62659 20397',
    whatsapp: '+91 62659 20397',
    email: 'info@shrijewellers.in',
    businessHours: <String, String>{
      'Monday': '10:00 AM - 8:30 PM',
      'Tuesday': '10:00 AM - 8:30 PM',
      'Wednesday': '10:00 AM - 8:30 PM',
      'Thursday': '10:00 AM - 8:30 PM',
      'Friday': '10:00 AM - 9:00 PM',
      'Saturday': '10:00 AM - 9:00 PM',
      'Sunday': '11:00 AM - 6:00 PM',
    },
  );

  static const BankDetails bankDetails = BankDetails(
    bankName: 'HDFC Bank',
    accountHolder: 'Gulab Jewellers LLP',
    accountNumber: '50200012345678',
    ifscCode: 'HDFC0000456',
    upiId: 'shrijewellers@hdfcbank',
  );
}
