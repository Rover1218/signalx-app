import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schemes = [
      {
        'name': 'MGNREGA',
        'description': '100 days guaranteed employment for rural households',
        'eligibility': 'Rural adults willing to do manual work',
        'icon': Icons.construction,
        'color': Colors.green,
      },
      {
        'name': 'PM-SVANidhi',
        'description': 'Micro-credit scheme for street vendors',
        'eligibility': 'Street vendors with certificate',
        'icon': Icons.store,
        'color': Colors.blue,
      },
      {
        'name': 'Lakshmir Bhandar',
        'description': 'Cash transfer scheme for women (₹1,000-1,200/month)',
        'eligibility': 'Women aged 25-60 in West Bengal',
        'icon': Icons.account_balance_wallet,
        'color': Colors.purple,
      },
      {
        'name': 'Karma Sathi Prakalpa',
        'description': 'Employment facilitation and skill development',
        'eligibility': 'Job seekers in West Bengal',
        'icon': Icons.work,
        'color': Colors.orange,
      },
      {
        'name': 'Bhabishyat Credit Card',
        'description': 'Collateral-free loans up to ₹10 lakh',
        'eligibility': 'Youth for self-employment/business',
        'icon': Icons.credit_card,
        'color': Colors.teal,
      },
      {
        'name': 'PM-KISAN',
        'description': 'Direct income support for farmers (₹6,000/year)',
        'eligibility': 'Farmer families',
        'icon': Icons.agriculture,
        'color': Colors.brown,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Government Schemes'),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: schemes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return _buildSchemeCard(context, scheme);
        },
      ),
    );
  }

  Widget _buildSchemeCard(BuildContext context, Map<String, dynamic> scheme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (scheme['color'] as Color).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme['color'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    scheme['icon'],
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    scheme['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: scheme['color'],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scheme['description'],
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.check_circle, 
                      color: Colors.green.shade600,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Eligibility: ${scheme['eligibility']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showSchemeDetails(context, scheme);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme['color'],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Check Eligibility',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
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

  void _showSchemeDetails(BuildContext context, Map<String, dynamic> scheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(scheme['name']),
        content: Text(
          'For more information about ${scheme['name']}, please visit your nearest government office or call the helpline.\n\nThis feature will be enhanced with AI-powered eligibility checking soon!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
