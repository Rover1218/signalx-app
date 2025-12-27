import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firebase_service.dart';
import '../../models/worker_profile.dart';
import '../../models/job.dart';
import '../../constants/app_constants.dart';
import 'job_listings_screen.dart';
import '../schemes/schemes_screen.dart';
import '../ai/ai_assistant_screen.dart';
import '../profile/worker_profile_screen.dart';
import '../auth/otp_login_screen.dart';
import '../../l10n/app_localizations.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  WorkerProfile? _profile;
  List<Job> _recommendedJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final user = FirebaseService.currentUser;
      if (user == null) {
        _navigateToLogin();
        return;
      }

      final profileData = await FirebaseService.getWorkerProfile(user.uid);
      if (profileData != null) {
        _profile = WorkerProfile.fromMap(profileData);
      }

      // Fetch jobs matching worker's skills and location
      final jobsData = await FirebaseService.getJobs(
        workerSkills: _profile?.skills ?? [],
        workerLocation: _profile?.district ?? _profile?.location,
        limit: 5,
      );
      _recommendedJobs = jobsData.map((data) => Job.fromMap(data)).toList();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load data');
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OTPLoginScreen()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _logout() async {
    await FirebaseService.signOut();
    if (!mounted) return;
    _navigateToLogin();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                l10n.translate('loading'),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // App Bar with Profile
            _buildSliverAppBar(),
            
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Row
                    _buildStatsRow(),
                    
                    const SizedBox(height: 20),
                    
                    // AI Insights Card
                    _buildAIInsightsCard(),
                    
                    const SizedBox(height: 20),
                    
                    // Recent Jobs
                    _buildRecentJobsSection(),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSliverAppBar() {
    final l10n = AppLocalizations.of(context);
    
    return SliverAppBar(
      expandedHeight: 170,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      // Profile Photo
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: _profile?.photoURL != null
                              ? Image.network(_profile!.photoURL!, fit: BoxFit.cover)
                              : Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(
                                      _profile?.fullName[0].toUpperCase() ?? 'W',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Name and Location
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.translate('welcome_back_user'),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _profile?.fullName ?? l10n.translate('worker'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.white.withOpacity(0.9), size: 15),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _profile?.location ?? l10n.translate('not_set'),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: const [],
    );
  }

  Widget _buildStatsRow() {
    final l10n = AppLocalizations.of(context);
    
    return Row(
      children: [
        Expanded(child: _buildStatCard(l10n.translate('recommended'), '${_recommendedJobs.length}', Icons.work_outline, AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(l10n.translate('rating'), '${_profile?.rating ?? 0}', Icons.star_outline, AppColors.secondary)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(l10n.translate('skills'), '${_profile?.skills.length ?? 0}', Icons.construction_outlined, AppColors.accent)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            color.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
          ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightsCard() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accent, AppColors.accent.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.translate('ai_insights'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.translate('new_badge'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          _buildInsightItem(
            Icons.work, 
            '${_recommendedJobs.length} ${l10n.translate('jobs_match_skills')}', 
            AppColors.primary
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            Icons.account_balance, 
            '2 ${l10n.translate('schemes_available')}', 
            AppColors.secondary
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            Icons.location_on, 
            l10n.translate('work_in_block'), 
            Colors.orange
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 14),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('quick_actions_title'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildQuickAction(
              l10n.translate('find_jobs'),
              Icons.search_rounded,
              AppColors.primary,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobListingsScreen())),
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildQuickAction(
              l10n.translate('nav_schemes'),
              Icons.account_balance_wallet_rounded,
              AppColors.secondary,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SchemesScreen())),
            )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildQuickAction(
              l10n.translate('ai_assistant'),
              Icons.psychology_rounded,
              AppColors.accent,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIAssistantScreen())),
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildQuickAction(
              l10n.translate('nav_profile'),
              Icons.person_rounded,
              Colors.orange,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkerProfileScreen())),
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentJobsSection() {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.translate('recent_jobs_title'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobListingsScreen())),
              child: Text(
                l10n.translate('see_all'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (_recommendedJobs.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.work_off_outlined, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    l10n.translate('no_jobs_yet'),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          )
        else
          ...(_recommendedJobs.map((job) => _buildJobCard(job, l10n)).toList()), // Pass l10n here
      ],
    );
  }

  Widget _buildJobCard(Job job, AppLocalizations l10n) {
    // Helper to translate dynamic text - duplicated from JobListingsScreen for now as it's a small helper
    String getTranslatedJobText(String text) {
        if (text.isEmpty) return text;
        final directKey = 'job_$text';
        final translated = l10n.translate(directKey);
        if (translated != directKey) return translated;
        if (text.toLowerCase().contains('urgent')) {
           return '${l10n.translate('urgent')} - $text'; 
        }
        return text;
    }

    String displayTime = job.timeAgo;
    if (displayTime == 'Just now') {
      displayTime = l10n.translate('just_now');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.work, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslatedJobText(job.title),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  getTranslatedJobText(job.employerName),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      job.location,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.currency_rupee, size: 14, color: Colors.grey.shade500),
                    Text(
                      job.salary,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              displayTime,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, l10n.translate('nav_home'), true),
              _buildNavItem(Icons.search_rounded, l10n.translate('nav_jobs'), false, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const JobListingsScreen()));
              }),
              _buildNavItem(Icons.account_balance_wallet_rounded, l10n.translate('nav_schemes'), false, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SchemesScreen()));
              }),
              _buildNavItem(Icons.person_rounded, l10n.translate('nav_profile'), false, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkerProfileScreen()));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : Colors.grey.shade400,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? AppColors.primary : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
