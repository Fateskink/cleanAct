import 'package:equatable/equatable.dart';

import 'authenticated_user.dart';

/// Authentication result containing user data
/// Uses AuthenticatedUser instead of full User entity for better performance
class AuthResult extends Equatable {
  final AuthenticatedUser user;
  final String message;

  const AuthResult({
    required this.user,
    this.message = 'Login successful',
  });

  @override
  List<Object?> get props => [user, message];
}
