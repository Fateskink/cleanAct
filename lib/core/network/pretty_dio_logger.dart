import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';

/// Secure Dio logger that logs essential info without exposing sensitive data
class PrettyDioLogger extends Interceptor {
  final bool logHeaders;
  final bool logRequestBody;
  final bool logResponseBody;
  final bool logErrors;

  // Map to store request start times
  final Map<String, DateTime> _requestStartTimes = {};

  // Sensitive headers to mask
  static const _sensitiveHeaders = {
    'authorization',
    'x-api-key',
    'cookie',
    'set-cookie',
    'x-auth-token',
    'bearer',
  };

  // Sensitive fields to mask in request/response body
  static const _sensitiveFields = {
    'password',
    'token',
    'access_token',
    'refresh_token',
    'secret',
    'key',
    'authorization',
    'credential',
    'pin',
    'otp',
  };

  PrettyDioLogger({
    this.logHeaders = false, // Disable by default to avoid leaking sensitive headers
    this.logRequestBody = false, // Disable by default to avoid leaking passwords
    this.logResponseBody = false, // Disable by default to avoid leaking tokens
    this.logErrors = true, // Keep errors for debugging
  });

    @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Generate unique request ID and timestamp
    final requestId = _generateRequestId();
    final timestamp = DateTime.now();

    // Store request start time
    _requestStartTimes[requestId] = timestamp;

    // Add request ID to headers for tracking
    options.headers['X-Request-ID'] = requestId;

    print('\n');
    print('🚀 === API REQUEST ===');
    print('🆔 ID: $requestId');
    print('🕐 Time: ${_formatTimestamp(timestamp)}');
    print('📍 ${options.method} ${_sanitizeUrl(options.uri.toString())}');
    print('📏 Content-Length: ${_getContentLength(options.data)}');

    if (logHeaders && options.headers.isNotEmpty) {
      print('📋 Headers:');
      options.headers.forEach((key, value) {
        final maskedValue = _maskSensitiveHeader(key, value.toString());
        print('   $key: $maskedValue');
      });
    }

    if (logRequestBody && options.data != null) {
      print('📦 Request Body:');
      _printSanitizedJson(options.data);
    }

    print('🚀 === END REQUEST ===\n');
    super.onRequest(options, handler);
  }

    @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestId = response.requestOptions.headers['X-Request-ID'] as String?;
    final endTime = DateTime.now();
    final duration = requestId != null && _requestStartTimes.containsKey(requestId)
        ? endTime.difference(_requestStartTimes[requestId]!)
        : null;

    print('\n');
    print('✅ === API RESPONSE ===');
    if (requestId != null) {
      print('🆔 ID: $requestId');
    }
    print('🕐 Time: ${_formatTimestamp(endTime)}');
    if (duration != null) {
      final durationMs = duration.inMilliseconds;
      print('⏱️ Duration: ${durationMs}ms ${_getPerformanceIndicator(durationMs)}');
      // Clean up stored start time
      _requestStartTimes.remove(requestId);
    }
    print('📍 ${response.requestOptions.method} ${_sanitizeUrl(response.requestOptions.uri.toString())}');
    print('📊 Status: ${response.statusCode} ${response.statusMessage}');
    print('📏 Response Size: ${_getResponseSize(response.data)}');

    if (logHeaders && response.headers.map.isNotEmpty) {
      print('📋 Response Headers:');
      response.headers.map.forEach((key, value) {
        final maskedValue = _maskSensitiveHeader(key, value.join(', '));
        print('   $key: $maskedValue');
      });
    }

    if (logResponseBody && response.data != null) {
      print('📦 Response Body:');
      _printSanitizedJson(response.data);
    } else {
      print('📦 Response: [HIDDEN FOR SECURITY]');
    }

    print('✅ === END RESPONSE ===\n');
    super.onResponse(response, handler);
  }

    @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logErrors) {
      final requestId = err.requestOptions.headers['X-Request-ID'] as String?;
      final errorTime = DateTime.now();
      final duration = requestId != null && _requestStartTimes.containsKey(requestId)
          ? errorTime.difference(_requestStartTimes[requestId]!)
          : null;

      print('\n');
      print('❌ === API ERROR ===');
      if (requestId != null) {
        print('🆔 ID: $requestId');
      }
      print('🕐 Time: ${_formatTimestamp(errorTime)}');
      if (duration != null) {
        print('⏱️ Duration: ${duration.inMilliseconds}ms');
        // Clean up stored start time
        _requestStartTimes.remove(requestId);
      }
      print('📍 ${err.requestOptions.method} ${_sanitizeUrl(err.requestOptions.uri.toString())}');
      print('💥 Type: ${err.type.name}');
      print('📝 Message: ${_sanitizeErrorMessage(err.message)}');

      if (err.response != null) {
        print('📊 Status: ${err.response?.statusCode} ${err.response?.statusMessage}');
        if (err.response?.data != null) {
          print('📦 Error Response:');
          _printSanitizedJson(err.response?.data);
        }
      }

      print('❌ === END ERROR ===\n');
    }
    super.onError(err, handler);
  }

    /// Generate unique request ID with timestamp and random component
  String _generateRequestId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999).toString().padLeft(6, '0');
    return 'req_${timestamp}_$random';
  }

  /// Format timestamp for display
  String _formatTimestamp(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}:'
           '${dateTime.second.toString().padLeft(2, '0')}.'
           '${dateTime.millisecond.toString().padLeft(3, '0')}';
  }

    /// Sanitize URL to remove query parameters that might contain sensitive data
  String _sanitizeUrl(String url) {
    final uri = Uri.parse(url);
    return '${uri.scheme}://${uri.host}:${uri.port}${uri.path}';
  }

  /// Mask sensitive headers
  String _maskSensitiveHeader(String key, String value) {
    if (_sensitiveHeaders.contains(key.toLowerCase())) {
      return '[MASKED]';
    }
    return value;
  }

  /// Sanitize error message to remove sensitive info
  String? _sanitizeErrorMessage(String? message) {
    if (message == null) return null;
    // Remove potential sensitive data from error messages
    return message.replaceAll(RegExp(r'password=\w+', caseSensitive: false), 'password=[MASKED]')
                  .replaceAll(RegExp(r'token=\w+', caseSensitive: false), 'token=[MASKED]');
  }

  /// Get content length for logging
  String _getContentLength(dynamic data) {
    if (data == null) return '0 bytes';
    try {
      final jsonString = jsonEncode(data);
      return '${jsonString.length} bytes';
    } catch (e) {
      return 'unknown';
    }
  }

  /// Get response size for logging
  String _getResponseSize(dynamic data) {
    if (data == null) return '0 bytes';
    try {
      final jsonString = jsonEncode(data);
      final sizeBytes = jsonString.length;
      if (sizeBytes < 1024) {
        return '$sizeBytes bytes';
      } else if (sizeBytes < 1024 * 1024) {
        return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
      } else {
        return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
    } catch (e) {
      return 'unknown';
    }
  }

  /// Get performance indicator emoji
  String _getPerformanceIndicator(int milliseconds) {
    if (milliseconds < 100) return '🚀'; // Very fast
    if (milliseconds < 500) return '⚡'; // Fast
    if (milliseconds < 1000) return '🐌'; // Slow
    if (milliseconds < 3000) return '🐢'; // Very slow
    return '💀'; // Extremely slow
  }

  /// Print sanitized JSON (mask sensitive fields)
  void _printSanitizedJson(dynamic data) {
    try {
      final sanitized = _sanitizeData(data);
      String prettyJson;

      if (sanitized is String) {
        try {
          final parsed = jsonDecode(sanitized);
          prettyJson = JsonEncoder.withIndent('  ').convert(parsed);
        } catch (e) {
          prettyJson = sanitized;
        }
      } else {
        prettyJson = JsonEncoder.withIndent('  ').convert(sanitized);
      }

      final lines = prettyJson.split('\n');
      for (final line in lines) {
        print('   $line');
      }
    } catch (e) {
      print('   [JSON PARSE ERROR: ${e.toString()}]');
    }
  }

  /// Recursively sanitize data to mask sensitive fields
  dynamic _sanitizeData(dynamic data) {
    if (data is Map<String, dynamic>) {
      final sanitized = <String, dynamic>{};
      data.forEach((key, value) {
        if (_sensitiveFields.contains(key.toLowerCase())) {
          sanitized[key] = '[MASKED]';
        } else {
          sanitized[key] = _sanitizeData(value);
        }
      });
      return sanitized;
    } else if (data is List) {
      return data.map((item) => _sanitizeData(item)).toList();
    }
    return data;
  }
}
