import 'package:equatable/equatable.dart';

import '../../../../core/entities/user.dart';

/// Authentication result containing user data
class AuthResult extends Equatable {
  final User user;
  final String message;

  const AuthResult({
    required this.user,
    this.message = 'Login successful',
  });

  @override
  List<Object?> get props => [user, message];
}
