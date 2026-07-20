import 'package:equatable/equatable.dart';

/// Supported business archetypes inside our white-label engine.
enum BusinessTenantType { sports, restaurant, marketing }

/// Supported transaction pathways tailored for each business flow.
enum CheckoutStrategyType { standardShipping, instantDelivery, leadGeneration }

/// Enterprise Configuration Matrix Class.
/// This configuration object controls dynamic features, theme rules,
/// and behavioral settings across all platforms without code modifications.
class AppConfig extends Equatable {
  final String appTitle;
  final String tenantId;
  final BusinessTenantType tenantType;
  final CheckoutStrategyType checkoutStrategy;

  // Feature Flag Toggles to instantly control code path executions
  final bool enableInventoryTracking;
  final bool enableAddonConfiguration;
  final bool enableBulkDiscounts;
  final bool allowsGuestCheckout;

  const AppConfig({
    required this.appTitle,
    required this.tenantId,
    required this.tenantType,
    required this.checkoutStrategy,
    required this.enableInventoryTracking,
    required this.enableAddonConfiguration,
    required this.enableBulkDiscounts,
    required this.allowsGuestCheckout,
  });

  /// Factory configuration explicitly calibrated for the Sports App environment.
  factory AppConfig.sportsBrand() {
    return const AppConfig(
      appTitle: "Apex Sports Wear",
      tenantId: "tenant_sports_001",
      tenantType: BusinessTenantType.sports,
      checkoutStrategy: CheckoutStrategyType.standardShipping,
      enableInventoryTracking: true,    // Real-time stocks for shoes/shirts
      enableAddonConfiguration: false,  // Sports doesn't use meal add-ons
      enableBulkDiscounts: false,
      allowsGuestCheckout: true,
    );
  }

  /// Factory configuration explicitly calibrated for the Restaurant App environment.
  factory AppConfig.restaurantBrand() {
    return const AppConfig(
      appTitle: "Bistro Express",
      tenantId: "tenant_food_002",
      tenantType: BusinessTenantType.restaurant,
      checkoutStrategy: CheckoutStrategyType.instantDelivery,
      enableInventoryTracking: false,   // Kitchens cook on-demand
      enableAddonConfiguration: true,   // Extra cheese, fries, spice-levels
      enableBulkDiscounts: false,
      allowsGuestCheckout: true,
    );
  }

  /// Factory configuration explicitly calibrated for B2B/Marketing Products environment.
  factory AppConfig.marketingBrand() {
    return const AppConfig(
      appTitle: "Corporate Promo Nexus",
      tenantId: "tenant_marketing_003",
      tenantType: BusinessTenantType.marketing,
      checkoutStrategy: CheckoutStrategyType.leadGeneration,
      enableInventoryTracking: false,
      enableAddonConfiguration: false,
      enableBulkDiscounts: true,        // Custom tiers for mass print orders
      allowsGuestCheckout: false,       // Requires registered account for B2B quotes
    );
  }

  @override
  List<Object?> get props => [
    appTitle,
    tenantId,
    tenantType,
    checkoutStrategy,
    enableInventoryTracking,
    enableAddonConfiguration,
    enableBulkDiscounts,
    allowsGuestCheckout,
  ];
}
