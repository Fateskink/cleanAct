import '../repositories/auth_repository.dart';

/// Use case for user logout
class LogoutUseCase {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  /// Execute logout
  Future<void> call() async {
    // Call repository to perform logout
    await repository.logout();
  }
}
