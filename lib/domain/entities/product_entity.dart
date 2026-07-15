class ProductEntity {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final double? rating; // Naye products ke liye rating null ho sakti hai taake app crash na ho
  final int stockCount;
  final bool isAvailable;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.rating, // Rating required nahi hai, default null accept kare ga
    required this.stockCount,
    required this.isAvailable,
  });

  // Business Rule: Check karna ke product khatam to nahi ho gaya
  bool get isOutOfStock => stockCount <= 0 || !isAvailable;

  // Business Rule: Check karna ke kya product free shipping ke kabil hai
  bool get qualifiesForFreeShipping => price > 500.0;

  // Business Rule: Check karna ke kya product high discount ke kabil hai
  bool get hasDiscountPotential => rating != null && rating! >= 4.5;

  // Performance Optimization: Do objects ko memory address ke bajaye un ke asli data se compare karna
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title &&
              price == other.price &&
              stockCount == other.stockCount;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ price.hashCode ^ stockCount.hashCode;
}
