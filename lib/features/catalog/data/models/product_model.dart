import '../../../../core/config/app_config.dart';
import '../../domain/entities/product_entity.dart';

/// Data Layer representation of the product concept.
/// Implements parsing abstractions to isolate network schema definitions from pure domain models.
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.basePrice,
    required super.imageUrl,
    required super.tenantType,
    required super.attributes,
  });

  /// Robust Enterprise JSON Factory Constructor.
  /// Features deep runtime type protection logic to prevent common formatting crash vulnerabilities.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Product',
      description: json['description']?.toString() ?? '',
      basePrice: _parseToDouble(json['base_price']),
      imageUrl: json['image_url']?.toString() ?? '',
      tenantType: _parseTenantType(json['tenant_type']),
      attributes: json['attributes'] is Map<String, dynamic>
          ? json['attributes'] as Map<String, dynamic>
          : const {},
    );
  }

  /// Structural output format configuration mapping helper.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'base_price': basePrice,
      'image_url': imageUrl,
      'tenant_type': tenantType.name,
      'attributes': attributes,
    };
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
        return BusinessTenantType.sports; // Production safe default fallback
    }
  }
}
