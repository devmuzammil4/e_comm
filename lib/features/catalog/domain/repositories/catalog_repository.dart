import 'package:fpdart/fpdart.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/error/failure.dart';
import '../entities/product_entity.dart';

/// Abstract Data Access Interface defining system requirements for Catalog features.
/// Completely decoupled from cloud databases, API clients, or local caching mechanisms.
abstract interface class CatalogRepository {

  /// Fetches an immutable collection of products scoped by the active tenant context.
  /// Enforces compile-time type safety via the functional [Either] wrapper framework.
  Future<Either<Failure, List<ProductEntity>>> getProducts(BusinessTenantType tenantType);

  /// Fetches precise matching structural detail profile definitions for a specific item identifier.
  Future<Either<Failure, ProductEntity>> getProductDetails(String productId);
}
