class ShopOffer {
  const ShopOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.validUntil,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final String validUntil;
  final String imageUrl;
}
