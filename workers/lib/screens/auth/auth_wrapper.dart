import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/firebase_service.dart';
import 'otp_login_screen.dart';
import 'worker_profile_setup_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../splash_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool? _hasSeenSplash;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasSeenSplash = prefs.getBool('has_seen_splash') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Still checking if first time
    if (_hasSeenSplash == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // First time user - show splash screen
    if (!_hasSeenSplash!) {
      return const SplashScreen();
    }

    // Returning user - check authentication
    return StreamBuilder<User?>(
      stream: FirebaseService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User is not logged in
        if (!snapshot.hasData || snapshot.data == null) {
          return const OTPLoginScreen();
        }

        // User is logged in - check if profile exists
        return FutureBuilder<Map<String, dynamic>?>(
          future: FirebaseService.getWorkerProfile(snapshot.data!.uid),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Profile doesn't exist - go to profile setup
            if (!profileSnapshot.hasData || profileSnapshot.data == null) {
              return WorkerProfileSetupScreen(
                uid: snapshot.data!.uid,
                phoneNumber: snapshot.data!.phoneNumber ?? '',
              );
            }

            // Profile exists - go to home
            return const DashboardScreen();
          },
        );
      },
    );
  }
}
