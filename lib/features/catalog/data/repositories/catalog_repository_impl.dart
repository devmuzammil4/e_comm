import 'package:e_comm/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_remote_data_source.dart';

/// Concrete Enterprise Data Coordination Layer.
/// Intercepts low-level runtime engine exceptions and transforms them into strict compile-time types.
class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource _remoteDataSource;

  CatalogRepositoryImpl({required CatalogRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts(BusinessTenantType tenantType) async {
    try {
      // High-speed memory execution mapping from raw data model down to domain entities array
      final remoteProducts = await _remoteDataSource.fetchProducts(tenantType);
      return Right(remoteProducts);
    } catch (error) {
      return Left(ServerFailure(
        message: "Failed to load multi-tenant catalogs cleanly: ${error.toString()}",
      ));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductDetails(String productId) async {
    try {
      final remoteProductDetails = await _remoteDataSource.fetchProductDetails(productId);
      return Right(remoteProductDetails);
    } catch (error) {
      return Left(ServerFailure(
        message: "Unable to retrieve standalone matching item structures: ${error.toString()}",
      ));
    }
  }
}
