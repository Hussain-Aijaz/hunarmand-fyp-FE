import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hunarmand/screens/register_screen.dart';
import '../widgets/custom_button.dart';
import '../constants/colors.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Section
            _buildLogoSection(),

            // Welcome Text
            _buildWelcomeText(),

            const SizedBox(height: 90),

            // Buttons Section
            _buildButtonsSection(context),

            // Divider Section
            _buildDividerSection(),

            // Service Provider Button
            _buildServiceProviderButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/mainLockOnSvg.svg',
          width: 100,
          height: 100,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return const Text(
      'Welcome',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 32,
        height: 1.0,
        letterSpacing: 0,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildButtonsSection(BuildContext context) {
    return Column(
      children: [
        // Login Button
        CustomButton(
          width: 326,
          height: 54,
          backgroundColor: AppColors.primaryBlue,
          borderRadius: 10,
          child: const Text(
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
              height: 1.16,
              letterSpacing: 0,
              color: AppColors.white,
            ),
          ),
          // In the Login Button section, update onPressed:
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),

        const SizedBox(height: 12),

        // Sign Up Button
        CustomButton(
          width: 326,
          height: 54,
          backgroundColor: AppColors.white,
          borderColor: AppColors.primaryGreen,
          borderRadius: 10,
          child: const Text(
            'Create New Account',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
              height: 1.16,
              letterSpacing: 0,
              color: AppColors.primaryGreen,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  RegisterScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDividerSection() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColors.dividerGray,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.dividerGray,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColors.dividerGray,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildServiceProviderButton(BuildContext context) {
    return CustomButton(
      width: 326,
      height: 53,
      backgroundColor: AppColors.transparentGreen,
      borderRadius: 10,
      child: const Text(
        'Register yourself',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.16,
          letterSpacing: 0,
          color: AppColors.primaryGreen,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  RegisterScreen()),
        );
      },
    );
  }
}