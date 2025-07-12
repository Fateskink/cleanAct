import '../../../../core/entities/user_base.dart';
import '../../../../core/entities/user.dart'; // Import existing entities

/// User entity specific to Profile feature
/// Contains comprehensive user data including relations
class ProfileUser extends UserBase {
  final Subscription? subscription;
  final PresignedLicense? presignedLicense;
  final String? avatarUrl;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? bio;
  final Map<String, dynamic>? preferences;

  const ProfileUser({
    required String id,
    required DateTime createdAt,
    DateTime? updatedAt,
    required String email,
    required String name,
    required UserRole role,
    this.subscription,
    this.presignedLicense,
    this.avatarUrl,
    this.phoneNumber,
    this.dateOfBirth,
    this.bio,
    this.preferences,
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
        subscription,
        presignedLicense,
        avatarUrl,
        phoneNumber,
        dateOfBirth,
        bio,
        preferences,
      ];

  /// Convert to base User entity (for backward compatibility)
  User toUser() {
    return User(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      email: email,
      name: name,
      role: role,
      subscription: subscription,
      presignedLicense: presignedLicense,
    );
  }

  @override
  String toString() {
    return 'ProfileUser(id: $id, email: $email, name: $name, role: $role, hasSubscription: ${subscription != null})';
  }
}
