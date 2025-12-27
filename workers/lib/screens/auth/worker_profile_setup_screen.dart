import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/firebase_service.dart';
import '../../services/cloudinary_service.dart';
import '../../constants/app_constants.dart';
import '../dashboard/worker_home_screen.dart';

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
      // Convert File to XFile
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
          builder: (context) => const WorkerHomeScreen(),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Complete Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo
              _buildPhotoSection(),
              
              const SizedBox(height: 32),

              // Basic Info
              _buildTextField(
                controller: _nameController,
                label: 'Full Name *',
                hint: 'Enter your full name',
                icon: Icons.person,
                validator: (v) => v!.isEmpty ? 'Name required' : null,
              ),
              
              const SizedBox(height: 16),

              // Location
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildTextField(
                controller: _districtController,
                label: 'District',
                hint: 'e.g., Murshidabad',
                icon: Icons.location_city,
              ),
              const SizedBox(height: 12),
              
              _buildTextField(
                controller: _blockController,
                label: 'Block',
                hint: 'e.g., Kandi',
                icon: Icons.map,
              ),
              const SizedBox(height: 12),
              
              _buildTextField(
                controller: _villageController,
                label: 'Village',
                hint: 'Your village name',
                icon: Icons.home,
              ),

              const SizedBox(height: 24),

              // Skills
              _buildSkillsSection(),

              const SizedBox(height: 24),

              // Experience
              _buildTextField(
                controller: _experienceController,
                label: 'Experience (years)',
                hint: '0',
                icon: Icons.work_history,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              // Education
              _buildEducationDropdown(),

              const SizedBox(height: 24),

              // Preferred Job Types
              _buildJobTypesSection(),

              const SizedBox(height: 16),

              // Error
              if (_error != null) _buildError(),

              const SizedBox(height: 32),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _isUploading ? null : _pickImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
                border: Border.all(color: AppColors.primary, width: 3),
              ),
              child: _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : _selectedImage != null || _uploadedPhotoURL != null
                      ? ClipOval(
                          child: _selectedImage != null
                              ? Image.file(_selectedImage!, fit: BoxFit.cover)
                              : Image.network(_uploadedPhotoURL!,
                                  fit: BoxFit.cover),
                        )
                      : const Icon(Icons.add_a_photo, size: 40, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _selectedImage == null ? 'Add Photo' : 'Change Photo',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skills *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableSkills.map((skill) {
            final isSelected = _selectedSkills.contains(skill);
            return FilterChip(
              label: Text(skill),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSkills.add(skill);
                  } else {
                    _selectedSkills.remove(skill);
                  }
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEducationDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedEducation,
      decoration: InputDecoration(
        labelText: 'Education Level',
        prefixIcon: const Icon(Icons.school, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: _educationLevels.map((level) {
        return DropdownMenuItem(value: level, child: Text(level));
      }).toList(),
      onChanged: (value) {
        setState(() => _selectedEducation = value);
      },
    );
  }

  Widget _buildJobTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Job Types',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableJobTypes.map((type) {
            final isSelected = _selectedJobTypes.contains(type);
            return FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedJobTypes.add(type);
                  } else {
                    _selectedJobTypes.remove(type);
                  }
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _error!,
        style: TextStyle(color: Colors.red.shade700),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Complete Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
