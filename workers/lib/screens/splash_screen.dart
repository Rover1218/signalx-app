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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onGetStarted() async {
    // Mark that user has seen the splash screen
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

            // Page Indicators with Smooth Animation
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
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

            const SizedBox(height: 32),

            // Get Started Button with Enhanced Design
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                    shadowColor: AppColors.primary.withOpacity(0.5),
                  ).copyWith(
                    overlayColor: WidgetStateProperty.all(
                      Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
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
