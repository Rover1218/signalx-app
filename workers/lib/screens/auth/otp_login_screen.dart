import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart'; // Keep for future if needed, or use for the OTP illustration
import '../../services/firebase_service.dart';
import '../../constants/app_constants.dart';
import 'worker_profile_setup_screen.dart';
import '../dashboard/worker_home_screen.dart';

class OTPLoginScreen extends StatefulWidget {
  const OTPLoginScreen({super.key});

  @override
  State<OTPLoginScreen> createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  bool _isLoading = false;
  bool _otpSent = false;
  bool _rememberMe = false;
  String? _verificationId;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (_phoneController.text.trim().length != 10) {
      setState(() => _error = 'Please enter a valid 10-digit number');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Safety timeout
      Timer(const Duration(seconds: 30), () {
        if (mounted && _isLoading && !_otpSent) {
          setState(() {
            _isLoading = false;
            _error = 'Request timed out. Try again.';
          });
        }
      });

      await FirebaseService.sendOTP(
        phoneNumber: '+91${_phoneController.text.trim()}',
        onCodeSent: (String verificationId) {
           if (!mounted) return;
          setState(() {
            _verificationId = verificationId;
            _otpSent = true;
            _isLoading = false;
          });
          // Auto focus OTP
          Future.delayed(const Duration(milliseconds: 100), () {
             FocusScope.of(context).requestFocus(_otpFocusNode);
          });
        },
        onAutoVerify: (PhoneAuthCredential credential) async {
           if (!mounted) return;
          await _signInWithCredential(credential);
        },
        onError: (String error) {
           if (!mounted) return;
          setState(() {
            _error = error;
            _isLoading = false;
          });
        },
      );
    } catch (e) {
       if (!mounted) return;
      setState(() {
        _error = 'Failed to send OTP';
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.trim().length != 6) {
      setState(() => _error = 'Please enter full 6-digit code');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final credential = await FirebaseService.verifyOTP(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );

      if (credential != null && credential.user != null) {
        await _handleSuccessfulLogin(credential.user!);
      }
    } catch (e) {
      setState(() {
        _error = 'Invalid OTP. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _handleSuccessfulLogin(userCredential.user!);
      }
    } catch (e) {
      setState(() {
        _error = 'Authentication failed';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSuccessfulLogin(User user) async {
    final profileData = await FirebaseService.getWorkerProfile(user.uid);

    if (!mounted) return;

    if (profileData == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WorkerProfileSetupScreen(
            uid: user.uid,
            phoneNumber: user.phoneNumber ?? '',
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WorkerHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine which screen "page" to show
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _otpSent
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                   setState(() {
                      _otpSent = false;
                      _otpController.clear();
                      _error = null;
                      _isLoading = false;
                   });
                },
              )
            : const SizedBox.shrink(), // Or back to splash? 
            // If it's the first screen, we might want no back button or exit app
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _otpSent ? _buildVerifyCodeScreen() : _buildPhoneScreen(),
        ),
      ),
    );
  }

  // --- Screens ---

  Widget _buildPhoneScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lottie Animation
        Center(
          child: SizedBox(
            height: 180,
            width: 180,
            child: Lottie.asset(
              AppAssets.splashAnimation,
              fit: BoxFit.contain,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        const Text(
          'Enter Phone Number',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter your phone number\nWe\'ll send you a text verification code.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),

        // Input
        const Text(
          'Mobile number',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Colors.grey.shade200), // Optional border
          ),
          child: Row(
            children: [
              const Text(
                '+91',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 1,
                height: 24,
                color: Colors.grey.shade300,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter your number',
                    hintStyle: TextStyle(color: Colors.black26),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(
             _error!,
             style: const TextStyle(color: Colors.red, fontSize: 13),
          ),
        ],

        const Spacer(),

        // Continue Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _sendOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: _isLoading 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CONTINUE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildVerifyCodeScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   'Verify Code',
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // const SizedBox(height: 32),
        
        // Illustration placeholder
        Center(
          child: Container(
             height: 120,
             width: 120,
             decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
             ),
             child: const Icon(
               Icons.security_rounded, 
               size: 60, 
               color: AppColors.primary
             ),
          ),
        ),
        const SizedBox(height: 24),
        
        const Center(
          child: Text(
            'Enter code',
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Please type the verification code \nsent to +91 ${_phoneController.text}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ),
        
        const SizedBox(height: 40),

        // OTP Input Custom
        Center(child: _buildUnderlineOTPInput()),

        if (_error != null) ...[
          const SizedBox(height: 24),
          Center(
            child: Text(
               _error!,
               style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],

        const Spacer(),

        // Continue Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, // Using primary Blue
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
             child: _isLoading 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CONTINUE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
          ),
        ),

        const SizedBox(height: 16),

        // Resend
        Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'If you didn\'t receive a code? ',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              GestureDetector(
                onTap: _isLoading ? null : _sendOTP,
                child: const Text(
                  'Resend',
                  style: TextStyle(
                    color: AppColors.primary, 
                    fontWeight: FontWeight.bold,
                    fontSize: 13
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // A custom widget to mimic the underline look while keeping one TextField
  Widget _buildUnderlineOTPInput() {
    return SizedBox(
      width: 300,
      height: 60,
      child: Stack(
        children: [
          // 1. The visual representation (Bottom Layer)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              String char = '';
              if (index < _otpController.text.length) {
                char = _otpController.text[index];
              }
              
              return Container(
                width: 40,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: Colors.grey, 
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    char,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            }),
          ),

          // 2. The hidden actual TextField (Top Layer - Transparent Touch Target)
          TextField(
            controller: _otpController,
            focusNode: _otpFocusNode,
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) {
              setState(() {}); // Rebuild to update UI boxes
            },
            cursorColor: Colors.transparent, // Hide default cursor
            enableInteractiveSelection: false, // Disable selection handles
            style: const TextStyle(color: Colors.transparent), // Hide actual text
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
              disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              fillColor: Colors.transparent,
              filled: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
