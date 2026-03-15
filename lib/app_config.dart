// app_config.dart
import 'package:flutter/material.dart';
import 'package:id_app/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static String baseUrl = AppConfig.baseUrl;
  static String appName = "Gemini";
  static String appVersion = "1.0.0";
  static String appDescription =
      "An application for managing your tasks and projects.";
  static String supportEmail = "RwLb3@example.com";
  static Color primaryColor = const Color(0xFF23A4C9);

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      router.go('/login');
      throw Exception("Token not found");
    }
    
    return token;
  }
}
