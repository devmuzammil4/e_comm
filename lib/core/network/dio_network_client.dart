import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import '../error/failure.dart';
import 'network_client.dart';

/// Concrete enterprise implementation of [NetworkClient] using optimized Dio.
/// Offloads heavy computational JSON processing to isolated threads to keep main UI thread at 60/120 FPS.
class DioNetworkClient implements NetworkClient {
  final Dio _dio;

  DioNetworkClient({required Dio dio}) : _dio = dio {
    _configureClient();
  }

  void _configureClient() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );
    // Add professional interceptors here (logging, token refresh, etc.)
  }

  @override
  Future<Either<Failure, T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic> json) mapper,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return await _parseResponse(response, mapper);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, T>> post<T>({
    required String path,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic> json) mapper,
  }) async {
    try {
      final response = await _dio.post(path, data: body);
      return await _parseResponse(response, mapper);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// High-performance background thread structural JSON parsing block.
  Future<Either<Failure, T>> _parseResponse<T>(
      Response response,
      T Function(Map<String, dynamic> json) mapper,
      ) async {
    if (response.data == null) {
      return const Left(TypeParsingFailure(message: "Server returned an empty response body."));
    }
    try {
      // Computes parsing inside an isolate on mobile/desktop to eliminate UI thread frame drops.
      // Falls back gracefully to primary thread automatically on Web (CanvasKit).
      final T parsedData = await compute(mapper, response.data as Map<String, dynamic>);
      return Right(parsedData);
    } catch (e) {
      return Left(TypeParsingFailure(message: "JSON Structural Mapping Exception: ${e.toString()}"));
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          message: "Network request timed out. Please check your data connection.",
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        return ServerFailure(
          message: "Server responded with an invalid error code: $code",
          statusCode: code,
        );
      case DioExceptionType.connectionError:
        return const ServerFailure(message: "No internet connection detected. Operating in offline fallback mode.");
      default:
        return UnknownFailure(message: error.message ?? "Unexpected internal client pipeline failure.");
    }
  }
}
