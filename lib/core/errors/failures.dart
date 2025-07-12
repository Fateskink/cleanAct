import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Server related failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

/// Network connection failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Network connection error',
    super.code,
  });
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Cache failures
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error',
    super.code,
  });
}

/// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Permission denied',
    super.code,
  });
}
