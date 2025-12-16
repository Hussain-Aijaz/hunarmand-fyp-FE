import 'package:flutter/material.dart';
import 'package:hunarmand/providers/auth_provider.dart';
import 'package:hunarmand/providers/providers.dart';
import 'package:hunarmand/screens/dashboard_screen.dart';
import 'package:hunarmand/screens/login_screen.dart';
import 'package:hunarmand/services/shared_prefs_service.dart';
import 'package:hunarmand/services/user_service.dart';
import 'package:hunarmand/services/permission_service.dart'; // Add this
import 'package:hunarmand/utlis/app_router.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPrefsService.init();

  // Load user from preferences
  await UserService().loadUserFromPrefs();

  // Request permissions on app launch
  await PermissionService().requestPermissionsOnLaunch();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.providers,
      child: MaterialApp(
        title: 'Hunarmand',
        navigatorKey: AppRouter.navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Plus Jakarta Sans',
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AppInitializer(),
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return FutureBuilder<bool>(
      future: _checkAuthStatus(authProvider),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final isLoggedIn = snapshot.data ?? false;

        if (isLoggedIn) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }

  Future<bool> _checkAuthStatus(AuthProvider authProvider) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return authProvider.isLoggedIn;
  }
}