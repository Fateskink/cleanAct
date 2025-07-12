import 'base_entity.dart';

/// User roles in the billiard ecosystem
enum UserRole {
  student('student'),
  instructor('instructor'),
  admin('admin');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.student,
    );
  }
}

/// Subscription information
class Subscription {
  final int id;
  final int userId;
  final String planName;
  final int maxInstances;
  final int usedInstances;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subscription({
    required this.id,
    required this.userId,
    required this.planName,
    required this.maxInstances,
    required this.usedInstances,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// Presigned License information
class PresignedLicense {
  final int id;
  final int licenseId;
  final int userId;
  final bool isActive;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PresignedLicense({
    required this.id,
    required this.licenseId,
    required this.userId,
    required this.isActive,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// Core User entity shared across all modules
class User extends BaseEntity {
  final String email;
  final String name;
  final UserRole role;
  final Subscription? subscription;
  final PresignedLicense? presignedLicense;

  const User({
    required String id,
    required DateTime createdAt,
    DateTime? updatedAt,
    required this.email,
    required this.name,
    this.role = UserRole.student,
    this.subscription,
    this.presignedLicense,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Check if user is instructor
  bool get isInstructor => role == UserRole.instructor;

  /// Check if user is student
  bool get isStudent => role == UserRole.student;

  /// Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user has active subscription
  bool get hasActiveSubscription => subscription?.isActive ?? false;

  /// Check if license is active
  bool get hasActiveLicense => presignedLicense?.isActive ?? false;

  /// Copy user with updated properties
  User copyWith({
    String? name,
    UserRole? role,
    Subscription? subscription,
    PresignedLicense? presignedLicense,
    DateTime? updatedAt,
  }) {
    return User(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      email: email,
      name: name ?? this.name,
      role: role ?? this.role,
      subscription: subscription ?? this.subscription,
      presignedLicense: presignedLicense ?? this.presignedLicense,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        email,
        name,
        role,
        subscription,
        presignedLicense,
      ];
}
