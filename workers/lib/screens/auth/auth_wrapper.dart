import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firebase_service.dart';
import 'otp_login_screen.dart';
import 'worker_profile_setup_screen.dart';
import '../dashboard/dashboard_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
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
