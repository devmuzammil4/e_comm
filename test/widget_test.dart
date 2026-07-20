import 'package:flutter_test/flutter_test.dart';
import 'package:e_comm/main.dart';
import 'package:e_comm/core/config/app_config.dart';
import 'package:e_comm/core/di/injection_container.dart';
import 'package:e_comm/features/presentation/di/catalog_dependencies.dart';
import 'package:e_comm/features/presentation/pages/product_catalog_page.dart';

void main() {
  testWidgets('App Shell Core Boot Integration Test', (WidgetTester tester) async {
    // 1. Initializing isolated testing boundaries for dependency maps prior to view attachment
    if (sl.isRegistered<AppConfig>()) await sl.reset();

    // Setting up clear default runtime flavor settings matching your core profile definitions
    await initializeDependencies(BusinessTenantType.sports);
    initCatalogDependencies(sl);

    // 2. Boots the actual multi-tenant framework window tree into the simulator canvas
    await tester.pumpWidget(const MultiTenantAppCoreShell());

    // 3. Verifies that the primary adaptive shell loaded the target view template correctly
    expect(find.byType(ProductCatalogPage), findsOneWidget);
  });
}
