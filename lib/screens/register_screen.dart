
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utlis/contants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../constants/colors.dart';
import 'login_screen.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Role selection
  String _selectedRole = UserRole.seeker; // Default to seeker

  @override
  void initState() {
    super.initState();
    // Clear any previous error messages when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).clearError();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final url = '${ApiConstants.userBaseUrl}${ApiConstants.registerEndpoint}';
      print('🔗 Attempting to connect to: $url');
      print('👤 Role Selected: $_selectedRole');

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.registerUser(
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        phone: _phoneController.text.trim(),
        role: _selectedRole, // Pass selected role
      );

      // Check if registration was successful
      if (authProvider.registerResponse?.msg != null &&
          authProvider.registerResponse?.errors == null) {
        // Show success message and navigate to LoginScreen
        _showSuccessDialog();
      } else if (authProvider.errorMessage != null) {
        // Show error dialog
        _showErrorDialog(authProvider.errorMessage!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    // Define isProvider here
    final bool isProviderSelected = _selectedRole == UserRole.provider;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Back Button
                _buildBackButton(),

                const SizedBox(height: 30),

                // Logo Section
                _buildLogoSection(),

                const SizedBox(height: 30),

                // Register Text
                _buildRegisterText(),

                const SizedBox(height: 40),

                // Role Selection
                _buildRoleSelection(),

                const SizedBox(height: 20),

                // Name Field
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Full Name',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    size: 20,
                    color: AppColors.dividerGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Phone Number Field
                CustomTextField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    size: 20,
                    color: AppColors.dividerGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                    if (digitsOnly.length < 10) {
                      return 'Phone number must be at least 10 digits';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    size: 20,
                    color: AppColors.dividerGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!_isValidEmail(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onTogglePassword: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    size: 20,
                    color: AppColors.dividerGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Confirm Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  isPassword: true,
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onTogglePassword: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    size: 20,
                    color: AppColors.dividerGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Error Message Display
                if (authProvider.errorMessage != null)
                  _buildErrorWidget(authProvider.errorMessage!),

                const SizedBox(height: 20),

                // Role-specific Info Banner
                if (isProviderSelected) ...[
                  const SizedBox(height: 20),
                  _buildProviderInfo(),
                ],

                const SizedBox(height: 40),

                // Register Button
                authProvider.isLoading
                    ? _buildLoadingButton(isProviderSelected)
                    : CustomButton(
                  width: double.infinity,
                  height: 54,
                  backgroundColor: isProviderSelected ? AppColors.primaryGreen : AppColors.primaryBlue,
                  borderRadius: 10,
                  child: Text(
                    'Register as ${isProviderSelected ? 'Provider' : 'Seeker'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      height: 1.16,
                      letterSpacing: 0,
                      color: AppColors.white,
                    ),
                  ),
                  onPressed: _registerUser,
                ),

                const SizedBox(height: 40),

                // Already have an account section
                _buildLoginSection(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelection() {
    final bool isProviderSelected = _selectedRole == UserRole.provider;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Role',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textGray,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Seeker Option
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRole = UserRole.seeker;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedRole == UserRole.seeker
                        ? AppColors.primaryBlue.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedRole == UserRole.seeker
                          ? AppColors.primaryBlue
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        size: 32,
                        color: _selectedRole == UserRole.seeker
                            ? AppColors.primaryBlue
                            : Colors.grey[600],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Service Seeker',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _selectedRole == UserRole.seeker
                              ? AppColors.primaryBlue
                              : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Looking for services',
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedRole == UserRole.seeker
                              ? AppColors.primaryBlue
                              : Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Provider Option
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRole = UserRole.provider;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedRole == UserRole.provider
                        ? AppColors.primaryGreen.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedRole == UserRole.provider
                          ? AppColors.primaryGreen
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.business_center,
                        size: 32,
                        color: _selectedRole == UserRole.provider
                            ? AppColors.primaryGreen
                            : Colors.grey[600],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Service Provider',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _selectedRole == UserRole.provider
                              ? AppColors.primaryGreen
                              : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Offering services',
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedRole == UserRole.provider
                              ? AppColors.primaryGreen
                              : Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Selected role indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isProviderSelected
                ? AppColors.primaryGreen.withOpacity(0.1)
                : AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isProviderSelected
                  ? AppColors.primaryGreen.withOpacity(0.3)
                  : AppColors.primaryBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isProviderSelected ? Icons.business_center : Icons.person,
                size: 16,
                color: isProviderSelected ? AppColors.primaryGreen : AppColors.primaryBlue,
              ),
              const SizedBox(width: 8),
              Text(
                isProviderSelected ? 'Service Provider' : 'Service Seeker',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isProviderSelected ? AppColors.primaryGreen : AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 16,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return SvgPicture.asset(
      'assets/registerIconSVG.svg',
      width: 100,
      height: 100,
    );
  }

  Widget _buildRegisterText() {
    return Column(
      children: [
        Text(
          'Register Now',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Create your new account',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.0,
            letterSpacing: 0,
            color: const Color(0xFFB5B5B5),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primaryGreen,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You are registering as a Service Provider. Additional verification may be required to offer services.',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingButton(bool isProviderSelected) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: (isProviderSelected ? AppColors.primaryGreen : AppColors.primaryBlue).withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.black,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: Text(
            'Login',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.0,
              letterSpacing: 0,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  void _showSuccessDialog() {
    final bool isProviderSelected = _selectedRole == UserRole.provider;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: isProviderSelected ? AppColors.primaryGreen : AppColors.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Success',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            isProviderSelected
                ? 'Service Provider account created successfully! You will be redirected to login page.'
                : 'Service Seeker account created successfully! You will be redirected to login page.',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to LoginScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'Continue to Login',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Registration Failed',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}