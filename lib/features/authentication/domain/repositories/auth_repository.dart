import '../../../../core/errors/failures.dart';
import '../entities/auth_result.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Login with email and password
  Future<AuthResult> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  });

  /// Get current logged in user
  Future<AuthResult?> getCurrentUser();

  /// Logout current user
  Future<void> logout();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}
