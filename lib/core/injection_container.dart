import 'package:get_it/get_it.dart';
import 'package:e_comm/data/models/product_remote.dart';
import 'package:e_comm/data/repositories/product_repository_impl.dart';
import 'package:e_comm/domain/repository/product_repositories.dart';

// sl ka matlab hai Service Locator (Store-room)
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Product

  // 1. Remote Data Source ko register kiya (Interface ko implementation se map kiya)
  // 💡 YAHAAN TABDEELI HAI: <ProductRemoteDataSource> ka type lagaya hai
  sl.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(),
  );

  // 2. Repository ko register kiya aur us mien Data Source ko automatic inject karwaya
  sl.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  //! Core Layers (Future mien Internet Check/Network Info yahan aayega)

  //! External (Future mien http/dio client ya SharedPreferences yahan aayenge)
}