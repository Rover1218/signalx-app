import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/job.dart';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({super.key});

  @override
  State<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
  List<Job> _jobs = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Daily Wage', 'Contract', 'Permanent'];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);
    
    try {
      final jobsData = await FirebaseService.getJobs(limit: 50);
      _jobs = jobsData.map((data) => Job.fromMap(data)).toList();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load jobs: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Job> get _filteredJobs {
    if (_selectedFilter == 'All') return _jobs;
    // Note: Filtering logic remains based on English strings for now as job titles are mixed
    return _jobs.where((job) => job.title.contains(_selectedFilter)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.translate('find_jobs')),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filters
          _buildFilters(l10n),

          const SizedBox(height: 16),

          // Jobs List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredJobs.isEmpty
                    ? _buildEmptyState(l10n)
                    : RefreshIndicator(
                        onRefresh: _loadJobs,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: _filteredJobs.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _buildJobCard(_filteredJobs[index], l10n);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          
          // Translate display label
          String label;
          if (filter == 'All') {
            label = l10n.translate('filter_all');
          } else {
             // Try to map job types, fallback to original
             label = l10n.translate('job_type_$filter');
             if (label.startsWith('job_type_')) label = filter;
          }

          return FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (selected) {
              setState(() => _selectedFilter = filter);
            },
            selectedColor: AppColors.primary.withOpacity(0.2),
            checkmarkColor: AppColors.primary,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            l10n.translate('no_jobs_found'),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.translate('check_back_later'),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Job job, AppLocalizations l10n) {
    // Simple translation for 'Just now'
    String displayTime = job.timeAgo;
    if (displayTime == 'Just now') {
      displayTime = l10n.translate('just_now');
    }

    return GestureDetector(
      onTap: () => _showJobDetails(job),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Employer Photo
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: job.employerPhoto != null
                        ? Image.network(job.employerPhoto!, fit: BoxFit.cover)
                        : Center(
                            child: Text(
                              job.employerName.isNotEmpty ? job.employerName[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTranslatedJobText(job.title, l10n),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getTranslatedJobText(job.employerName, l10n),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Time ago badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.shade200,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    displayTime,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description preview
            Text(
              _getTranslatedJobText(job.description, l10n),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 12),

            // Location and Salary
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job.location,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.currency_rupee, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  job.salary,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showJobDetails(Job job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            job.employerName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Location & Salary
                          _buildDetailRow(
                            Icons.location_on,
                            l10n.translate('location'),
                            job.location,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            Icons.currency_rupee,
                            l10n.translate('salary'),
                            job.salary,
                          ),

                          const SizedBox(height: 24),

                          // Description
                          Text(
                            l10n.translate('description'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            job.description,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Skills
                          Text(
                            l10n.translate('skills'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (job.skills.isEmpty)
                            Text(
                              l10n.translate('no_skills_listed'),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: job.skills.map((skill) {
                                // Translate skill if possible
                                String skillLabel = l10n.translate('skill_$skill');
                                if (skillLabel.startsWith('skill_')) skillLabel = skill;
                                
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                                  ),
                                  child: Text(
                                    skillLabel,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          const SizedBox(height: 32),

                          // Apply Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _applyToJob(job, l10n);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                l10n.translate('apply_now'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _applyToJob(Job job, AppLocalizations l10n) async {
    try {
      final user = FirebaseService.currentUser;
      if (user == null) return;

      await FirebaseService.applyToJob(
        jobId: job.id,
        workerId: user.uid,
        applicationData: {
          'workerName': user.displayName ?? 'Worker',
          'workerPhone': user.phoneNumber,
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate('application_submitted')),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate('application_failed')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getTranslatedJobText(String text, AppLocalizations l10n) {
    if (text.isEmpty) return text;
    
    // Check for direct mapping
    final directKey = 'job_$text';
    final translated = l10n.translate(directKey);
    if (translated != directKey) return translated;

    // Check for partial matches or specific phrases
    if (text.toLowerCase().contains('urgent')) {
       return '${l10n.translate('urgent')} - $text'; 
    }

    return text;
  }
}
