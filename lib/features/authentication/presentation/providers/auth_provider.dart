import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/user.dart';
import '../../../../core/injection_container.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

/// Authentication state
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Authentication state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;

  AuthNotifier(this._loginUseCase, this._logoutUseCase, this._authRepository)
      : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    try {
      final authResult = await _authRepository.getCurrentUser();
      if (authResult != null) {
        state = state.copyWith(user: authResult.user);
      }
    } catch (e) {
      // User not logged in or error occurred
      state = state.copyWith(user: null);
    }
  }

  /// Login user
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResult = await _loginUseCase.call(
        email: email,
        password: password,
      );

      state = state.copyWith(
        user: authResult.user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Register user
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResult = await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );

      state = state.copyWith(
        user: authResult.user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _logoutUseCase.call();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow; // Re-throw to handle in UI
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Authentication provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(sl<LoginUseCase>(), sl<LogoutUseCase>(), sl<AuthRepository>());
});
