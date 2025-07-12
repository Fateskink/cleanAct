import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
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
  Future<UserModel> login({
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
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Login failed: ${response.statusMessage}');
    }
  }

  @override
  Future<UserModel> register({
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
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Registration failed: ${response.statusMessage}');
    }
  }
}
