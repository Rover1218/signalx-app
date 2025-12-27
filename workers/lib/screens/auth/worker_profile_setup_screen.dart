import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/firebase_service.dart';
import '../../services/cloudinary_service.dart';
import '../../constants/app_constants.dart';
import '../dashboard/dashboard_screen.dart';

class WorkerProfileSetupScreen extends StatefulWidget {
  final String uid;
  final String phoneNumber;

  const WorkerProfileSetupScreen({
    super.key,
    required this.uid,
    required this.phoneNumber,
  });

  @override
  State<WorkerProfileSetupScreen> createState() =>
      _WorkerProfileSetupScreenState();
}

class _WorkerProfileSetupScreenState extends State<WorkerProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _districtController = TextEditingController();
  final _blockController = TextEditingController();
  final _villageController = TextEditingController();
  final _experienceController = TextEditingController();

  File? _selectedImage;
  String? _uploadedPhotoURL;
  bool _isUploading = false;
  bool _isSaving = false;
  String? _error;

  final List<String> _selectedSkills = [];
  final List<String> _selectedJobTypes = [];
  String? _selectedEducation;

  final List<String> _availableSkills = [
    'Agriculture',
    'Construction',
    'Tailoring',
    'Driving',
    'Carpentry',
    'Plumbing',
    'Electrician',
    'Weaving',
    'Fishing',
    'Masonry',
    'Cooking',
    'Security',
  ];

  final List<String> _availableJobTypes = [
    'Daily Wage',
    'Contract',
    'Permanent',
    'Part-time',
    'Seasonal',
  ];

  final List<String> _educationLevels = [
    'No formal education',
    'Primary (1-5)',
    'Middle (6-8)',
    'Secondary (9-10)',
    'Higher Secondary (11-12)',
    'Graduate',
    'Post-graduate',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _districtController.dispose();
    _blockController.dispose();
    _villageController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
      _error = null;
    });

    try {
      final xFile = XFile(_selectedImage!.path);
      final response = await CloudinaryService.uploadImage(xFile);
      
      if (response != null) {
        setState(() {
          _uploadedPhotoURL = response.secureUrl;
          _isUploading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to upload image';
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to upload image: $e';
        _isUploading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSkills.isEmpty) {
      setState(() => _error = 'Please select at least one skill');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      final profileData = {
        'uid': widget.uid,
        'fullName': _nameController.text.trim(),
        'phoneNumber': widget.phoneNumber,
        'photoURL': _uploadedPhotoURL,
        'district': _districtController.text.trim(),
        'block': _blockController.text.trim(),
        'village': _villageController.text.trim(),
        'skills': _selectedSkills,
        'experienceYears': int.tryParse(_experienceController.text.trim()),
        'educationLevel': _selectedEducation,
        'preferredJobTypes': _selectedJobTypes,
        'createdAt': DateTime.now(),
      };

      await FirebaseService.saveWorkerProfile(
        uid: widget.uid,
        profileData: profileData,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    } catch (e) {
      setState(() {
        _error = 'Failed to save profile. Please try again.';
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Photo
            _buildHeaderSection(),
            
            // Form Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personal Info Card
                    _buildSectionCard(
                      title: 'Personal Information',
                      icon: Icons.person_outline,
                      child: Column(
                        children: [
                          _buildModernTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                            icon: Icons.person,
                            isRequired: true,
                            validator: (v) => v!.isEmpty ? 'Name is required' : null,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Location Card
                    _buildSectionCard(
                      title: 'Location Details',
                      icon: Icons.location_on_outlined,
                      child: Column(
                        children: [
                          _buildModernTextField(
                            controller: _districtController,
                            label: 'District',
                            hint: 'e.g., Murshidabad',
                            icon: Icons.location_city,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildModernTextField(
                                  controller: _blockController,
                                  label: 'Block',
                                  hint: 'e.g., Kandi',
                                  icon: Icons.map_outlined,
                                  compact: true,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildModernTextField(
                                  controller: _villageController,
                                  label: 'Village',
                                  hint: 'Village name',
                                  icon: Icons.home_outlined,
                                  compact: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Skills Card
                    _buildSectionCard(
                      title: 'Your Skills',
                      icon: Icons.construction_outlined,
                      subtitle: 'Select all that apply',
                      child: _buildSkillsGrid(),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Experience & Education Card
                    _buildSectionCard(
                      title: 'Experience & Education',
                      icon: Icons.school_outlined,
                      child: Column(
                        children: [
                          _buildModernTextField(
                            controller: _experienceController,
                            label: 'Years of Experience',
                            hint: '0',
                            icon: Icons.work_history_outlined,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          _buildEducationDropdown(),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Job Preferences Card
                    _buildSectionCard(
                      title: 'Job Preferences',
                      icon: Icons.work_outline,
                      subtitle: 'What type of work do you prefer?',
                      child: _buildJobTypesGrid(),
                    ),
                    
                    // Error Message
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      _buildErrorBanner(),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    // Submit Button
                    _buildSubmitButton(),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // Profile Photo
          GestureDetector(
            onTap: _isUploading ? null : _pickImage,
            child: Stack(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: _isUploading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : ClipOval(
                          child: _selectedImage != null
                              ? Image.file(_selectedImage!, fit: BoxFit.cover, width: 110, height: 110)
                              : _uploadedPhotoURL != null
                                  ? Image.network(_uploadedPhotoURL!, fit: BoxFit.cover, width: 110, height: 110)
                                  : Container(
                                      color: Colors.grey.shade100,
                                      child: const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            _selectedImage == null && _uploadedPhotoURL == null
                ? 'Add Your Photo'
                : 'Tap to Change',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    String? subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool isRequired = false,
    bool compact = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
              children: isRequired
                  ? [
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildSkillsGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: _availableSkills.map((skill) {
        final isSelected = _selectedSkills.contains(skill);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedSkills.remove(skill);
              } else {
                _selectedSkills.add(skill);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Text(
              skill,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEducationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education Level',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedEducation,
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.school_outlined, color: Colors.grey.shade500, size: 20),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          hint: Text('Select your education', style: TextStyle(color: Colors.grey.shade400)),
          items: _educationLevels.map((level) {
            return DropdownMenuItem(value: level, child: Text(level, style: const TextStyle(fontSize: 14)));
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedEducation = value);
          },
        ),
      ],
    );
  }

  Widget _buildJobTypesGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: _availableJobTypes.map((type) {
        final isSelected = _selectedJobTypes.contains(type);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedJobTypes.remove(type);
              } else {
                _selectedJobTypes.add(type);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.secondary : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(color: Colors.red.shade700, fontSize: 13),
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
        onPressed: _isSaving ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: _isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Complete Profile',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
      ),
    );
  }
}
