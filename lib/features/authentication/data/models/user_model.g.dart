// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      planName: json['planName'] as String,
      maxInstances: (json['maxInstances'] as num).toInt(),
      usedInstances: (json['usedInstances'] as num).toInt(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'planName': instance.planName,
      'maxInstances': instance.maxInstances,
      'usedInstances': instance.usedInstances,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

PresignedLicenseModel _$PresignedLicenseModelFromJson(
        Map<String, dynamic> json) =>
    PresignedLicenseModel(
      id: (json['id'] as num).toInt(),
      licenseId: (json['licenseId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      isActive: json['isActive'] as bool,
      expiresAt: json['expiresAt'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$PresignedLicenseModelToJson(
        PresignedLicenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'licenseId': instance.licenseId,
      'userId': instance.userId,
      'isActive': instance.isActive,
      'expiresAt': instance.expiresAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      subscriptions: json['subscriptions'] == null
          ? null
          : SubscriptionModel.fromJson(
              json['subscriptions'] as Map<String, dynamic>),
      presignedLicense: json['presignedLicense'] == null
          ? null
          : PresignedLicenseModel.fromJson(
              json['presignedLicense'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'subscriptions': instance.subscriptions,
      'presignedLicense': instance.presignedLicense,
    };
