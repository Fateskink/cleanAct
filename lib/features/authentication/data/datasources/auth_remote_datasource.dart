import '../../../../core/network/api_client.dart';
import '../../../../core/entities/entity_factory.dart';
import '../models/authenticated_user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<AuthenticatedUserModel> login({
    required String email,
    required String password,
  });

  Future<AuthenticatedUserModel> register({
    required String name,
    required String email,
    required String password,
  });
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  const AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthenticatedUserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      '/api/v1/signin',
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return EntityFactory.createAuthenticatedUserFromApi(response.data);
    } else {
      throw Exception('Login failed: ${response.statusMessage}');
    }
  }

  @override
  Future<AuthenticatedUserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      '/api/v1/signup',
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return EntityFactory.createAuthenticatedUserFromApi(response.data);
    } else {
      throw Exception('Registration failed: ${response.statusMessage}');
    }
  }
}
