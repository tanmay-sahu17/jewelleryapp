class Product {
  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.weight,
    required this.description,
    required this.category,
    required this.metalType,
    required this.purity,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double weight;
  final String description;
  final String category;
  final String metalType;
  final String purity;
  final bool isFeatured;

  String get weightLabel => '${weight.toStringAsFixed(1)}g';
}
