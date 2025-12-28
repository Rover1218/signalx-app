import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final schemes = [
      {
        'name': l10n.translate('scheme_mgnrega_name'),
        'description': l10n.translate('scheme_mgnrega_desc'),
        'eligibility': l10n.translate('scheme_mgnrega_elig'),
        'icon': Icons.construction_rounded,
        'color': const Color(0xFF10B981), // Emerald Green
        'gradient': [const Color(0xFF10B981), const Color(0xFF059669)],
        'url': 'https://nrega.nic.in/',
      },
      {
        'name': l10n.translate('scheme_pmsvanidhi_name'),
        'description': l10n.translate('scheme_pmsvanidhi_desc'),
        'eligibility': l10n.translate('scheme_pmsvanidhi_elig'),
        'icon': Icons.store_rounded,
        'color': const Color(0xFF3B82F6), // Blue
        'gradient': [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
        'url': 'https://pmsvanidhi.mohua.gov.in/',
      },
      {
        'name': l10n.translate('scheme_lakshmir_name'),
        'description': l10n.translate('scheme_lakshmir_desc'),
        'eligibility': l10n.translate('scheme_lakshmir_elig'),
        'icon': Icons.account_balance_wallet_rounded,
        'color': const Color(0xFF8B5CF6), // Purple
        'gradient': [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
        'url': 'https://wb.gov.in/portal/web/guest/lakshmir-bhandar',
      },
      {
        'name': l10n.translate('scheme_karma_name'),
        'description': l10n.translate('scheme_karma_desc'),
        'eligibility': l10n.translate('scheme_karma_elig'),
        'icon': Icons.work_rounded,
        'color': const Color(0xFFF59E0B), // Amber
        'gradient': [const Color(0xFFF59E0B), const Color(0xFFD97706)],
        'url': 'https://karmasathiprakalpa.wb.gov.in/',
      },
      {
        'name': l10n.translate('scheme_credit_name'),
        'description': l10n.translate('scheme_credit_desc'),
        'eligibility': l10n.translate('scheme_credit_elig'),
        'icon': Icons.credit_card_rounded,
        'color': const Color(0xFF14B8A6), // Teal
        'gradient': [const Color(0xFF14B8A6), const Color(0xFF0D9488)],
        'url': 'https://wbmsme.gov.in/bhabishyat-credit-card/',
      },
      {
        'name': l10n.translate('scheme_pmkisan_name'),
        'description': l10n.translate('scheme_pmkisan_desc'),
        'eligibility': l10n.translate('scheme_pmkisan_elig'),
        'icon': Icons.agriculture_rounded,
        'color': const Color(0xFFA16207), // Brown
        'gradient': [const Color(0xFFA16207), const Color(0xFF854D0E)],
        'url': 'https://pmkisan.gov.in/',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Enhanced Gradient AppBar
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
                    Positioned(
                      bottom: -10,
                      left: -10,
                      child: Container(
                        width: 80,
                        height: 80,
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
                              l10n.translate('government_schemes'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${schemes.length} ${l10n.translate('schemes_available')}',
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

          // Schemes List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final scheme = schemes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildSchemeCard(context, scheme, l10n),
                  );
                },
                childCount: schemes.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(BuildContext context, Map<String, dynamic> scheme, AppLocalizations l10n) {
    final List<Color> gradientColors = scheme['gradient'] as List<Color>;
    final Color mainColor = scheme['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    scheme['icon'] as IconData,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    scheme['name'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scheme['description'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Eligibility Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_rounded, 
                        color: Colors.green.shade500,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              height: 1.4,
                              fontFamily: 'Inter', // Ensuring font consistency
                            ),
                            children: [
                              TextSpan(
                                text: '${l10n.translate('eligibility')}: ',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: scheme['eligibility'] as String),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _openSchemeUrl(scheme['url'] as String);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      side: BorderSide(color: mainColor.withOpacity(0.3), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.translate('learn_more'),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: mainColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18, color: mainColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openSchemeUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
