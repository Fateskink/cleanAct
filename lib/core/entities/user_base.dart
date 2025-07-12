import 'base_entity.dart';
import 'user.dart'; // Import UserRole from user.dart

/// Base User entity with only essential fields shared across all features
/// This follows the Interface Segregation Principle
class UserBase extends BaseEntity {
  final String email;
  final String name;
  final UserRole role;

  const UserBase({
    required String id,
    required DateTime createdAt,
    DateTime? updatedAt,
    required this.email,
    required this.name,
    this.role = UserRole.student,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        role,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'UserBase(id: $id, email: $email, name: $name, role: $role)';
  }
}
