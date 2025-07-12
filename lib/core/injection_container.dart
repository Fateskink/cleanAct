import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/app_constants.dart';
import 'network/api_client.dart';
import 'network/network_info.dart';
import 'network/pretty_dio_logger.dart';
import '../features/authentication/data/datasources/auth_local_datasource.dart';
import '../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../features/authentication/data/repositories/auth_repository_impl.dart';
import '../features/authentication/domain/repositories/auth_repository.dart';
import '../features/authentication/domain/usecases/login_usecase.dart';
import '../features/authentication/domain/usecases/logout_usecase.dart';

/// Service locator instance
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // Core
  await _initCore();

  // Features
  await _initFeatures();
}

/// Initialize core dependencies
Future<void> _initCore() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Dio HTTP client
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8080', // Use actual API base URL
      connectTimeout: const Duration(seconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(seconds: AppConstants.receiveTimeout),
      sendTimeout: const Duration(seconds: AppConstants.sendTimeout),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add secure logger interceptor
  dio.interceptors.add(
    PrettyDioLogger(
      logHeaders: false, // Hide headers to protect sensitive tokens
      logRequestBody: false, // Hide request body to protect passwords
      logResponseBody: false, // Hide response body to protect user data
      logErrors: true, // Keep error logging for debugging
    ),
  );

  sl.registerLazySingleton<Dio>(() => dio);

  // Network utilities
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));
}

/// Initialize feature dependencies
Future<void> _initFeatures() async {
  // Authentication feature dependencies
  _initAuthenticationFeature();
}

/// Initialize authentication feature dependencies
void _initAuthenticationFeature() {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
}
