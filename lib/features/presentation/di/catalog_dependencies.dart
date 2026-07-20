import 'package:e_comm/features/catalog/data/datasources/catalog_remote_data_source.dart';
import 'package:e_comm/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:e_comm/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:e_comm/features/catalog/domain/usecases/get_product_details.dart';
import 'package:e_comm/features/catalog/domain/usecases/get_products.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/network/network_client.dart';
import 'package:e_comm/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:e_comm/features/catalog/domain/repositories/catalog_repository.dart'; // Fixed: Correct Singular Model Import
import 'package:e_comm/features/catalog/domain/usecases/get_product_details.dart';
import 'package:e_comm/features/catalog/domain/usecases/get_products.dart';
import '../providers/catalog_provider.dart';

/// Segregated dependency injection subsystem registration for the Catalog Provider module.
void initCatalogDependencies(GetIt sl) {

  // ---------------------------------------------------------------------------
  // 1. Data Sources Architecture Registration
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<CatalogRemoteDataSource>(
        () => CatalogRemoteDataSourceImpl(networkClient: sl<NetworkClient>()),
  );

  // ---------------------------------------------------------------------------
  // 2. Repositories Operational Layer Registration
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<CatalogRepository>(
        () => CatalogRepositoryImpl(remoteDataSource: sl<CatalogRemoteDataSource>()),
  );

  // ---------------------------------------------------------------------------
  // 3. Domain Use Cases Business Engine Registration
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<GetProducts>(
        () => GetProducts(repository: sl<CatalogRepository>()),
  );

  sl.registerLazySingleton<GetProductDetails>(
        () => GetProductDetails(repository: sl<CatalogRepository>()),
  );

  // ---------------------------------------------------------------------------
  // 4. Provider State Registration (15+ Years Exp Architecture)
  // ---------------------------------------------------------------------------
  sl.registerFactory<CatalogProvider>(
        () => CatalogProvider(getProductsUseCase: sl<GetProducts>()),
  );
}
