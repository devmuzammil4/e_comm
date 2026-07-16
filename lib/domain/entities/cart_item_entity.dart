class CartItemEntity {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;

  CartItemEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1, // Shuru mein quantity hamesha 1 hogi
  });
}
