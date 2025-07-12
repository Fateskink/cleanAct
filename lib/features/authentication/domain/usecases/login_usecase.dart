import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  /// Execute login
  Future<AuthResult> call({
    required String email,
    required String password,
  }) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Validate password
    if (password.isEmpty || password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Call repository to perform login
    return await repository.login(
      email: email,
      password: password,
    );
  }

  /// Simple email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
