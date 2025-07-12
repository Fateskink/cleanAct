import '../entities/auth_result.dart';

/// Repository interface for authentication
abstract class AuthRepository {
  Future<AuthResult> login({
    required String email,
    required String password,
  });

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthResult?> getCurrentUser();
  Future<void> logout();
  Future<bool> isLoggedIn();
}
