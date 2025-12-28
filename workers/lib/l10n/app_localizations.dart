import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Map<String, Map<String, String>> get _localizedValues => {
    // ENGLISH
    'en': {
      // Generic
      'unknown_job': 'Unknown Job',
      'error_loading_applications': 'Error loading applications',
      
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
      'my_profile': 'My Profile',
      'location': 'Location',
      'experience': 'Experience',
      'education': 'Education',
      'logout': 'Logout',
      'logout_confirm': 'Are you sure you want to logout?',
      'language': 'Language',
      'apply_now': 'Apply Now',
      'urgent': 'Urgent',
      'years': 'years',
      'not_set': 'Not set',
      'not_specified': 'Not specified',
      'recommended': 'Recommended',
      'rating': 'Rating',
      'no_jobs': 'No jobs available',
      'check_back': 'Check back later for new opportunities',
      'enter_phone_title': 'Enter Phone Number',
      'enter_phone_subtitle': 'Enter your phone number\nWe\'ll send you a text verification code.',
      'mobile_number': 'Mobile number',
      'enter_number_hint': 'Enter your number',
      'enter_code': 'Enter code',
      'verify_subtitle': 'Please type the verification code sent to',
      'didnt_receive_code': 'If you didn\'t receive a code?',
      'resend': 'Resend',
      'error_invalid_phone': 'Please enter a valid 10-digit number',
      'error_invalid_otp_len': 'Please enter full 6-digit code',
      'error_invalid_otp': 'Invalid OTP. Please try again.',

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
      'preferred_job_types': 'Preferred Job Types',
      'government_schemes': 'Government Schemes',
      'learn_more': 'Learn More',
      'eligibility': 'Eligibility',
      'ai_insights': 'AI Insights',
      'new_badge': 'NEW',
      'jobs_match_skills': 'jobs match your skills',
      'schemes_available': 'government schemes available',
      'work_in_block': 'MGNREGA work in your block',
      'see_all': 'See All',
      'recent_jobs_title': 'Recent Jobs',
      'quick_actions_title': 'Quick Actions',
      'nav_home': 'Home',
      'nav_jobs': 'Jobs',
      'nav_schemes': 'Schemes',
      'nav_profile': 'Profile',
      'ai_assistant': 'AI Assistant',
      'no_jobs_yet': 'No jobs available yet',

      // Schemes
      'scheme_mgnrega_name': 'MGNREGA',
      'scheme_mgnrega_desc': '100 days guaranteed employment for rural households',
      'scheme_mgnrega_elig': 'Rural adults willing to do manual work',
      
      'scheme_pmsvanidhi_name': 'PM-SVANidhi',
      'scheme_pmsvanidhi_desc': 'Micro-credit scheme for street vendors',
      'scheme_pmsvanidhi_elig': 'Street vendors with certificate',
      
      'scheme_lakshmir_name': 'Lakshmir Bhandar',
      'scheme_lakshmir_desc': 'Cash transfer scheme for women (₹1,000-1,200/month)',
      'scheme_lakshmir_elig': 'Women aged 25-60 in West Bengal',
      
      'scheme_karma_name': 'Karma Sathi Prakalpa',
      'scheme_karma_desc': 'Employment facilitation and skill development',
      'scheme_karma_elig': 'Job seekers in West Bengal',
      
      'scheme_credit_name': 'Bhabishyat Credit Card',
      'scheme_credit_desc': 'Collateral-free loans up to ₹10 lakh',
      'scheme_credit_elig': 'Youth for self-employment/business',

      'scheme_pmkisan_name': 'PM-KISAN',
      'scheme_pmkisan_desc': 'Direct income support for farmers (₹6,000/year)',
      'scheme_pmkisan_elig': 'Farmer families',

      // Find Jobs
      'find_jobs': 'Find Jobs',
      'filter_all': 'All',
      'no_jobs_found': 'No jobs available',
      'check_back_later': 'Check back later for new opportunities',
      'apply_now': 'Apply Now',
      'application_submitted': 'Application submitted successfully!',
      'application_failed': 'Failed to apply. Please try again.',
      'location': 'Location',
      'salary': 'Salary',
      'description': 'Description',
      'no_skills_listed': 'No specific skills listed',
      'just_now': 'Just now',
      'urgent': 'Urgent',

      // Dynamic Job Mappings
      'job_Agricultural Worker': 'Agricultural Worker',
      'job_Farmers': 'Farmers',
      'job_MSME Operator': 'MSME Operator',
      'job_Driver Needed': 'Driver Needed',
      'job_Driver': 'Driver',

      // Skills
      'skill_Agriculture': 'Agriculture',
      'skill_Construction': 'Construction',
      'skill_Tailoring': 'Tailoring',
      'skill_Driving': 'Driving',
      'skill_Carpentry': 'Carpentry',
      'skill_Plumbing': 'Plumbing',
      'skill_Electrician': 'Electrician',
      'skill_Weaving': 'Weaving',
      'skill_Fishing': 'Fishing',
      'skill_Masonry': 'Masonry',
      'skill_Cooking': 'Cooking',
      'skill_Security': 'Security',

      // Job Types
      'job_type_Daily Wage': 'Daily Wage',
      'job_type_Contract': 'Contract',
      'job_type_Permanent': 'Permanent',
      'job_type_Part-time': 'Part-time',
      'job_type_Seasonal': 'Seasonal',

      // Education
      'edu_No formal education': 'No formal education',
      'edu_Primary (1-5)': 'Primary (1-5)',
      'edu_Middle (6-8)': 'Middle (6-8)',
      'edu_Secondary (9-10)': 'Secondary (9-10)',
      'edu_Higher Secondary (11-12)': 'Higher Secondary (11-12)',
      'edu_Graduate': 'Graduate',
      'edu_Post-graduate': 'Post-graduate',
    },

    // HINDI
    'hi': {
      // Generic
      'unknown_job': 'अज्ञात नौकरी',
      'error_loading_applications': 'आवेदन लोड नहीं हो सके',

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
      'my_profile': 'मेरी प्रोफ़ाइल',
      'location': 'स्थान',
      'experience': 'अनुभव',
      'education': 'शिक्षा',
      'logout': 'लॉग आउट',
      'logout_confirm': 'क्या आप लॉग आउट करना चाहते हैं?',
      'language': 'भाषा',
      'apply_now': 'अभी आवेदन करें',
      'urgent': 'अत्यावश्यक',
      'years': 'वर्ष',
      'not_set': 'सेट नहीं',
      'not_specified': 'निर्दिष्ट नहीं',
      'recommended': 'अनुशंसित',
      'rating': 'रेटिंग',
      'no_jobs': 'कोई नौकरी उपलब्ध नहीं',
      'check_back': 'नए अवसरों के लिए बाद में देखें',
      'enter_phone_title': 'फ़ोन नंबर दर्ज करें',
      'enter_phone_subtitle': 'अपना फ़ोन नंबर दर्ज करें\nहम आपको एक टेक्स्ट सत्यापन कोड भेजेंगे।',
      'mobile_number': 'मोबाइल नंबर',
      'enter_number_hint': 'अपना नंबर दर्ज करें',
      'enter_code': 'कोड दर्ज करें',
      'verify_subtitle': 'कृपया सत्यापन कोड टाइप करें जो भेजा गया है',
      'didnt_receive_code': 'क्या आपको कोड नहीं मिला?',
      'resend': 'पुनः भेजें',
      'error_invalid_phone': 'कृपया एक वैध 10-अंकीय नंबर दर्ज करें',
      'error_invalid_otp_len': 'कृपया पूरा 6-अंकीय कोड दर्ज करें',
      'error_invalid_otp': 'अमान्य OTP। कृपया पुनः प्रयास करें।',

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
      'preferred_job_types': 'पसंदीदा नौकरी के प्रकार',
      'government_schemes': 'सरकारी योजनाएं',
      'learn_more': 'और अधिक जानें',
      'eligibility': 'पात्रता',
      'ai_insights': 'एआई इनसाइट्स',
      'new_badge': 'नया',
      'jobs_match_skills': 'नौकरियां आपकी योग्यता से मेल खाती हैं',
      'schemes_available': 'सरकारी योजनाएं उपलब्ध हैं',
      'work_in_block': 'आपके ब्लॉक में मनरेगा कार्य',
      'see_all': 'सभी देखें',
      'recent_jobs_title': 'हाल की नौकरियां',
      'quick_actions_title': 'त्वरित कार्रवाई',
      'nav_home': 'होम',
      'nav_jobs': 'नौकरियां',
      'nav_schemes': 'योजनाएं',
      'nav_profile': 'प्रोफ़ाइल',
      'ai_assistant': 'एआई सहायक',
      'no_jobs_yet': 'अभी कोई नौकरी उपलब्ध नहीं है',

      // Schemes
      'scheme_mgnrega_name': 'मनरेगा',
      'scheme_mgnrega_desc': 'ग्रामीण परिवारों के लिए 100 दिनों की गारंटी रोजगार',
      'scheme_mgnrega_elig': 'हाथ से काम करने के इच्छुक ग्रामीण वयस्क',
      
      'scheme_pmsvanidhi_name': 'पीएम-स्वनिधि',
      'scheme_pmsvanidhi_desc': 'सड़क विक्रेताओं के लिए माइक्रो-क्रेडिट योजना',
      'scheme_pmsvanidhi_elig': 'प्रमाण पत्र वाले सड़क विक्रेता',
      
      'scheme_lakshmir_name': 'लक्ष्मी भंडार',
      'scheme_lakshmir_desc': 'महिलाओं के लिए नकद हस्तांतरण (₹1,000-1,200/माह)',
      'scheme_lakshmir_elig': 'पश्चिम बंगाल की 25-60 वर्ष की महिलाएं',
      
      'scheme_karma_name': 'कर्म साथी प्रकल्प',
      'scheme_karma_desc': 'रोजगार सुविधा और कौशल विकास',
      'scheme_karma_elig': 'पश्चिम बंगाल के नौकरी चाहने वाले',
      
      'scheme_credit_name': 'भविष्य क्रेडिट कार्ड',
      'scheme_credit_desc': '₹10 लाख तक का बिना गारंटी ऋण',
      'scheme_credit_elig': 'स्वरोजगार/व्यवसाय के लिए युवा',

      'scheme_pmkisan_name': 'पीएम-किसान',
      'scheme_pmkisan_desc': 'किसानों के लिए प्रत्यक्ष आय सहायता (₹6,000/वर्ष)',
      'scheme_pmkisan_elig': 'किसान परिवार',

      // Find Jobs
      'find_jobs': 'नौकरियां खोजें',
      'filter_all': 'सभी',
      'no_jobs_found': 'कोई नौकरी उपलब्ध नहीं है',
      'check_back_later': 'नए अवसरों के लिए बाद में देखें',
      'apply_now': 'अभी आवेदन करें',
      'application_submitted': 'आवेदन सफलतापूर्वक जमा किया गया!',
      'application_failed': 'आवेदन करने में विफल। कृपया पुन: प्रयास करें।',
      'location': 'स्थान',
      'salary': 'वेतन',
      'description': 'विवरण',
      'no_skills_listed': 'कोई विशिष्ट कौशल सूचीबद्ध नहीं है',
      'just_now': 'अभी',
      'urgent': 'अत्यावश्यक',

      // Dynamic Job Mappings
      'job_Agricultural Worker': 'कृषि कार्यकर्ता',
      'job_Farmers': 'किसान',
      'job_MSME Operator': 'MSME ऑपरेटर',
      'job_Driver Needed': 'ड्राइवर चाहिए',
      'job_Driver': 'ड्राइवर',

      // Skills
      'skill_Agriculture': 'कृषि',
      'skill_Construction': 'निर्माण',
      'skill_Tailoring': 'सिलाई',
      'skill_Driving': 'ड्राइविंग',
      'skill_Carpentry': 'बढ़ईगीरी',
      'skill_Plumbing': 'प्लंबिंग',
      'skill_Electrician': 'बिजली मिस्त्री',
      'skill_Weaving': 'बुनाई',
      'skill_Fishing': 'मछली पकड़ना',
      'skill_Masonry': 'राजमिस्त्री',
      'skill_Cooking': 'खाना बनाना',
      'skill_Security': 'सुरक्षा',

      // Job Types
      'job_type_Daily Wage': 'दिहाड़ी मजदूरी',
      'job_type_Contract': 'अनुबंध',
      'job_type_Permanent': 'स्थायी',
      'job_type_Part-time': 'अंशकालिक',
      'job_type_Seasonal': 'मौसमी',

      // Education
      'edu_No formal education': 'कोई औपचारिक शिक्षा नहीं',
      'edu_Primary (1-5)': 'प्राथमिक (1-5)',
      'edu_Middle (6-8)': 'मध्य (6-8)',
      'edu_Secondary (9-10)': 'माध्यमिक (9-10)',
      'edu_Higher Secondary (11-12)': 'उच्च माध्यमिक (11-12)',
      'edu_Graduate': 'स्नातक',
      'edu_Post-graduate': 'स्नातकोत्तर',
    },

    // BENGALI
    'bn': {
      // Generic
      'unknown_job': 'অজানা কাজ',
      'error_loading_applications': 'আবেদন লোড করতে সমস্যা',

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
      'my_profile': 'আমার প্রোফাইল',
      'location': 'অবস্থান',
      'experience': 'অভিজ্ঞতা',
      'education': 'শিক্ষা',
      'logout': 'লগ আউট',
      'logout_confirm': 'আপনি কি নিশ্চিত যে আপনি লগ আউট করতে চান?',
      'language': 'ভাষা',
      'years': 'বছর',
      'not_set': 'সেট করা হয়নি',
      'not_specified': 'উল্লেখিত নেই',
      'recommended': 'প্রস্তাবিত',
      'rating': 'রেটিং',
      'no_jobs': 'কোন কাজ উপলব্ধ নেই',
      'check_back': 'নতুন সুযোগের জন্য পরে দেখুন',
      'enter_phone_title': 'ফোন নম্বর লিখুন',
      'enter_phone_subtitle': 'আপনার ফোন নম্বর লিখুন\nআমরা আপনাকে একটি টেক্সট ভেরিফিকেশন কোড পাঠাব।',
      'mobile_number': 'মোবাইল নম্বর',
      'enter_number_hint': 'আপনার নম্বর লিখুন',
      'enter_code': 'কোড লিখুন',
      'verify_subtitle': 'অনুগ্রহ করে ভেরিফিকেশন কোডটি লিখুন যা পাঠানো হয়েছে',
      'didnt_receive_code': 'আপনি কি কোড পাননি?',
      'resend': 'পুনরায় পাঠান',
      'error_invalid_phone': 'অনুগ্রহ করে একটি বৈধ ১০-অঙ্কের নম্বর লিখুন',
      'error_invalid_otp_len': 'অনুগ্রহ করে পুরো ৬-অঙ্কের কোড লিখুন',
      'error_invalid_otp': 'অবৈধ OTP। অনুগ্রহ করে আবার চেষ্টা করুন।',

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
      'preferred_job_types': 'পছন্দের কাজের ধরন',
      'government_schemes': 'সরকারি প্রকল্পসমূহ',
      'learn_more': 'আরও জানুন',
      'eligibility': 'যোগ্যতা',
      'ai_insights': 'এআই পরামর্শ',
      'new_badge': 'নতুন',
      'jobs_match_skills': 'টি কাজ আপনার দক্ষতার সাথে মিলছে',
      'schemes_available': 'টি সরকারি প্রকল্প উপলব্ধ',
      'work_in_block': 'আপনার ব্লকে ১০০ দিনের কাজ',
      'see_all': 'সব দেখুন',
      'recent_jobs_title': 'সাম্প্রতিক কাজ',
      'quick_actions_title': 'দ্রুত অ্যাকশন',
      'nav_home': 'হোম',
      'nav_jobs': 'কাজ',
      'nav_schemes': 'প্রকল্প',
      'nav_profile': 'প্রোফাইল',
      'ai_assistant': 'এআই সহকারী',
      'no_jobs_yet': 'এখনও কোন কাজ উপলব্ধ নেই',

      // Schemes
      'scheme_mgnrega_name': '১০০ দিনের কাজ (MGNREGA)',
      'scheme_mgnrega_desc': 'গ্রামীণ পরিবারের জন্য ১০০ দিনের নিশ্চিত কর্মসংস্থান',
      'scheme_mgnrega_elig': 'শারীরিক শ্রমে ইচ্ছুক গ্রামীণ প্রাপ্তবয়স্করা',
      
      'scheme_pmsvanidhi_name': 'পিএম-স্বনিধি',
      'scheme_pmsvanidhi_desc': 'রাস্তার হকারদের জন্য মাইক্রো-ক্রেডিট স্কিম',
      'scheme_pmsvanidhi_elig': 'সার্টিফিকেটধারী রাস্তার হকাররা',

      // My Applications
      'my_applications': 'আমার আবেদনসমূহ',
      'application_status': 'আবেদনের স্ট্যাটাস',
      'status_pending': 'বিচারাধীন',
      'status_accepted': 'গৃহীত',
      'status_rejected': 'প্রত্যাখ্যাত',
      'status_shortlisted': 'বাছাইকৃত',
      'applied_on': 'আবেদনের তারিখ',
      'view_job': 'কাজটি দেখুন',
      'no_applications': 'আপনি এখনও কোনো কাজের জন্য আবেদন করেননি',
      
      'scheme_lakshmir_name': 'লক্ষ্মীর ভাণ্ডার',
      'scheme_lakshmir_desc': 'নারীদের জন্য মাসিক আর্থিক সহায়তা (₹১,০০০-১,২০০/মাস)',
      'scheme_lakshmir_elig': 'পশ্চিমবঙ্গের ২৫-৬০ বছর বয়সী নারীরা',
      
      'scheme_karma_name': 'কর্মসাথী প্রকল্প',
      'scheme_karma_desc': 'কর্মসংস্থান এবং দক্ষতা বৃদ্ধি',
      'scheme_karma_elig': 'পশ্চিমবঙ্গের চাকরিপ্রার্থীরা',
      
      'scheme_credit_name': 'ভবিষ্যৎ ক্রেডিট কার্ড',
      'scheme_credit_desc': '১০ লক্ষ টাকা পর্যন্ত জামানতবিহীন ঋণ',
      'scheme_credit_elig': 'স্ব-কর্মসংস্থান/ব্যবসার জন্য যুবকরা',

      'scheme_pmkisan_name': 'পিএম-কিষাণ',
      'scheme_pmkisan_desc': 'কৃষকদের জন্য সরাসরি আয় সহায়তা (₹৬,০০০/বছর)',
      'scheme_pmkisan_elig': 'কৃষক পরিবার',

      // Find Jobs
      'find_jobs': 'কাজ খুঁজুন',
      'filter_all': 'সব',
      'no_jobs_found': 'কোন কাজ বর্তমানে নেই',
      'check_back_later': 'নতুন সুযোগের জন্য পরে আবার দেখুন',
      'apply_now': 'আবেদন করুন',
      'application_submitted': 'আবেদন সফলভাবে জমা দেওয়া হয়েছে!',
      'application_failed': 'আবেদন করতে ব্যর্থ। আবার চেষ্টা করুন।',
      'location': 'অবস্থান',
      'salary': 'বেতন',
      'description': 'বিবরণ',
      'no_skills_listed': 'কোন নির্দিষ্ট দক্ষতা উল্লেখ করা হয়নি',
      'just_now': 'এখনই',
      'urgent': 'জরুরী',

      // Dynamic Job Mappings
      'job_Agricultural Worker': 'কৃষি কর্মী',
      'job_Farmers': 'কৃষক',
      'job_MSME Operator': 'এমএসএমই অপারেটর',
      'job_Driver Needed': 'ড্রাইভার প্রয়োজন',
      'job_Driver': 'ড্রাইভার',

      // Skills
      'skill_Agriculture': 'কৃষি',
      'skill_Construction': 'নির্মাণ',
      'skill_Tailoring': 'সেলাই',
      'skill_Driving': 'ড্রাইভিং',
      'skill_Carpentry': 'কাঠমিস্ত্রি',
      'skill_Plumbing': 'প্লাম্বিং',
      'skill_Electrician': 'ইলেকট্রিশিয়ান',
      'skill_Weaving': 'তাঁত',
      'skill_Fishing': 'মাছ ধরা',
      'skill_Masonry': 'রাজমিস্ত্রি',
      'skill_Cooking': 'রান্না',
      'skill_Security': 'নিরাপত্তা',

      // Job Types
      'job_type_Daily Wage': 'দৈনিক মজুরি',
      'job_type_Contract': 'চুক্তিভিত্তিক',
      'job_type_Permanent': 'স্থায়ী',
      'job_type_Part-time': 'খণ্ডকালীন',
      'job_type_Seasonal': 'মৌসুমি',

      // Education
      'edu_No formal education': 'আনুষ্ঠানিক শিক্ষা নেই',
      'edu_Primary (1-5)': 'প্রাথমিক (১-৫)',
      'edu_Middle (6-8)': 'মাধ্যমিক (৬-৮)',
      'edu_Secondary (9-10)': 'মাধ্যমিক (৯-১০)',
      'edu_Higher Secondary (11-12)': 'উচ্চ মাধ্যমিক (১১-১২)',
      'edu_Graduate': 'স্নাতক',
      'edu_Post-graduate': 'স্নাতকোত্তর',
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
