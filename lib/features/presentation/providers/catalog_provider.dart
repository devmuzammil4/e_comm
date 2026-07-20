import 'package:flutter/foundation.dart';
import '../../../../core/config/app_config.dart';
import 'package:e_comm/features/catalog/domain/entities/product_entity.dart';
import 'package:e_comm/features/catalog/domain/usecases/get_products.dart';

enum CatalogStatus { initial, loading, loaded, error }

/// Enterprise State Architecture using optimized Provider pattern.
/// Decoupled from core layout mechanics to ensure fast execution speeds on Web & Desktop.
class CatalogProvider extends ChangeNotifier {
  final GetProducts _getProductsUseCase;

  CatalogProvider({required GetProducts getProductsUseCase})
      : _getProductsUseCase = getProductsUseCase;

  // Internal Backing Fields protecting state contamination
  CatalogStatus _status = CatalogStatus.initial;
  List<ProductEntity> _products = const [];
  String _errorMessage = '';

  // Public Encapsulated Getters
  CatalogStatus get status => _status;
  List<ProductEntity> get products => _products;
  String get errorMessage => _errorMessage;

  /// High-performance contextual tracking function to update state reactivity.
  Future<void> loadCatalog(BusinessTenantType tenantType) async {
    _status = CatalogStatus.loading;
    _errorMessage = '';
    notifyListeners();

    // Invokes the pure domain usecase interactor asynchronously
    final result = await _getProductsUseCase(tenantType);

    result.fold(
          (failure) {
        _status = CatalogStatus.error;
        _errorMessage = failure.message;
      },
          (successProductsList) {
        _status = CatalogStatus.loaded;
        _products = successProductsList;
      },
    );

    notifyListeners();
  }
}
