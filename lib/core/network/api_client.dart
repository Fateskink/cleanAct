import 'package:dio/dio.dart';

import '../errors/failures.dart';

/// API client for handling HTTP requests
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert to app failures
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Connection timeout');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error';

        if (statusCode == 401) {
          return AuthFailure(message: message, code: statusCode);
        } else if (statusCode == 403) {
          return PermissionFailure(message: message, code: statusCode);
        } else if (statusCode! >= 400 && statusCode < 500) {
          return ValidationFailure(message: message, code: statusCode);
        } else {
          return ServerFailure(message: message, code: statusCode);
        }

      case DioExceptionType.connectionError:
        return const NetworkFailure(message: 'No internet connection');

      case DioExceptionType.cancel:
        return const ServerFailure(message: 'Request cancelled');

      default:
        return ServerFailure(message: error.message ?? 'Unknown error');
    }
  }
}
