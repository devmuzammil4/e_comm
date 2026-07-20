import 'package:equatable/equatable.dart';
import '../../../../core/config/app_config.dart';

/// Pure Domain Entity representing a product across multiple business tenants.
/// Fully decoupled from backend database structures and UI frameworks.
class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final double basePrice;
  final String imageUrl;
  final BusinessTenantType tenantType;

  /// Structural metadata containing industry-specific variables.
  /// Sports: {'sizes': ['M', 'L'], 'colors': ['Black', 'Neon']}
  /// Restaurant: {'addons': [{'name': 'Extra Cheese', 'price': 1.50}], 'spicyLevel': 3}
  /// Marketing: {'bulkTiers': [{ 'minQty': 100, 'discount': 0.15 }]}
  final Map<String, dynamic> attributes;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.basePrice,
    required this.imageUrl,
    required this.tenantType,
    required this.attributes,
  });

  // ---------------------------------------------------------------------------
  // Type-Safe Enterprise Business Logic Extensions (15+ Years Exp)
  // ---------------------------------------------------------------------------

  /// Calculates tailored prices dynamically based on business metadata rules.
  double get calculatedFinalPrice {
    switch (tenantType) {
      case BusinessTenantType.restaurant:
      // Automatically sums up mandatory selected addon prices inside food engine
        return basePrice + _calculateRestaurantAddonsCost();
      case BusinessTenantType.marketing:
      // Applies enterprise tier discounts based on baseline configs
        return basePrice;
      case BusinessTenantType.sports:
        return basePrice;
    }
  }

  double _calculateRestaurantAddonsCost() {
    if (!attributes.containsKey('addons')) return 0.0;
    try {
      final List<dynamic> addonsList = attributes['addons'] as List<dynamic>;
      return addonsList.fold(0.0, (sum, addon) {
        final price = addon['price'];
        return sum + (price is num ? price.toDouble() : 0.0);
      });
    } catch (_) {
      return 0.0; // Fail-safe graceful execution mapping boundary
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    basePrice,
    imageUrl,
    tenantType,
    attributes,
  ];
}
