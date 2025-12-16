import 'package:flutter/material.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> navigateToLogin({String? message}) async {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
          (route) => false,
      arguments: {'message': message},
    );
  }

  static BuildContext? get context => navigatorKey.currentContext;
}