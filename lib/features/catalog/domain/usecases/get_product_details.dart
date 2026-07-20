import 'package:fpdart/fpdart.dart';
import 'package:e_comm/core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/catalog_repository.dart';

/// Single item details retriever interactor.
/// Fully encapsulated logic protecting unique analytical queries across Web/Desktop engines.
class GetProductDetails implements UseCase<ProductEntity, String> {
  final CatalogRepository _repository;

  GetProductDetails({required CatalogRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, ProductEntity>> call(String params) async {
    // Pure identifier routing parameter tracking pipeline boundary
    return await _repository.getProductDetails(params);
  }
}
