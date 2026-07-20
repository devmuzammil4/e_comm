import 'package:equatable/equatable.dart';

/// Sealed class enforcing exhaustive compile-time checking for all system failures.
/// Is class ke zariye hum try-catch blocks ke runtime crashes ko compile-time par block karte hain.
sealed class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server, API, aur Network HTTP connections ke failures ke liye boundary handler.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Local Caching, SQLite/Isar database, ya file storage storage devices ke failures ke liye layer.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Backend configuration mismatch ya galat JSON response datatypes (Type Mismatch) ko safety net dene ke liye.
class TypeParsingFailure extends Failure {
  const TypeParsingFailure({required super.message});
}

/// Unhandled anomalies aur critical application state protection ke liye fallback structural boundary.
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
