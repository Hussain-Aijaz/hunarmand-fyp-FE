import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFEFF),
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: const Text(
        'Profile',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppColors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Profile Header
          _buildProfileHeader(),

          const SizedBox(height: 40),

          // Profile Cards
          _buildProfileCards(context),

          const SizedBox(height: 40),

          // Copyright Section
          _buildCopyrightSection(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Profile Image
        Container(
          width: 67,
          height: 67,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(33.5),
          ),
          child: ClipOval(
            child: SvgPicture.asset(
              'assets/profile_icon.svg',
              width: 67,
              height: 67,
              fit: BoxFit.cover,
              placeholderBuilder: (BuildContext context) => const Icon(
                Icons.person,
                size: 30,
                color: AppColors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Name
        const Text(
          'Anas Sar',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w500,
            fontSize: 22.48,
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 4),

        // ID
        const Text(
          'ID: anassar',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            fontSize: 13.23,
            height: 1.0,
            letterSpacing: 0,
            color: Color(0xFF818181),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCards(BuildContext context) {
    final List<ProfileItem> profileItems = [
      ProfileItem(
        label: 'Security',
        svgIcon: 'assets/securitySVG.svg',
      ),
      ProfileItem(
        label: 'Change Password',
        svgIcon: 'assets/changePassword.svg',
      ),
      ProfileItem(
        label: 'Change Language',
        svgIcon: 'assets/changeLanguage.svg',
      ),
      ProfileItem(
        label: 'Order History',
        svgIcon: 'assets/orderHistory.svg',
      ),
      ProfileItem(
        label: 'Order Review',
        svgIcon: 'assets/orderHistory.svg',
      ),
      ProfileItem(
        label: 'Contact Detail',
        svgIcon: 'assets/contactDetails.svg',
      ),
      ProfileItem(
        label: 'Log Out',
        svgIcon: 'assets/logoutIcon.svg',
      ),
    ];

    return Column(
      children: profileItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildProfileCard(
            label: item.label,
            svgIcon: item.svgIcon,
            onTap: () {
              _handleItemTap(item.label, context);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfileCard({
    required String label,
    required String svgIcon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity, // This will make cards take full width
      height: 51,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.08),
            blurRadius: 8.9,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  svgIcon,
                  width: 15,
                  height: 18.44,
                  placeholderBuilder: (BuildContext context) => Icon(
                    Icons.settings,
                    size: 18,
                    color: AppColors.primaryBlue,
                  ),
                ),

                const SizedBox(width: 16),

                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.0,
                    letterSpacing: 0,
                    color: Color(0xFF4F4F4F),
                  ),
                ),

                const Spacer(),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF4F4F4F),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCopyrightSection() {
    return Column(
      children: [
        const Text(
          'Copyright Hunarmand',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1.0,
            letterSpacing: 0,
            color: Color(0xFF4F4F4F),
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'All Rights Reserved',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 1.0,
            letterSpacing: 0,
            color: Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  void _handleItemTap(String label, BuildContext context) {
    switch (label) {
      case 'Security':
        print('Security pressed');
        break;
      case 'Change Password':
        print('Change Password pressed');
        break;
      case 'Change Language':
        print('Change Language pressed');
        break;
      case 'Order History':
        print('Order History pressed');
        break;
      case 'Order Review':
        print('Order Review pressed');
        break;
      case 'Contact Detail':
        print('Contact Detail pressed');
        break;
      case 'Log Out':
        _logout(context);
        //_showLogoutDialog(context);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context);
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Simple logout function
  Future<void> _logout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Simple confirmation dialog (optional)
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Perform logout
      await authProvider.logoutUser();

      // Navigate to login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false, // Remove all previous routes
      );
    }
  }


  void _performLogout(BuildContext context) {
    print('User logged out');
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class ProfileItem {
  final String label;
  final String svgIcon;

  ProfileItem({
    required this.label,
    required this.svgIcon,
  });
}