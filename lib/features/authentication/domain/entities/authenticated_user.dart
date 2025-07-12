import '../../../../core/entities/user_base.dart';
import '../../../../core/entities/user.dart'; // Import UserRole

/// User entity specific to Authentication feature
/// Contains only the data needed for authentication flows
class AuthenticatedUser extends UserBase {
  final bool isEmailVerified;
  final DateTime? lastLoginAt;

  const AuthenticatedUser({
    required String id,
    required DateTime createdAt,
    DateTime? updatedAt,
    required String email,
    required String name,
    required UserRole role,
    this.isEmailVerified = false,
    this.lastLoginAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          email: email,
          name: name,
          role: role,
        );

  @override
  List<Object?> get props => [
        ...super.props,
        isEmailVerified,
        lastLoginAt,
      ];

  @override
  String toString() {
    return 'AuthenticatedUser(id: $id, email: $email, name: $name, role: $role, isEmailVerified: $isEmailVerified)';
  }
}
