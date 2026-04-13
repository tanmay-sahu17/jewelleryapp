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

  static final List<Product> _baseProducts = <Product>[
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
      isInStock: false,
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
      isInStock: false,
    ),
    const Product(
      id: 'p11',
      name: 'Antique Meenakari Ring',
      imageUrl:
          'https://images.unsplash.com/photo-1603974372039-adc49044b6bd?auto=format&fit=crop&w=1200&q=80',
      weight: 4.8,
      description:
          'Traditional meenakari detailing with a rich antique polish for festive styling.',
      category: 'Rings',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p12',
      name: 'Floral Filigree Ring',
      imageUrl:
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=1200&q=80',
      weight: 3.6,
      description:
          'Lightweight silver filigree ring with floral-inspired openwork texture.',
      category: 'Rings',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p13',
      name: 'Lakshmi Haram Necklace',
      imageUrl:
          'https://images.unsplash.com/photo-1611652022419-a9419f74343d?auto=format&fit=crop&w=1200&q=80',
      weight: 42.0,
      description:
          'A majestic Lakshmi haram with handcrafted motifs for bridal occasions.',
      category: 'Necklaces',
      metalType: 'Gold',
      purity: '22K',
      isFeatured: true,
    ),
    const Product(
      id: 'p14',
      name: 'Daily Wear Gold Chain',
      imageUrl:
          'https://images.unsplash.com/photo-1622396636133-ba43f812bc35?auto=format&fit=crop&w=1200&q=80',
      weight: 12.8,
      description:
          'Simple premium chain designed for all-day comfort and a timeless look.',
      category: 'Necklaces',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p15',
      name: 'Silver Coin Pendant Chain',
      imageUrl:
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=1200&q=80',
      weight: 10.2,
      description:
          'Sterling silver chain paired with a coin pendant for ethnic fusion outfits.',
      category: 'Necklaces',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p16',
      name: 'Royal Kundan Bangles',
      imageUrl:
          'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=1200&q=80',
      weight: 26.7,
      description:
          'Kundan-accented bangle pair tailored for grand wedding ceremonies.',
      category: 'Bangles',
      metalType: 'Gold',
      purity: '22K',
      isFeatured: true,
    ),
    const Product(
      id: 'p17',
      name: 'Twisted Rope Silver Bangles',
      imageUrl:
          'https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?auto=format&fit=crop&w=1200&q=80',
      weight: 20.4,
      description:
          'Classic twisted-rope texture with hallmarked silver craftsmanship.',
      category: 'Bangles',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p18',
      name: 'Dual Tone Heritage Kada',
      imageUrl:
          'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=1200&q=80',
      weight: 22.1,
      description:
          'Dual-tone kada with carved borders, inspired by regal archival pieces.',
      category: 'Bangles',
      metalType: 'Gold',
      purity: '22K',
      isInStock: false,
    ),
    const Product(
      id: 'p19',
      name: 'Pearl Drop Studs',
      imageUrl:
          'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=1200&q=80',
      weight: 5.4,
      description:
          'Elegant pearl drop studs with refined gold framing for subtle glam.',
      category: 'Earrings',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p20',
      name: 'Silver Hoop Earrings',
      imageUrl:
          'https://images.unsplash.com/photo-1589128777073-263566ae5e4d?auto=format&fit=crop&w=1200&q=80',
      weight: 7.8,
      description:
          'Contemporary medium hoops in silver with balanced shine and profile.',
      category: 'Earrings',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p21',
      name: 'Chandbali Party Earrings',
      imageUrl:
          'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=1200&q=80',
      weight: 11.6,
      description:
          'Bold chandbali silhouette with layered detailing for occasion wear.',
      category: 'Earrings',
      metalType: 'Gold',
      purity: '22K',
      isInStock: false,
    ),
    const Product(
      id: 'p22',
      name: 'Textured Stack Rings',
      imageUrl:
          'https://images.unsplash.com/photo-1603974372039-adc49044b6bd?auto=format&fit=crop&w=1200&q=80',
      weight: 4.2,
      description:
          'Stack-friendly gold rings with mixed textures and modern contours.',
      category: 'Rings',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p23',
      name: 'Sterling Couple Bands',
      imageUrl:
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=1200&q=80',
      weight: 6.0,
      description:
          'Matching silver band pair crafted with comfort-fit inner finishing.',
      category: 'Rings',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p24',
      name: 'Heritage Mango Necklace',
      imageUrl:
          'https://images.unsplash.com/photo-1611652022419-a9419f74343d?auto=format&fit=crop&w=1200&q=80',
      weight: 36.9,
      description:
          'Mango motif necklace with deeply embossed detailing and rich volume.',
      category: 'Necklaces',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p25',
      name: 'Lightweight Sitahar',
      imageUrl:
          'https://images.unsplash.com/photo-1622396636133-ba43f812bc35?auto=format&fit=crop&w=1200&q=80',
      weight: 28.3,
      description:
          'Layered sitahar profile offering bridal richness with reduced weight.',
      category: 'Necklaces',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p26',
      name: 'Silver Bead Mala',
      imageUrl:
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=1200&q=80',
      weight: 18.1,
      description:
          'Beaded silver mala chain with polished separators and secure lock.',
      category: 'Necklaces',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p27',
      name: 'Temple Kada Pair',
      imageUrl:
          'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=1200&q=80',
      weight: 30.5,
      description:
          'Heavy temple kadas with deity motifs and high-detail outer rims.',
      category: 'Bangles',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p28',
      name: 'Leaf Motif Bangles',
      imageUrl:
          'https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?auto=format&fit=crop&w=1200&q=80',
      weight: 16.9,
      description:
          'Leaf-inspired bangle pair with fine cuts and bright mirror finish.',
      category: 'Bangles',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p29',
      name: 'Silver Cuff Bangles',
      imageUrl:
          'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=1200&q=80',
      weight: 19.6,
      description:
          'Open-ended cuff-style silver bangles with contemporary edge profile.',
      category: 'Bangles',
      metalType: 'Silver',
      purity: '925 Silver',
      isInStock: false,
    ),
    const Product(
      id: 'p30',
      name: 'Minimal Pearl Tops',
      imageUrl:
          'https://images.unsplash.com/photo-1589128777073-263566ae5e4d?auto=format&fit=crop&w=1200&q=80',
      weight: 4.9,
      description:
          'Compact pearl top earrings suited for office, brunch, and gifting.',
      category: 'Earrings',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p31',
      name: 'Antique Bell Jhumki',
      imageUrl:
          'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=1200&q=80',
      weight: 8.7,
      description:
          'Bell-shaped jhumki pair featuring antique brush finish highlights.',
      category: 'Earrings',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p32',
      name: 'Oxidised Silver Danglers',
      imageUrl:
          'https://images.unsplash.com/photo-1589128777073-263566ae5e4d?auto=format&fit=crop&w=1200&q=80',
      weight: 9.1,
      description:
          'Oxidised finish danglers with boho styling and clean articulation.',
      category: 'Earrings',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p33',
      name: 'Princess Cut Ring',
      imageUrl:
          'https://images.unsplash.com/photo-1543294001-f7cd5d7fb516?auto=format&fit=crop&w=1200&q=80',
      weight: 5.9,
      description:
          'Premium gold ring with princess-cut centerpiece and smooth shank.',
      category: 'Rings',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p34',
      name: 'Engraved Name Ring',
      imageUrl:
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=1200&q=80',
      weight: 3.9,
      description:
          'Personalized silver ring with precision engraving and matte texture.',
      category: 'Rings',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p35',
      name: 'Heritage Bridal Set',
      imageUrl:
          'https://images.unsplash.com/photo-1611652022419-a9419f74343d?auto=format&fit=crop&w=1200&q=80',
      weight: 54.6,
      description:
          'Grand bridal necklace set designed with layered heritage-inspired work.',
      category: 'Necklaces',
      metalType: 'Gold',
      purity: '22K',
      isFeatured: true,
    ),
    const Product(
      id: 'p36',
      name: 'Layered Silver Chain',
      imageUrl:
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=1200&q=80',
      weight: 22.4,
      description:
          'Dual-layer silver chain profile with polished links and premium clasp.',
      category: 'Necklaces',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p37',
      name: 'Broad Cuff Kada',
      imageUrl:
          'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=1200&q=80',
      weight: 27.2,
      description:
          'Broad silver cuff kada with bold shape and handcrafted inner comfort.',
      category: 'Bangles',
      metalType: 'Silver',
      purity: '925 Silver',
    ),
    const Product(
      id: 'p38',
      name: 'Daily Wear Gold Bangles',
      imageUrl:
          'https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?auto=format&fit=crop&w=1200&q=80',
      weight: 14.8,
      description:
          'Everyday gold bangles with slim profile and durable polished finish.',
      category: 'Bangles',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p39',
      name: 'Sunburst Stud Earrings',
      imageUrl:
          'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=1200&q=80',
      weight: 5.1,
      description:
          'Sunburst-inspired stud earrings with radiant carved petal geometry.',
      category: 'Earrings',
      metalType: 'Gold',
      purity: '22K',
    ),
    const Product(
      id: 'p40',
      name: 'Stone Accent Ring',
      imageUrl:
          'https://images.unsplash.com/photo-1543294001-f7cd5d7fb516?auto=format&fit=crop&w=1200&q=80',
      weight: 6.6,
      description:
          'Signature ring with centered stone accent and sculpted gold frame.',
      category: 'Rings',
      metalType: 'Gold',
      purity: '22K',
      isInStock: false,
    ),
  ];

  static final List<Product> products = _baseProducts
      .map(_withLocalizedProductContent)
      .toList(growable: false);

  // New products can be added in _baseProducts with only English content.
  // If Hindi content is available, add it in the maps below using the same product id.
  static Product _withLocalizedProductContent(Product product) {
    final String? nameHi = _productNamesHi[product.id];
    final String? descriptionHi = _productDescriptionsHi[product.id];

    if (nameHi == null && descriptionHi == null) {
      return product;
    }

    return product.copyWith(
      localizedNames: nameHi == null
          ? product.localizedNames
          : <String, String>{
              ...product.localizedNames,
              'hi': nameHi,
            },
      localizedDescriptions: descriptionHi == null
          ? product.localizedDescriptions
          : <String, String>{
              ...product.localizedDescriptions,
              'hi': descriptionHi,
            },
    );
  }

  static const Map<String, String> _productNamesHi = <String, String>{
    'p1': 'राजवाड़ी गोल्ड रिंग',
    'p2': 'टेम्पल नेकलेस सेट',
    'p3': 'क्लासिक सिल्वर कड़ा',
    'p4': 'पीकॉक झुमका',
    'p5': 'मिनिमल सिल्वर रिंग',
    'p6': 'ब्राइडल चोकर गोल्ड',
    'p7': 'वेव पैटर्न बंग्ल्स',
    'p8': 'सिल्वर ड्रॉप इयररिंग्स',
    'p9': 'नवरत्न गोल्ड रिंग',
    'p10': 'स्टर्लिंग सिल्वर चेन',
    'p11': 'एंटीक मीनाकारी रिंग',
    'p12': 'फ्लोरल फिलिग्री रिंग',
    'p13': 'लक्ष्मी हारम नेकलेस',
    'p14': 'डेली वियर गोल्ड चेन',
    'p15': 'सिल्वर कॉइन पेंडेंट चेन',
    'p16': 'रॉयल कुंदन बंग्ल्स',
    'p17': 'ट्विस्टेड रोप सिल्वर बंग्ल्स',
    'p18': 'ड्यूल टोन हेरिटेज कड़ा',
    'p19': 'पर्ल ड्रॉप स्टड्स',
    'p20': 'सिल्वर हूप इयररिंग्स',
    'p21': 'चांदबाली पार्टी इयररिंग्स',
    'p22': 'टेक्सचर्ड स्टैक रिंग्स',
    'p23': 'स्टर्लिंग कपल बैंड्स',
    'p24': 'हेरिटेज मैंगो नेकलेस',
    'p25': 'लाइटवेट सिताहार',
    'p26': 'सिल्वर बीड माला',
    'p27': 'टेम्पल कड़ा पेयर',
    'p28': 'लीफ मोटिफ बंग्ल्स',
    'p29': 'सिल्वर कफ बंग्ल्स',
    'p30': 'मिनिमल पर्ल टॉप्स',
    'p31': 'एंटीक बेल झुमकी',
    'p32': 'ऑक्सिडाइज्ड सिल्वर डैंगलर्स',
    'p33': 'प्रिंसेस कट रिंग',
    'p34': 'एनग्रेव्ड नेम रिंग',
    'p35': 'हेरिटेज ब्राइडल सेट',
    'p36': 'लेयर्ड सिल्वर चेन',
    'p37': 'ब्रॉड कफ कड़ा',
    'p38': 'डेली वियर गोल्ड बंग्ल्स',
    'p39': 'सनबर्स्ट स्टड इयररिंग्स',
    'p40': 'स्टोन एक्सेंट रिंग',
  };

  static const Map<String, String> _productDescriptionsHi = <String, String>{
    'p1': 'शादी और त्योहारों के लिए हाई-पॉलिश फिनिश के साथ जटिल फ्लोरल डिज़ाइन।',
    'p2': 'प्रीमियम पारंपरिक लुक के लिए शानदार टेम्पल-स्टाइल नेकलेस।',
    'p3': 'हॉलमार्क सिल्वर में साफ किनारों वाला मजबूत हस्तनिर्मित कड़ा।',
    'p4': 'एंटीक फिनिश और मोर मोटिफ वाले स्टेटमेंट झुमके।',
    'p5': 'मैट और पॉलिश ब्लेंड के साथ रोज़ाना पहनने योग्य सुंदर सिल्वर रिंग।',
    'p6': 'प्रीमियम हैंड-कार्व्ड टेक्सचर वाला लेयर्ड ब्राइडल चोकर।',
    'p7': 'मॉडर्न वेव टेक्सचर और हल्के आराम वाली बंगल्स की जोड़ी।',
    'p8': 'ऑफिस और कैज़ुअल शाम के लिए समकालीन सिल्वर ड्रॉप्स।',
    'p9': 'राजसी विरासत से प्रेरित प्रीमियम नवरत्न रिंग।',
    'p10': 'प्रीमियम क्लैप्स और मिरर पॉलिश के साथ यूनिसेक्स सिल्वर चेन।',
    'p11': 'त्योहारी स्टाइल के लिए समृद्ध एंटीक पॉलिश के साथ पारंपरिक मीनाकारी।',
    'p12': 'फ्लोरल ओपनवर्क टेक्सचर वाली हल्की सिल्वर फिलिग्री रिंग।',
    'p13': 'ब्राइडल मौकों के लिए हस्तनिर्मित मोटिफ वाला भव्य लक्ष्मी हारम।',
    'p14': 'पूरा दिन आराम और कालातीत लुक के लिए सिंपल प्रीमियम चेन।',
    'p15': 'एथनिक फ्यूजन आउटफिट्स के लिए कॉइन पेंडेंट के साथ स्टर्लिंग चेन।',
    'p16': 'शानदार शादी समारोहों के लिए तैयार कुंदन एक्सेंट वाली बंगल्स की जोड़ी।',
    'p17': 'हॉलमार्क सिल्वर कारीगरी के साथ क्लासिक ट्विस्टेड-रोप टेक्सचर।',
    'p18': 'राजसी आर्काइवल डिज़ाइन से प्रेरित नक्काशीदार बॉर्डर वाला ड्यूल-टोन कड़ा।',
    'p19': 'सटल ग्लैम के लिए परिष्कृत गोल्ड फ्रेमिंग वाले एलिगेंट पर्ल स्टड्स।',
    'p20': 'संतुलित चमक और प्रोफाइल वाले आधुनिक मीडियम सिल्वर हूप्स।',
    'p21': 'ओकेजन वियर के लिए लेयर्ड डिटेलिंग वाली बोल्ड चांदबाली डिज़ाइन।',
    'p22': 'मिक्स टेक्सचर और मॉडर्न कंटूर वाली स्टैक-फ्रेंडली गोल्ड रिंग्स।',
    'p23': 'कंफर्ट-फिट फिनिश के साथ मैचिंग सिल्वर बैंड्स की जोड़ी।',
    'p24': 'गहरे एम्बॉस्ड डिटेलिंग वाला मैंगो मोटिफ नेकलेस।',
    'p25': 'कम वजन में ब्राइडल रिचनेस देने वाला लेयर्ड सिताहार प्रोफाइल।',
    'p26': 'पॉलिश्ड सेपरेटर और सुरक्षित लॉक वाली बीडेड सिल्वर माला चेन।',
    'p27': 'देवी-देवता मोटिफ और हाई-डिटेल रिम्स वाले भारी टेम्पल कड़े।',
    'p28': 'फाइन कट्स और चमकदार फिनिश वाली लीफ-इंस्पायर्ड बंगल्स की जोड़ी।',
    'p29': 'कॉन्टेम्पररी प्रोफाइल वाली ओपन-एंडेड कफ-स्टाइल सिल्वर बंगल्स।',
    'p30': 'ऑफिस, ब्रंच और गिफ्टिंग के लिए उपयुक्त कॉम्पैक्ट पर्ल टॉप्स।',
    'p31': 'एंटीक ब्रश फिनिश हाइलाइट्स वाली बेल-शेप झुमकी की जोड़ी।',
    'p32': 'बोहो स्टाइल और साफ आर्टिकुलेशन वाले ऑक्सिडाइज्ड डैंगलर्स।',
    'p33': 'प्रिंसेस-कट सेंटरपीस और स्मूद शैंक वाली प्रीमियम गोल्ड रिंग।',
    'p34': 'प्रिसिशन एनग्रेविंग और मैट टेक्सचर वाली पर्सनलाइज्ड सिल्वर रिंग।',
    'p35': 'लेयर्ड हेरिटेज-इंस्पायर्ड कारीगरी वाला भव्य ब्राइडल नेकलेस सेट।',
    'p36': 'पॉलिश्ड लिंक्स और प्रीमियम क्लैप्स के साथ ड्यूल-लेयर सिल्वर चेन।',
    'p37': 'बोल्ड शेप और हस्तनिर्मित आराम वाली चौड़ी सिल्वर कफ कड़ा डिज़ाइन।',
    'p38': 'स्लिम प्रोफाइल और टिकाऊ पॉलिश फिनिश वाली रोज़ाना गोल्ड बंगल्स।',
    'p39': 'रेडिएंट पंखुड़ी पैटर्न वाले सनबर्स्ट-इंस्पायर्ड स्टड इयररिंग्स।',
    'p40': 'सेंटर स्टोन एक्सेंट और स्कल्प्टेड गोल्ड फ्रेम वाली सिग्नेचर रिंग।',
  };

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
