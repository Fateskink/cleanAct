import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      // Check network connectivity
      if (!await networkInfo.isConnected) {
        throw const NetworkFailure();
      }

      // Call remote API
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Cache user data locally
      await localDataSource.cacheUser(userModel);

      // userModel is already an AuthenticatedUser since it extends it
      return AuthResult(
        user: userModel,
        message: 'Login successful',
      );
    } on NetworkFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Check network connectivity
      if (!await networkInfo.isConnected) {
        throw const NetworkFailure();
      }

      // Call remote API
      final userModel = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );

      // Cache user data locally
      await localDataSource.cacheUser(userModel);

      // userModel is already an AuthenticatedUser since it extends it
      return AuthResult(
        user: userModel,
        message: 'Registration successful',
      );
    } on NetworkFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  @override
  Future<AuthResult?> getCurrentUser() async {
    try {
      // Try to get cached user
      final userModel = await localDataSource.getCachedUser();

      if (userModel != null) {
        // userModel is already an AuthenticatedUser since it extends it
        return AuthResult(
          user: userModel,
          message: 'User loaded from cache',
        );
      }

      return null;
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Clear local cache
      await localDataSource.clearCache();
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await localDataSource.isUserCached();
    } catch (e) {
      return false;
    }
  }
}
