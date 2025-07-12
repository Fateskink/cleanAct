import 'package:json_annotation/json_annotation.dart';

import '../../../../core/entities/user.dart';
import '../../../../core/utils/date_helper.dart';

part 'user_model.g.dart';

@JsonSerializable()
class SubscriptionModel {
  final int id;
  final int userId;
  final String planName;
  final int maxInstances;
  final int usedInstances;
  final String startDate;
  final String endDate;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  const SubscriptionModel({
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

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);

  /// Convert to domain entity
  Subscription toEntity() {
    return Subscription(
      id: id,
      userId: userId,
      planName: planName,
      maxInstances: maxInstances,
      usedInstances: usedInstances,
      startDate: DateHelper.parseApiDate(startDate),
      endDate: DateHelper.parseApiDate(endDate),
      isActive: isActive,
      createdAt: DateHelper.parseApiDate(createdAt),
      updatedAt: DateHelper.parseApiDate(updatedAt),
    );
  }
}

@JsonSerializable()
class PresignedLicenseModel {
  final int id;
  final int licenseId;
  final int userId;
  final bool isActive;
  final String expiresAt;
  final String createdAt;
  final String updatedAt;

  const PresignedLicenseModel({
    required this.id,
    required this.licenseId,
    required this.userId,
    required this.isActive,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PresignedLicenseModel.fromJson(Map<String, dynamic> json) =>
      _$PresignedLicenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PresignedLicenseModelToJson(this);

  /// Convert to domain entity
  PresignedLicense toEntity() {
    return PresignedLicense(
      id: id,
      licenseId: licenseId,
      userId: userId,
      isActive: isActive,
      expiresAt: DateHelper.parseApiDate(expiresAt),
      createdAt: DateHelper.parseApiDate(createdAt),
      updatedAt: DateHelper.parseApiDate(updatedAt),
    );
  }
}

@JsonSerializable()
class UserModel {
  final int id;
  final String email;
  final String name;
  final String createdAt;
  final String updatedAt;
  final SubscriptionModel? subscriptions;
  final PresignedLicenseModel? presignedLicense;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.subscriptions,
    this.presignedLicense,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convert to domain entity
  User toEntity() {
    return User(
      id: id.toString(),
      email: email,
      name: name,
      createdAt: DateHelper.parseApiDate(createdAt),
      updatedAt: DateHelper.parseApiDate(updatedAt),
      role: _determineUserRole(),
      subscription: subscriptions?.toEntity(),
      presignedLicense: presignedLicense?.toEntity(),
    );
  }

  /// Determine user role based on email or other criteria
  UserRole _determineUserRole() {
    if (email.contains('admin')) {
      return UserRole.admin;
    } else if (email.contains('instructor')) {
      return UserRole.instructor;
    }
    return UserRole.student;
  }
}
