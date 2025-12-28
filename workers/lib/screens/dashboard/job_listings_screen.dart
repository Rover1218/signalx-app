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
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Premium Gradient AppBar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF1E3A8A),
            leading: null,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E3A8A),
                      Color(0xFF3B82F6),
                      Color(0xFF1E40AF),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -30,
                      right: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    // Content
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              l10n.translate('find_jobs'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${_jobs.length} jobs available',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filters
          SliverToBoxAdapter(
            child: _buildFilters(l10n),
          ),

          // Jobs List
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
                  ),
                )
              : _filteredJobs.isEmpty
                  ? SliverFillRemaining(child: _buildEmptyState(l10n))
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildJobCard(_filteredJobs[index], l10n),
                          ),
                          childCount: _filteredJobs.length,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: _filters.map((filter) {
            final isSelected = filter == _selectedFilter;
            
            String label;
            if (filter == 'All') {
              label = l10n.translate('filter_all');
            } else {
              label = l10n.translate('job_type_$filter');
              if (label.startsWith('job_type_')) label = filter;
            }

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilter = filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.grey.shade200,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check_circle, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.work_off_rounded,
                size: 56,
                color: const Color(0xFF3B82F6).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.translate('no_jobs_found'),
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.translate('check_back_later'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(Job job, AppLocalizations l10n) {
    String displayTime = job.timeAgo;
    if (displayTime == 'Just now') {
      displayTime = l10n.translate('just_now');
    }

    // Determine badge color based on time
    final bool isNew = displayTime == l10n.translate('just_now');
    final Color badgeColor = isNew ? const Color(0xFF10B981) : const Color(0xFF3B82F6);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showJobDetails(job),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Employer Photo with gradient border
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF3B82F6).withOpacity(0.6),
                            const Color(0xFF1E40AF).withOpacity(0.4),
                          ],
                        ),
                      ),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF3B82F6).withOpacity(0.08),
                              const Color(0xFF1E40AF).withOpacity(0.04),
                            ],
                          ),
                        ),
                        child: ClipOval(
                          child: job.employerPhoto != null
                              ? Image.network(job.employerPhoto!, fit: BoxFit.cover)
                              : Center(
                                  child: Text(
                                    job.employerName.isNotEmpty ? job.employerName[0].toUpperCase() : '?',
                                    style: const TextStyle(
                                      color: Color(0xFF3B82F6),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTranslatedJobText(job.title, l10n),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
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

                    // Time badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: badgeColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        displayTime,
                        style: TextStyle(
                          fontSize: 11,
                          color: badgeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Description preview
                Text(
                  _getTranslatedJobText(job.description, l10n),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 14),

                // Location and Salary Row
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildInfoChip(Icons.location_on_rounded, job.location),
                      const SizedBox(width: 16),
                      Container(
                        width: 1,
                        height: 20,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoChip(Icons.currency_rupee_rounded, job.salary, isBold: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, {bool isBold = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF3B82F6)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF475569),
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
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
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            Icons.work_outline,
                            l10n.translate('preferred_job_types'),
                            _getTranslatedJobType(job.jobType, l10n),
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

  String _getTranslatedJobType(String type, AppLocalizations l10n) {
    if (type.isEmpty) return type;
    String key = 'job_type_$type';
    String translated = l10n.translate(key);
    // If translation key is returned (meaning missing), return original
    // Use proper check against key name
    if (translated == key) return type;
    return translated;
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
