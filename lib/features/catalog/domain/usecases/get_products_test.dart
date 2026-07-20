// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:e_comm/core/config/app_config.dart';
import 'package:e_comm/core/error/failure.dart';
import 'package:e_comm/features/catalog/domain/entities/product_entity.dart';
import 'package:e_comm/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:e_comm/features/catalog/domain/usecases/get_products.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {
  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts(BusinessTenantType? tenantType) async {
    return super.noSuchMethod(
      Invocation.method(#getProducts, [tenantType]),
      returnValue: Future.value(Right<Failure, List<ProductEntity>>([])),
      returnValueForMissingStub: Future.value(Right<Failure, List<ProductEntity>>([])),
    ) as Future<Either<Failure, List<ProductEntity>>>;
  }
}

void main() {
  late GetProducts useCase;
  late MockCatalogRepository mockCatalogRepository;

  setUp(() {
    mockCatalogRepository = MockCatalogRepository();
    useCase = GetProducts(repository: mockCatalogRepository);
  });

  const tTenantType = BusinessTenantType.sports;
  final tProductsList = [
    const ProductEntity(
      id: "prod_001",
      title: "Pro Football Boots",
      description: "Aerodynamic cleats",
      basePrice: 120.00,
      imageUrl: "https://assets.com",
      tenantType: BusinessTenantType.sports,
      attributes: {},
    )
  ];

  test(
    'should fetch premium product lists cleanly from the repository contract boundary passing valid parameters',
        () async {
      when(mockCatalogRepository.getProducts(any))
          .thenAnswer((_) async => Right(tProductsList));

      final result = await useCase(tTenantType);

      expect(result, Right(tProductsList));
      verify(mockCatalogRepository.getProducts(tTenantType));
      verifyNoMoreInteractions(mockCatalogRepository);
    },
  );

  test(
    'should capture structural network faults and return matching Failure instances from the operation channel',
        () async {
      const tFailure = ServerFailure(message: "Internal Infrastructure Sync Failure", statusCode: 500);
      when(mockCatalogRepository.getProducts(any))
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(tTenantType);

      expect(result, const Left(tFailure));
      verify(mockCatalogRepository.getProducts(tTenantType));
      verifyNoMoreInteractions(mockCatalogRepository);
    },
  );
}
