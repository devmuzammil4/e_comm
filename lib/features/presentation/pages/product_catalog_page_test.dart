// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:e_comm/core/config/app_config.dart';
import 'package:e_comm/core/error/failure.dart'; // Fixed: Added missing explicit failures import
import 'package:e_comm/core/di/injection_container.dart';
import 'package:e_comm/features/catalog/domain/entities/product_entity.dart';
import 'package:e_comm/features/catalog/domain/usecases/get_products.dart';
import 'package:e_comm/features/presentation/pages/product_catalog_page.dart'; // Fixed: Corrected absolute folder directory path
import 'package:e_comm/features/presentation/providers/catalog_provider.dart'; // Fixed: Corrected absolute folder directory path

class MockGetProducts extends Mock implements GetProducts {
  @override
  Future<Either<ServerFailure, List<ProductEntity>>> call(BusinessTenantType? params) async {
    return super.noSuchMethod(
      Invocation.method(#call, [params]),
      returnValue: Future.value(const Right<ServerFailure, List<ProductEntity>>([])),
      returnValueForMissingStub: Future.value(const Right<ServerFailure, List<ProductEntity>>([])),
    ) as Future<Either<ServerFailure, List<ProductEntity>>>;
  }
}

void main() {
  late MockGetProducts mockGetProducts;
  late CatalogProvider testCatalogProvider;

  setUpAll(() async {
    if (sl.isRegistered<AppConfig>()) await sl.reset();
    sl.registerSingleton<AppConfig>(AppConfig.sportsBrand());
  });

  setUp(() {
    mockGetProducts = MockGetProducts();
    testCatalogProvider = CatalogProvider(getProductsUseCase: mockGetProducts);

    if (sl.isRegistered<CatalogProvider>()) sl.unregister<CatalogProvider>();
    sl.registerFactory<CatalogProvider>(() => testCatalogProvider);
  });

  final tProducts = [
    const ProductEntity(
      id: "test_001",
      title: "Alpha Running Shoes",
      description: "Responsive race shoes",
      basePrice: 150.0,
      imageUrl: "",
      tenantType: BusinessTenantType.sports,
      attributes: {},
    )
  ];

  Widget makeTestableWidget() {
    return const MaterialApp(
      home: ProductCatalogPage(),
    );
  }

  testWidgets(
    'should display CircularProgressIndicator when state tracking status is loading',
        (WidgetTester tester) async {
      when(mockGetProducts(any)).thenAnswer((_) async => const Right([]));

      await tester.pumpWidget(makeTestableWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should render structural custom grid elements accurately when data load finishes successfully',
        (WidgetTester tester) async {
      when(mockGetProducts(any)).thenAnswer((_) async => Right(tProducts));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text("Alpha Running Shoes"), findsOneWidget);
      expect(find.text("\$150.00"), findsOneWidget);
    },
  );
}
