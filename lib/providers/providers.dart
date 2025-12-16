import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;
import 'auth_provider.dart';

class Providers {
  static final authProvider = AuthProvider();

  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
  ];
}
