import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../config/app_config.dart';
import '../network/dio_network_client.dart';
import '../network/network_client.dart';

/// Global access point for memory isolated dependencies.
/// Zero lookups on the widget tree ensures consistent frame rendering speeds on Web & Desktop.
final GetIt sl = GetIt.instance;

/// Core Orchestration Lifecycle Bootstrapper.
/// [tenantType] accepts the initial build target flavor (sports, restaurant, marketing).
Future<void> initializeDependencies(BusinessTenantType tenantType) async {

  // ---------------------------------------------------------------------------
  // 1. Dynamic Config Lifecycle Scope Setup
  // ---------------------------------------------------------------------------
  if (sl.isRegistered<AppConfig>()) {
    await sl.reset(); // Pure memory cleanup protection during runtime brand switches
  }

  // Registering explicitly calibrated system configuration matrix
  final AppConfig runtimeConfig = _buildTargetConfiguration(tenantType);
  sl.registerSingleton<AppConfig>(runtimeConfig);

  // ---------------------------------------------------------------------------
  // 2. Base Network Infrastructure Registration
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton<NetworkClient>(
        () => DioNetworkClient(dio: sl<Dio>()),
  );

  // ---------------------------------------------------------------------------
  // 3. Dynamic Application Sub-systems Allocation
  // ---------------------------------------------------------------------------
  // Future extensions (Auth, Catalog, Cart repositories) will lock onto 'sl' allocations here.
}

/// Runtime configuration engine parser mapping tenant profiles.
AppConfig _buildTargetConfiguration(BusinessTenantType type) {
  switch (type) {
    case BusinessTenantType.sports:
      return AppConfig.sportsBrand();
    case BusinessTenantType.restaurant:
      return AppConfig.restaurantBrand();
    case BusinessTenantType.marketing:
      return AppConfig.marketingBrand();
  }
}
