/// Application constants
class AppConstants {
  // App Info
  static const String appName = 'CleanAct';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api.cleanact.com';
  static const String apiVersion = 'v1';
  static const String apiPath = '/api/$apiVersion';

  // Endpoints
  static const String authEndpoint = '$apiPath/auth';
  static const String coursesEndpoint = '$apiPath/courses';
  static const String enrollmentsEndpoint = '$apiPath/enrollments';
  static const String assignmentsEndpoint = '$apiPath/assignments';
  static const String submissionsEndpoint = '$apiPath/submissions';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // Request Timeouts (in seconds)
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Duration (in hours)
  static const int courseCacheDuration = 1;
  static const int userCacheDuration = 24;

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi'];

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
}
