import 'package:equatable/equatable.dart';
import '../../../../core/config/app_config.dart';

/// Pure Domain Entity representing an item inside the universal cart engine.
/// Fully decoupled from local database storage structures and framework mechanics.
class CartItemEntity extends Equatable {
  final String productId;
  final String title;
  final double basePrice;
  final String imageUrl;
  final int quantity;
  final BusinessTenantType tenantType;

  /// Selected variant metadata (e.g., size, color, restaurant addons, bulk tier configs)
  final Map<String, dynamic> selectedAttributes;

  const CartItemEntity({
    required this.productId,
    required this.title,
    required this.basePrice,
    required this.imageUrl,
    required this.quantity,
    required this.tenantType,
    required this.selectedAttributes,
  });

  /// Generates a mathematically unique identifier for line items inside the cart array.
  /// This prevents collisions when the same product is added with different options
  /// (e.g., One Large Pizza with extra cheese vs One Large Pizza with no cheese).
  String get uniqueCartItemId {
    final String attributeHash = selectedAttributes.entries
        .map((e) => '${e.key}:${e.value}')
        .join('-');
    return '${productId}_$attributeHash';
  }

  /// Enterprise Pricing Strategy Logic (15+ Years Exp Architecture)
  /// Calculates the true single unit price dynamically based on cross-industry business rules.
  double get unitPrice {
    switch (tenantType) {
      case BusinessTenantType.restaurant:
        return basePrice + _calculateRestaurantAddonsCost();
      case BusinessTenantType.marketing:
        return basePrice * _calculateMarketingBulkDiscountFactor();
      case BusinessTenantType.sports:
        return basePrice; // Sports sizes/colors typically retain standard baseline rates
    }
  }

  /// Calculates total accumulated cost for this specific cart row configuration.
  double get totalLinePrice => unitPrice * quantity;

  double _calculateRestaurantAddonsCost() {
    if (!selectedAttributes.containsKey('selected_addons')) return 0.0;
    try {
      final List<dynamic> addons = selectedAttributes['selected_addons'] as List<dynamic>;
      return addons.fold(0.0, (sum, addon) {
        final price = addon['price'];
        return sum + (price is num ? price.toDouble() : 0.0);
      });
    } catch (_) {
      return 0.0; // Fail-safe production baseline fallback
    }
  }

  double _calculateMarketingBulkDiscountFactor() {
    // Business logic placeholder: drops unit price by 15% if tier quantity threshold exceeds 500 units
    if (quantity >= 500) return 0.85;
    if (quantity >= 100) return 0.90;
    return 1.0;
  }

  /// Utility structural mapping method for immutable modifications.
  CartItemEntity copyWith({
    int? quantity,
    Map<String, dynamic>? selectedAttributes,
  }) {
    return CartItemEntity(
      productId: productId,
      title: title,
      basePrice: basePrice,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
      tenantType: tenantType,
      selectedAttributes: selectedAttributes ?? this.selectedAttributes,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    title,
    basePrice,
    imageUrl,
    quantity,
    tenantType,
    selectedAttributes,
  ];
}
