import 'package:get_it/get_it.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/manage_cart_usecase.dart';
import '../providers/catalog_cart_provider.dart'; // Safely targets our File 6 setup

/// Segregated dependency injection subsystem registration for the Cart module.
/// Decoupling component initializations into isolated functional blocks eliminates framework overhead.
void initCartDependencies(GetIt sl) {

  // ---------------------------------------------------------------------------
  // 1. Data Layer Infrastructure Registration
  // ---------------------------------------------------------------------------
  // Registers the abstract repository blueprint mapped onto its concrete storage engine
  sl.registerLazySingleton<CartRepository>(
        () => const CartRepositoryImpl(),
  );

  // ---------------------------------------------------------------------------
  // 2. Domain Layer Use Case Business Engine Registration
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<ManageCartUseCase>(
        () => ManageCartUseCase(repository: sl<CartRepository>()),
  );

  // ---------------------------------------------------------------------------
  // 3. Presentation Layer Provider State Registration (15+ Years Exp Architecture)
  // ---------------------------------------------------------------------------
  // Factory scope allocation ensures that every module invocation instantiates a clean memory stack
  sl.registerFactory<CartProvider>(
        () => CartProvider(manageCartUseCase: sl<ManageCartUseCase>()),
  );
}
