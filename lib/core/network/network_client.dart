import 'package:fpdart/fpdart.dart';
import '../error/failure.dart';

/// Strict Type-Safe Network Infrastructure Contract.
/// Yeh interface core layers ko third-party API clients (Dio/Http) se fully decouple karta hai.
abstract interface class NetworkClient {

  /// Executes a secure, compile-time typed GET request.
  /// [mapper] function incoming raw JSON map ko model object mein transform karti hai.
  Future<Either<Failure, T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic> json) mapper,
  });

  /// Executes a secure, compile-time typed POST request.
  Future<Either<Failure, T>> post<T>({
    required String path,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic> json) mapper,
  });
}
