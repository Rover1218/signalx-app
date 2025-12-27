import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    // ENGLISH
    'en': {
      // Common
      'app_name': 'Workers',
      'tagline': 'Find the right worker for any job',
      'loading': 'Loading...',
      'cancel': 'Cancel',
      'save': 'Save',
      'done': 'Done',
      'next': 'Next',
      'back': 'Back',
      'submit': 'Submit',
      'continue': 'Continue',

      // Login Screen
      'welcome_back': 'Welcome Back!',
      'sign_in_to_continue': 'Sign in to continue to Workers',
      'email_address': 'Email Address',
      'enter_email': 'Enter your email',
      'password': 'Password',
      'enter_password': 'Enter your password',
      'remember_me': 'Remember me',
      'forgot_password': 'Forgot Password?',
      'sign_in': 'Sign In',
      'or_continue_with': 'Or continue with',
      'google': 'Google',
      'phone': 'Phone',
      'dont_have_account': "Don't have an account? ",
      'sign_up': 'Sign Up',
      'change_language': 'Change Language',
      'select_language': 'Select Language',

      // Register Screen
      'create_account': 'Create Account',
      'join_workers': 'Join Workers and start finding jobs',
      'full_name': 'Full Name',
      'enter_full_name': 'Enter your full name',
      'confirm_password': 'Confirm Password',
      'reenter_password': 'Re-enter your password',
      'i_agree_to': 'I agree to the ',
      'terms_of_service': 'Terms of Service',
      'and': ' and ',
      'privacy_policy': 'Privacy Policy',
      'already_have_account': 'Already have an account? ',

      // Profile Completion
      'complete_profile': 'Complete Your Profile',
      'few_more_details': 'Just a few more details',
      'step_3_of_3': 'Step 3 of 3',
      'profile_details': 'Profile Details',
      'tell_us_about': 'Tell us about yourself',
      'profile_help_text':
          'This information helps us match you with the right opportunities',
      'i_am_a': 'I am a',
      'worker': 'Worker',
      'employer': 'Employer',
      'both': 'Both',
      'phone_number': 'Phone Number',
      'enter_phone': 'Enter your phone number',
      'address': 'Address',
      'enter_address': 'Enter your address',
      'skills': 'Skills',
      'skills_hint': 'e.g., Plumbing, Electrical, Carpentry',
      'bio': 'Bio',
      'bio_hint': 'Tell us about yourself...',
      'complete_profile_btn': 'Complete Profile',

      // Dashboard
      'welcome_back_user': 'Welcome back,',
      'active_jobs': 'Active Jobs',
      'completed': 'Completed',
      'earnings': 'Earnings',
      'recent_jobs': 'Recent Jobs',
      'view_all': 'View All',
      'quick_actions': 'Quick Actions',
      'find_jobs': 'Find Jobs',
      'post_job': 'Post Job',
      'messages': 'Messages',
      'settings': 'Settings',
      'home': 'Home',
      'jobs': 'Jobs',
      'post': 'Post',
      'chat': 'Chat',
      'profile': 'Profile',
      'apply_now': 'Apply Now',
      'urgent': 'Urgent',

      // Validation
      'please_enter_email': 'Please enter your email',
      'enter_valid_email': 'Please enter a valid email',
      'please_enter_password': 'Please enter your password',
      'password_min_length': 'Password must be at least 6 characters',
      'please_enter_name': 'Please enter your name',
      'name_min_length': 'Name must be at least 3 characters',
      'please_confirm_password': 'Please confirm your password',
      'passwords_not_match': 'Passwords do not match',
      'accept_terms': 'Please accept the terms and conditions',
      'select_user_type': 'Please select a user type',
    },

    // HINDI
    'hi': {
      // Common
      'app_name': 'वर्कर्स',
      'tagline': 'किसी भी काम के लिए सही कर्मचारी खोजें',
      'loading': 'लोड हो रहा है...',
      'cancel': 'रद्द करें',
      'save': 'सहेजें',
      'done': 'हो गया',
      'next': 'अगला',
      'back': 'वापस',
      'submit': 'जमा करें',
      'continue': 'जारी रखें',

      // Login Screen
      'welcome_back': 'वापसी पर स्वागत है!',
      'sign_in_to_continue': 'वर्कर्स में जारी रखने के लिए साइन इन करें',
      'email_address': 'ईमेल पता',
      'enter_email': 'अपना ईमेल दर्ज करें',
      'password': 'पासवर्ड',
      'enter_password': 'अपना पासवर्ड दर्ज करें',
      'remember_me': 'मुझे याद रखें',
      'forgot_password': 'पासवर्ड भूल गए?',
      'sign_in': 'साइन इन करें',
      'or_continue_with': 'या इससे जारी रखें',
      'google': 'गूगल',
      'phone': 'फोन',
      'dont_have_account': 'खाता नहीं है? ',
      'sign_up': 'साइन अप करें',
      'change_language': 'भाषा बदलें',
      'select_language': 'भाषा चुनें',

      // Register Screen
      'create_account': 'खाता बनाएं',
      'join_workers': 'वर्कर्स से जुड़ें और नौकरियां खोजना शुरू करें',
      'full_name': 'पूरा नाम',
      'enter_full_name': 'अपना पूरा नाम दर्ज करें',
      'confirm_password': 'पासवर्ड की पुष्टि करें',
      'reenter_password': 'पासवर्ड दोबारा दर्ज करें',
      'i_agree_to': 'मैं सहमत हूं ',
      'terms_of_service': 'सेवा की शर्तें',
      'and': ' और ',
      'privacy_policy': 'गोपनीयता नीति',
      'already_have_account': 'पहले से खाता है? ',

      // Profile Completion
      'complete_profile': 'अपनी प्रोफ़ाइल पूरी करें',
      'few_more_details': 'बस कुछ और जानकारी',
      'step_3_of_3': 'चरण 3 का 3',
      'profile_details': 'प्रोफ़ाइल विवरण',
      'tell_us_about': 'अपने बारे में बताएं',
      'profile_help_text':
          'यह जानकारी हमें आपको सही अवसरों से मिलाने में मदद करती है',
      'i_am_a': 'मैं हूं',
      'worker': 'कर्मचारी',
      'employer': 'नियोक्ता',
      'both': 'दोनों',
      'phone_number': 'फोन नंबर',
      'enter_phone': 'अपना फोन नंबर दर्ज करें',
      'address': 'पता',
      'enter_address': 'अपना पता दर्ज करें',
      'skills': 'कौशल',
      'skills_hint': 'जैसे, प्लंबिंग, इलेक्ट्रिकल, बढ़ईगीरी',
      'bio': 'बायो',
      'bio_hint': 'अपने बारे में बताएं...',
      'complete_profile_btn': 'प्रोफ़ाइल पूरी करें',

      // Dashboard
      'welcome_back_user': 'वापसी पर स्वागत है,',
      'active_jobs': 'सक्रिय नौकरियां',
      'completed': 'पूर्ण',
      'earnings': 'कमाई',
      'recent_jobs': 'हाल की नौकरियां',
      'view_all': 'सभी देखें',
      'quick_actions': 'त्वरित कार्रवाई',
      'find_jobs': 'नौकरी खोजें',
      'post_job': 'नौकरी पोस्ट करें',
      'messages': 'संदेश',
      'settings': 'सेटिंग्स',
      'home': 'होम',
      'jobs': 'नौकरियां',
      'post': 'पोस्ट',
      'chat': 'चैट',
      'profile': 'प्रोफ़ाइल',
      'apply_now': 'अभी आवेदन करें',
      'urgent': 'अत्यावश्यक',

      // Validation
      'please_enter_email': 'कृपया अपना ईमेल दर्ज करें',
      'enter_valid_email': 'कृपया एक वैध ईमेल दर्ज करें',
      'please_enter_password': 'कृपया अपना पासवर्ड दर्ज करें',
      'password_min_length': 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए',
      'please_enter_name': 'कृपया अपना नाम दर्ज करें',
      'name_min_length': 'नाम कम से कम 3 अक्षरों का होना चाहिए',
      'please_confirm_password': 'कृपया अपना पासवर्ड पुष्टि करें',
      'passwords_not_match': 'पासवर्ड मेल नहीं खाते',
      'accept_terms': 'कृपया नियम और शर्तें स्वीकार करें',
      'select_user_type': 'कृपया उपयोगकर्ता प्रकार चुनें',
    },

    // BENGALI
    'bn': {
      // Common
      'app_name': 'ওয়ার্কার্স',
      'tagline': 'যেকোনো কাজের জন্য সঠিক কর্মী খুঁজুন',
      'loading': 'লোড হচ্ছে...',
      'cancel': 'বাতিল',
      'save': 'সংরক্ষণ করুন',
      'done': 'সম্পন্ন',
      'next': 'পরবর্তী',
      'back': 'পিছনে',
      'submit': 'জমা দিন',
      'continue': 'চালিয়ে যান',

      // Login Screen
      'welcome_back': 'আবার স্বাগতম!',
      'sign_in_to_continue': 'ওয়ার্কার্সে চালিয়ে যেতে সাইন ইন করুন',
      'email_address': 'ইমেইল ঠিকানা',
      'enter_email': 'আপনার ইমেইল লিখুন',
      'password': 'পাসওয়ার্ড',
      'enter_password': 'আপনার পাসওয়ার্ড লিখুন',
      'remember_me': 'আমাকে মনে রাখুন',
      'forgot_password': 'পাসওয়ার্ড ভুলে গেছেন?',
      'sign_in': 'সাইন ইন',
      'or_continue_with': 'অথবা চালিয়ে যান',
      'google': 'গুগল',
      'phone': 'ফোন',
      'dont_have_account': 'অ্যাকাউন্ট নেই? ',
      'sign_up': 'সাইন আপ',
      'change_language': 'ভাষা পরিবর্তন',
      'select_language': 'ভাষা নির্বাচন করুন',

      // Register Screen
      'create_account': 'অ্যাকাউন্ট তৈরি করুন',
      'join_workers': 'ওয়ার্কার্সে যোগ দিন এবং কাজ খুঁজতে শুরু করুন',
      'full_name': 'পুরো নাম',
      'enter_full_name': 'আপনার পুরো নাম লিখুন',
      'confirm_password': 'পাসওয়ার্ড নিশ্চিত করুন',
      'reenter_password': 'আবার পাসওয়ার্ড লিখুন',
      'i_agree_to': 'আমি সম্মত ',
      'terms_of_service': 'সেবার শর্তাবলী',
      'and': ' এবং ',
      'privacy_policy': 'গোপনীয়তা নীতি',
      'already_have_account': 'ইতিমধ্যে অ্যাকাউন্ট আছে? ',

      // Profile Completion
      'complete_profile': 'আপনার প্রোফাইল সম্পূর্ণ করুন',
      'few_more_details': 'আরও কিছু তথ্য দিন',
      'step_3_of_3': 'ধাপ ৩ এর ৩',
      'profile_details': 'প্রোফাইল বিবরণ',
      'tell_us_about': 'নিজের সম্পর্কে বলুন',
      'profile_help_text':
          'এই তথ্য আমাদের আপনাকে সঠিক সুযোগের সাথে মেলাতে সাহায্য করে',
      'i_am_a': 'আমি একজন',
      'worker': 'কর্মী',
      'employer': 'নিয়োগকর্তা',
      'both': 'উভয়',
      'phone_number': 'ফোন নম্বর',
      'enter_phone': 'আপনার ফোন নম্বর লিখুন',
      'address': 'ঠিকানা',
      'enter_address': 'আপনার ঠিকানা লিখুন',
      'skills': 'দক্ষতা',
      'skills_hint': 'যেমন, প্লাম্বিং, ইলেকট্রিক্যাল, কাঠমিস্ত্রি',
      'bio': 'বায়ো',
      'bio_hint': 'নিজের সম্পর্কে বলুন...',
      'complete_profile_btn': 'প্রোফাইল সম্পূর্ণ করুন',

      // Dashboard
      'welcome_back_user': 'আবার স্বাগতম,',
      'active_jobs': 'সক্রিয় কাজ',
      'completed': 'সম্পন্ন',
      'earnings': 'আয়',
      'recent_jobs': 'সাম্প্রতিক কাজ',
      'view_all': 'সব দেখুন',
      'quick_actions': 'দ্রুত কার্যক্রম',
      'find_jobs': 'কাজ খুঁজুন',
      'post_job': 'কাজ পোস্ট করুন',
      'messages': 'বার্তা',
      'settings': 'সেটিংস',
      'home': 'হোম',
      'jobs': 'কাজ',
      'post': 'পোস্ট',
      'chat': 'চ্যাট',
      'profile': 'প্রোফাইল',
      'apply_now': 'এখনই আবেদন করুন',
      'urgent': 'জরুরি',

      // Validation
      'please_enter_email': 'অনুগ্রহ করে আপনার ইমেইল লিখুন',
      'enter_valid_email': 'অনুগ্রহ করে একটি বৈধ ইমেইল লিখুন',
      'please_enter_password': 'অনুগ্রহ করে আপনার পাসওয়ার্ড লিখুন',
      'password_min_length': 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে',
      'please_enter_name': 'অনুগ্রহ করে আপনার নাম লিখুন',
      'name_min_length': 'নাম কমপক্ষে ৩ অক্ষরের হতে হবে',
      'please_confirm_password': 'অনুগ্রহ করে আপনার পাসওয়ার্ড নিশ্চিত করুন',
      'passwords_not_match': 'পাসওয়ার্ড মিলছে না',
      'accept_terms': 'অনুগ্রহ করে শর্তাবলী স্বীকার করুন',
      'select_user_type': 'অনুগ্রহ করে ব্যবহারকারীর ধরন নির্বাচন করুন',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'bn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
