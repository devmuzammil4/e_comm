import 'package:fpdart/fpdart.dart';
import '../../../../core/config/app_config.dart';
import 'package:e_comm/core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/catalog_repository.dart';

/// Enterprise domain interactor engineered to fetch contextual catalogs.
/// Extends the strict base [UseCase] contract to guarantee error-safe output boundaries.
class GetProducts implements UseCase<List<ProductEntity>, BusinessTenantType> {
  final CatalogRepository _repository;

  GetProducts({required CatalogRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(BusinessTenantType params) async {
    // Executes pure domain tracking operations without tight presentation framework dependencies
    return await _repository.getProducts(params);
  }
}
