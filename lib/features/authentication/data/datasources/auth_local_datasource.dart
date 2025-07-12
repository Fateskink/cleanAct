import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

/// Local data source for authentication
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<bool> isUserCached();
}

/// Implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  const AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await sharedPreferences.setString(AppConstants.userKey, userJson);

    // Also store email as identifier (since we don't have token)
    await sharedPreferences.setString('user_email', user.email);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = sharedPreferences.getString(AppConstants.userKey);

    if (userJson != null) {
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }

    return null;
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(AppConstants.userKey);
    await sharedPreferences.remove('user_email');
  }

  @override
  Future<bool> isUserCached() async {
    final userJson = sharedPreferences.getString(AppConstants.userKey);
    return userJson != null;
  }

  /// Get cached user email
  Future<String?> getCachedUserEmail() async {
    return sharedPreferences.getString('user_email');
  }
}
