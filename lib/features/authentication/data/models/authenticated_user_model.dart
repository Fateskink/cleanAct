import 'package:json_annotation/json_annotation.dart';

import '../../../../core/entities/user.dart'; // Import UserRole
import '../../domain/entities/authenticated_user.dart';

part 'authenticated_user_model.g.dart';

@JsonSerializable()
class AuthenticatedUserModel extends AuthenticatedUser {
  const AuthenticatedUserModel({
    required String id,
    required DateTime createdAt,
    DateTime? updatedAt,
    required String email,
    required String name,
    required UserRole role,
    bool isEmailVerified = false,
    DateTime? lastLoginAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          email: email,
          name: name,
          role: role,
          isEmailVerified: isEmailVerified,
          lastLoginAt: lastLoginAt,
        );

  factory AuthenticatedUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticatedUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticatedUserModelToJson(this);

  factory AuthenticatedUserModel.fromEntity(AuthenticatedUser user) {
    return AuthenticatedUserModel(
      id: user.id,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      email: user.email,
      name: user.name,
      role: user.role,
      isEmailVerified: user.isEmailVerified,
      lastLoginAt: user.lastLoginAt,
    );
  }

  @override
  UserRole get role {
    if (email.contains('admin')) {
      return UserRole.admin;
    } else if (email.contains('instructor')) {
      return UserRole.instructor;
    }
    return UserRole.student;
  }
}
