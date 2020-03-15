import 'package:mastodon_dart/mastodon_dart.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage extends AuthStorageDelegate {
  @override
  saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  @override
  Future<String> get fetchToken async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    return token;
  }
}
