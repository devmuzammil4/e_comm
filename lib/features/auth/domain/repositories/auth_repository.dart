import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';

/// Abstract Data Access Interface defining system structural parameters for Authentication.
/// Fully decoupled from third-party login SDKs, network engines, or storage clients.
abstract interface class AuthRepository {

  /// Authenticates a Nike/Adidas tier sports brand user profile via email credentials.
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  /// Registers a brand new corporate profile matrix into the central cloud data stream.
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Automatically scans local hardware encrypted caches to recover existing sessions.
  Future<Either<Failure, UserEntity>> checkAutoLoginSession();

  /// Synchronizes cache operations to safely clear tokens and invalidate user states.
  Future<Either<Failure, void>> logout();
}
