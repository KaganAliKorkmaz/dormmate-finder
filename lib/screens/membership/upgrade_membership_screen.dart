import 'package:flutter/material.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_colors.dart';
import '../../utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpgradeMembershipScreen extends StatelessWidget {
  const UpgradeMembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text(
          'Upgrade Membership',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose How to Upgrade',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _buildOptionCard(
              context,
              title: 'Customize Your Plan',
              description: 'Select individual features and build your own plan',
              icon: Icons.add_circle_outline,
              onTap: () {
                        Navigator.pushNamed(context, AppRoutes.membershipFeatures);
              },
            ),
            const SizedBox(height: 20),
            _buildOptionCard(
              context,
              title: 'Premium Package',
              description:
                  'Get our most popular features at a discounted price',
              icon: Icons.star_border,
              price: '\$9.99',
              onTap: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  FirebaseFirestore.instance.collection('user_purchases').add({
                    'userId': user.uid,
                    'userEmail': user.email ?? 'unknown@email.com',
                    'membershipType': 'Premium',
                    'purchaseTimestamp': FieldValue.serverTimestamp(),
                  }).then((_) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.paymentSuccess,
                      arguments: 'Premium',
                    );
                  }).catchError((error) {
                    Logger.error('Error purchasing Premium', error);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${AppStrings.errorOccurred}: $error')),
                      );
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('You need to be logged in')),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            _buildOptionCard(
              context,
              title: 'Pro Package',
              description: 'All features included with priority support',
              icon: Icons.workspace_premium,
              price: '\$19.99',
              onTap: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  FirebaseFirestore.instance.collection('user_purchases').add({
                    'userId': user.uid,
                    'userEmail': user.email ?? 'unknown@email.com',
                    'membershipType': 'Pro',
                    'purchaseTimestamp': FieldValue.serverTimestamp(),
                  }).then((_) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.paymentSuccess,
                      arguments: 'Pro',
                    );
                  }).catchError((error) {
                    Logger.error('Error purchasing Pro', error);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${AppStrings.errorOccurred}: $error')),
                      );
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('You need to be logged in')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    String? price,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (price != null)
                          Text(
                            price,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
