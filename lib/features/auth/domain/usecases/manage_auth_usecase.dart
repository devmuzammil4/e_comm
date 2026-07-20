import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Single unified interactor managing core business operations for the Auth module.
/// Fully insulated from state management notifications or third-party platform dependencies.
class ManageAuthUseCase {
  final AuthRepository _repository;

  ManageAuthUseCase({required AuthRepository repository}) : _repository = repository;

  /// Executes email validation login logic sequence.
  Future<Either<Failure, UserEntity>> executeLogin({
    required String email,
    required String password,
  }) async {
    return await _repository.loginWithEmail(email: email, password: password);
  }

  /// Executes email membership registration sequence.
  Future<Either<Failure, UserEntity>> executeRegister({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return await _repository.registerWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  /// Scans device hardware persistence keys to check for active sessions.
  Future<Either<Failure, UserEntity>> executeCheckSession() async {
    return await _repository.checkAutoLoginSession();
  }

  /// Invalidate authentication credentials across the core engine memory maps.
  Future<Either<Failure, void>> executeLogout() async {
    return await _repository.logout();
  }
}
