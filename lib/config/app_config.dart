/// Application configuration
///
/// For production builds, pass the API_URL at build time:
/// ```
/// flutter build web --dart-define=API_URL=https://admin.trabuild.com/api/v1
/// ```
class AppConfig {
  AppConfig._();

  /// API base URL - configurable via --dart-define=API_URL=...
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  /// Whether the app is running in production mode
  static const bool isProduction = String.fromEnvironment(
    'PRODUCTION',
    defaultValue: 'false',
  ) == 'true';
}
