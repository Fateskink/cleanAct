// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticated_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticatedUserModel _$AuthenticatedUserModelFromJson(
        Map<String, dynamic> json) =>
    AuthenticatedUserModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      email: json['email'] as String,
      name: json['name'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
    );

Map<String, dynamic> _$AuthenticatedUserModelToJson(
        AuthenticatedUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'email': instance.email,
      'name': instance.name,
      'isEmailVerified': instance.isEmailVerified,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'role': _$UserRoleEnumMap[instance.role]!,
    };

const _$UserRoleEnumMap = {
  UserRole.student: 'student',
  UserRole.instructor: 'instructor',
  UserRole.admin: 'admin',
};
