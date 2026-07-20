import '../../../../core/config/app_config.dart';
import '../../../../core/error/failure.dart'; // Enforced absolute type safety import
import '../../../../core/network/network_client.dart';
import '../models/product_model.dart';

/// Abstract contract enforcing strict structural isolation for external remote network requests.
abstract interface class CatalogRemoteDataSource {
  Future<List<ProductModel>> fetchProducts(BusinessTenantType tenantType);
  Future<ProductModel> fetchProductDetails(String productId);
}

/// Concrete implementation utilizing our high-performance type-safe abstract network client.
class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final NetworkClient _networkClient;

  CatalogRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  @override
  Future<List<ProductModel>> fetchProducts(BusinessTenantType tenantType) async {
    final String targetPath = '/v1/${tenantType.name}/products';

    final result = await _networkClient.get<List<ProductModel>>(
      path: targetPath,
      mapper: (json) {
        final List<dynamic> dataList = json['data'] as List<dynamic>;
        return dataList.map((item) => ProductModel.fromJson(item as Map<String, dynamic>)).toList();
      },
    );

    // Fixed: Explicitly typed '(Failure failure)' inside fold map block to activate type visibility
    return result.fold(
          (Failure failure) => throw Exception(failure.message),
          (List<ProductModel> modelsList) => modelsList,
    );
  }

  @override
  Future<ProductModel> fetchProductDetails(String productId) async {
    final result = await _networkClient.get<ProductModel>(
      path: '/v1/products/$productId',
      mapper: (json) => ProductModel.fromJson(json['data'] as Map<String, dynamic>),
    );

    // Fixed: Explicitly typed '(Failure failure)' inside fold map block to activate type visibility
    return result.fold(
          (Failure failure) => throw Exception(failure.message),
          (ProductModel model) => model,
    );
  }
}
