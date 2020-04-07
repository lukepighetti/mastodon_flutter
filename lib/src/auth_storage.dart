import 'package:mastodon_dart/mastodon_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This class provides functions for handling the user's authentication token locally via SharedPreferences.
class AuthStorage extends AuthStorageDelegate {
  /// Save an authentication token
  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("token", token);
  }

  /// Delete an authentication token
  @override
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove("token");
  }

  /// Retrieve an authentication token
  @override
  Future<String> get fetchToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
