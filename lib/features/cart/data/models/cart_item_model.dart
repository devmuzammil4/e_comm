import '../../../../core/config/app_config.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Data Layer representation of a Cart Line Item.
/// Implements robust bidirectional JSON mapping to shield domain rules from data format anomalies.
class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.productId,
    required super.title,
    required super.basePrice,
    required super.imageUrl,
    required super.quantity,
    required super.tenantType,
    required super.selectedAttributes,
  });

  /// Factory constructor to safely parse data maps coming from local persistent memory arrays.
  /// Features total null-safety checks to neutralize raw string conversion crashes.
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product_id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Corrupted Cart Item',
      basePrice: _parseToDouble(json['base_price']),
      imageUrl: json['image_url']?.toString() ?? '',
      quantity: json['quantity'] is num ? (json['quantity'] as num).toInt() : 1,
      tenantType: _parseTenantType(json['tenant_type']),
      selectedAttributes: json['selected_attributes'] is Map<String, dynamic>
          ? json['selected_attributes'] as Map<String, dynamic>
          : const {},
    );
  }

  /// Maps the analytical internal state values out into a structured standard JSON layout.
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'title': title,
      'base_price': basePrice,
      'image_url': imageUrl,
      'quantity': quantity,
      'tenant_type': tenantType.name,
      'selected_attributes': selectedAttributes,
    };
  }

  /// Helper factory to easily upgrade a pure structural [CartItemEntity] into an infrastructure model.
  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      productId: entity.productId,
      title: entity.title,
      basePrice: entity.basePrice,
      imageUrl: entity.imageUrl,
      quantity: entity.quantity,
      tenantType: entity.tenantType,
      selectedAttributes: entity.selectedAttributes,
    );
  }

  // ---------------------------------------------------------------------------
  // Low-Level Defensive Type Parsers (15+ Years Exp Protection)
  // ---------------------------------------------------------------------------

  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static BusinessTenantType _parseTenantType(dynamic value) {
    final String typeStr = value?.toString().toLowerCase() ?? '';
    switch (typeStr) {
      case 'sports':
        return BusinessTenantType.sports;
      case 'restaurant':
        return BusinessTenantType.restaurant;
      case 'marketing':
        return BusinessTenantType.marketing;
      default:
        return BusinessTenantType.sports;
    }
  }
}
