import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/manage_auth_usecase.dart';
import '../../domain/entities/user_entity.dart';

enum AuthStateStatus { initial, loading, authenticated, unauthenticated, error }

/// Enterprise State Architecture managing core authentication sessions and active user contexts.
/// Structured specifically for immediate frame execution speed on Web, Windows, and Mobile devices.
class AuthProvider extends ChangeNotifier {
  final ManageAuthUseCase _manageAuthUseCase;

  AuthProvider({required ManageAuthUseCase manageAuthUseCase})
      : _manageAuthUseCase = manageAuthUseCase;

  // Internal Immutable Cache State Elements
  AuthStateStatus _status = AuthStateStatus.initial;
  UserEntity? _currentUser;
  String _errorMessage = '';

  // Public Encapsulated Getters
  AuthStateStatus get status => _status;
  UserEntity? get currentUser => _currentUser;
  String get errorMessage => _errorMessage;

  /// High-speed automated startup hook to restore user sessions on engine boot.
  Future<void> checkExistingSession() async {
    _status = AuthStateStatus.loading;
    notifyListeners();

    final result = await _manageAuthUseCase.executeCheckSession();

    result.fold(
          (failure) {
        _status = AuthStateStatus.unauthenticated;
        _currentUser = null;
      },
          (user) {
        _status = AuthStateStatus.authenticated;
        _currentUser = user;
      },
    );

    notifyListeners();
  }

  /// Triggers standard credential login pipelines.
  Future<void> login(String email, String password) async {
    _status = AuthStateStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await _manageAuthUseCase.executeLogin(email: email, password: password);

    result.fold(
          (failure) {
        _status = AuthStateStatus.error;
        _errorMessage = failure.message;
      },
          (user) {
        _status = AuthStateStatus.authenticated;
        _currentUser = user;
      },
    );

    notifyListeners();
  }

  /// Triggers core profile registration mapping.
  Future<void> register(String email, String password, String displayName) async {
    _status = AuthStateStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await _manageAuthUseCase.executeRegister(
      email: email,
      password: password,
      displayName: displayName,
    );

    result.fold(
          (failure) {
        _status = AuthStateStatus.error;
        _errorMessage = failure.message;
      },
          (user) {
        _status = AuthStateStatus.authenticated;
        _currentUser = user;
      },
    );

    notifyListeners();
  }

  /// Flushes user credentials from local caches cleanly.
  Future<void> logOutUser() async {
    _status = AuthStateStatus.loading;
    notifyListeners();

    final result = await _manageAuthUseCase.executeLogout();

    result.fold(
          (failure) {
        _status = AuthStateStatus.error;
        _errorMessage = failure.message;
      },
          (_) {
        _status = AuthStateStatus.unauthenticated;
        _currentUser = null;
      },
    );

    notifyListeners();
  }
}

// -----------------------------------------------------------------------------
// 🚀 CONSOLIDATED DEPENDENCY INJECTION LAYER (15+ Years Exp Architecture)
// -----------------------------------------------------------------------------

/// Segregated dependency injection subsystem registration for the Authentication module.
void initAuthDependencies(GetIt sl) {
  // 1. Data Layer Infrastructure Registration
  sl.registerLazySingleton<AuthRepository>(
        () => const AuthRepositoryImpl(),
  );

  // 2. Domain Layer Use Case Business Engine Registration
  sl.registerLazySingleton<ManageAuthUseCase>(
        () => ManageAuthUseCase(repository: sl<AuthRepository>()),
  );

  // 3. Presentation Layer Provider State Registration
  sl.registerFactory<AuthProvider>(
        () => AuthProvider(manageAuthUseCase: sl<ManageAuthUseCase>()),
  );
}
