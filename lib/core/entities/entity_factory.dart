import 'user_base.dart';
import 'user.dart';
import '../utils/date_helper.dart';
import '../../features/authentication/data/models/authenticated_user_model.dart';

/// Factory for creating entities from different data sources
/// This centralizes entity creation logic and reduces duplication
class EntityFactory {
  /// Create UserBase from API response (minimal data)
  static UserBase createUserBaseFromApi(Map<String, dynamic> json) {
    return UserBase(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String,
      createdAt: DateHelper.parseApiDate(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateHelper.parseApiDate(json['updatedAt'] as String)
          : null,
      role: _determineUserRole(json['email'] as String),
    );
  }

  /// Create AuthenticatedUserModel from API response (for authentication)
  static AuthenticatedUserModel createAuthenticatedUserFromApi(Map<String, dynamic> json) {
    return AuthenticatedUserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String,
      createdAt: DateHelper.parseApiDate(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateHelper.parseApiDate(json['updatedAt'] as String)
          : null,
      role: _determineUserRole(json['email'] as String),
      isEmailVerified: true, // Assume verified if can login
      lastLoginAt: DateTime.now(), // Set current time as last login
    );
  }

  /// Create full User from API response (complete data)
  static User createUserFromApi(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String,
      createdAt: DateHelper.parseApiDate(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateHelper.parseApiDate(json['updatedAt'] as String)
          : null,
      role: _determineUserRole(json['email'] as String),
      subscription: json['subscriptions'] != null
          ? _createSubscriptionFromJson(json['subscriptions'] as Map<String, dynamic>)
          : null,
      presignedLicense: json['presignedLicense'] != null
          ? _createPresignedLicenseFromJson(json['presignedLicense'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert UserBase to full User (when you need to upgrade entity)
  static User upgradeUserBase(
    UserBase userBase, {
    Subscription? subscription,
    PresignedLicense? presignedLicense,
  }) {
    return User(
      id: userBase.id,
      email: userBase.email,
      name: userBase.name,
      createdAt: userBase.createdAt,
      updatedAt: userBase.updatedAt,
      role: userBase.role,
      subscription: subscription,
      presignedLicense: presignedLicense,
    );
  }

  /// Convert full User to UserBase (when you need to downgrade entity)
  static UserBase downgradeUser(User user) {
    return UserBase(
      id: user.id,
      email: user.email,
      name: user.name,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      role: user.role,
    );
  }

  /// Shared logic for determining user role
  static UserRole _determineUserRole(String email) {
    if (email.contains('admin')) {
      return UserRole.admin;
    } else if (email.contains('instructor')) {
      return UserRole.instructor;
    }
    return UserRole.student;
  }

  /// Shared logic for creating Subscription from JSON
  static Subscription _createSubscriptionFromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as int,
      userId: json['userId'] as int,
      planName: json['planName'] as String,
      maxInstances: json['maxInstances'] as int,
      usedInstances: json['usedInstances'] as int,
      startDate: DateHelper.parseApiDate(json['startDate'] as String),
      endDate: DateHelper.parseApiDate(json['endDate'] as String),
      isActive: json['isActive'] as bool,
      createdAt: DateHelper.parseApiDate(json['createdAt'] as String),
      updatedAt: DateHelper.parseApiDate(json['updatedAt'] as String),
    );
  }

  /// Shared logic for creating PresignedLicense from JSON
  static PresignedLicense _createPresignedLicenseFromJson(Map<String, dynamic> json) {
    return PresignedLicense(
      id: json['id'] as int,
      licenseId: json['licenseId'] as int,
      userId: json['userId'] as int,
      isActive: json['isActive'] as bool,
      expiresAt: DateHelper.parseApiDate(json['expiresAt'] as String),
      createdAt: DateHelper.parseApiDate(json['createdAt'] as String),
      updatedAt: DateHelper.parseApiDate(json['updatedAt'] as String),
    );
  }
}
