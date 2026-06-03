import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/user/home_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        final args = settings.arguments;
        String userName = 'Pengguna';
        String userEmail = '';

        if (args is String && args.isNotEmpty) {
          userName = args;
        } else if (args is Map) {
          userName = args['userName'] ?? 'Pengguna';
          userEmail = args['userEmail'] ?? '';
        }

        return MaterialPageRoute(
          builder: (_) => HomeScreen(userName: userName, userEmail: userEmail),
        );
      case login:
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
