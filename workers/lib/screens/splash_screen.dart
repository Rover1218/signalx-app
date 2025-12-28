import 'dart:async'; // Add import
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'auth/auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _navigationTimer;
  Timer? _rotationTimer;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.work_outline,
      iconColor: AppColors.primary,
      title: 'Find Your\nPerfect Job',
      subtitle: 'Discover thousands of job opportunities\ntailored just for you.',
    ),
    OnboardingPage(
      icon: Icons.psychology_outlined,
      iconColor: AppColors.accent,
      title: 'AI-Powered\nRecommendations',
      subtitle: 'Get personalized job matches and\ncareer guidance with smart AI.',
    ),
    OnboardingPage(
      icon: Icons.account_balance_wallet_outlined,
      iconColor: AppColors.secondary,
      title: 'Access Govt.\nSchemes',
      subtitle: 'Stay updated with government schemes\nand benefits available for you.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Auto-redirect after 5 seconds
    _navigationTimer = Timer(const Duration(seconds: 5), _onGetStarted);
    
    // Auto-rotate pages every 1.5 seconds
    _rotationTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _rotationTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_splash', true);
    
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Logo
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.work,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SignalX',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page Indicators
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: _currentPage == index ? 32 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: _currentPage == index ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ] : [],
                    ),
                  );
                }),
              ),
            ),

            // Loader
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Circle with Enhanced Shadow
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: page.iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: page.iconColor.withOpacity(0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 15),
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: page.iconColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 110,
              color: page.iconColor,
            ),
          ),

          const SizedBox(height: 56),

          // Title with Better Typography
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 20),

          // Subtitle with Improved Readability
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}
