import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _otpSent = false;
  String? _verificationId;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await FirebaseService.sendOTP(
        phoneNumber: _phoneController.text.trim(),
        onAutoVerify: (PhoneAuthCredential credential) async {
          // Auto-verification (instant verification on some devices)
          await _signInWithCredential(credential);
        },
        onCodeSent: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
            _otpSent = true;
            _isLoading = false;
          });
        },
        onError: (String error) {
          setState(() {
            _error = error;
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      setState(() => _error = 'Please enter 6-digit OTP');
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
    // Check if worker profile exists
    final profile = await FirebaseService.getWorkerProfile(user.uid);

    if (!mounted) return;

    if (profile == null) {
      // New user - go to profile setup
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
      // Existing user - go to home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WorkerHomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Header
                _buildHeader(),

                const SizedBox(height: 60),

                // Phone Input or OTP Input
                if (!_otpSent) _buildPhoneInput() else _buildOTPInput(),

                const SizedBox(height: 16),

                // Error message
                if (_error != null) _buildError(),

                const SizedBox(height: 32),

                // Submit Button
                _buildSubmitButton(),

                const SizedBox(height: 24),

                // Resend OTP
                if (_otpSent) _buildResendOTP(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.work_rounded, size: 48, color: AppColors.primary),
        ),
        const SizedBox(height: 24),
        Text(
          _otpSent ? 'Verify OTP' : 'Sign In',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _otpSent
              ? 'Enter the 6-digit code sent to\n${_phoneController.text}'
              : 'Enter your phone number to continue',
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      style: const TextStyle(fontSize: 18, letterSpacing: 1),
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '9876543210',
        prefixText: '+91 ',
        prefixIcon: const Icon(Icons.phone_android),
        counterText: '',
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (value.length != 10) {
          return 'Phone number must be 10 digits';
        }
        return null;
      },
    );
  }

  Widget _buildOTPInput() {
    return TextFormField(
      controller: _otpController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      style: const TextStyle(fontSize: 24, letterSpacing: 8),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: 'OTP Code',
        hintText: '000000',
        counterText: '',
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(color: Colors.red.shade700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : (_otpSent ? _verifyOTP : _sendOTP),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                _otpSent ? 'Verify & Continue' : 'Send OTP',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildResendOTP() {
    return Center(
      child: TextButton(
        onPressed: _isLoading ? null : _sendOTP,
        child: const Text(
          'Resend OTP',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
