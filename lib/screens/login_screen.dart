// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hunarmand/screens/register_screen.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_text_field.dart';
// import '../constants/colors.dart';
// import 'dashboard_screen.dart';
// import '../models/user_model.dart';
// import '../services/user_service.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _isPasswordVisible = false;
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   final UserService _userService = UserService();
//
//   @override
//   void initState() {
//     super.initState();
//     // Pre-fill with test data for demo
//     _emailController.text = 'test@seeker.com';
//     _passwordController.text = '1234';
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 const SizedBox(height: 60),
//                 _buildLogoSection(),
//                 const SizedBox(height: 30),
//                 _buildWelcomeText(),
//                 const SizedBox(height: 40),
//
//                 // Email Field
//                 CustomTextField(
//                   controller: _emailController,
//                   hintText: 'Email',
//                   prefixIcon: SvgPicture.asset(
//                     'assets/emailEnvelop.svg',
//                     width: 16,
//                     height: 12.8,
//                     color: AppColors.dividerGray,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!_isValidEmail(value)) {
//                       return 'Please enter a valid email address';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Password Field
//                 CustomTextField(
//                   controller: _passwordController,
//                   hintText: 'Password',
//                   isPassword: true,
//                   isPasswordVisible: _isPasswordVisible,
//                   onTogglePassword: () {
//                     setState(() {
//                       _isPasswordVisible = !_isPasswordVisible;
//                     });
//                   },
//                   prefixIcon: SvgPicture.asset(
//                     'assets/passwordLock.svg',
//                     width: 16,
//                     height: 12.8,
//                     color: AppColors.dividerGray,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     if (value.length < 4) {
//                       return 'Password must be at least 4 characters';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 // Login Button
//                 _isLoading
//                     ? _buildLoadingButton()
//                     : CustomButton(
//                   width: double.infinity,
//                   height: 54,
//                   backgroundColor: AppColors.primaryBlue,
//                   borderRadius: 10,
//                   child: const Text(
//                     'Login',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 17,
//                       height: 1.16,
//                       letterSpacing: 0,
//                       color: AppColors.white,
//                     ),
//                   ),
//                   onPressed: () {
//                     _login();
//                   },
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Demo Login Buttons
//                 _buildDemoButtons(),
//
//                 const SizedBox(height: 20),
//
//                 _buildDividerSection(),
//                 const SizedBox(height: 40),
//                 _buildGoogleButton(),
//                 const SizedBox(height: 40),
//                 _buildRegisterSection(context),
//                 const SizedBox(height: 20),
//                 _buildServiceProviderButton(),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _login() {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       // Simulate API call delay
//       Future.delayed(const Duration(seconds: 1), () {
//         setState(() {
//           _isLoading = false;
//         });
//
//         final email = _emailController.text.trim();
//         final password = _passwordController.text.trim();
//
//         // Login logic with test accounts
//         if ((email == 'test@seeker.com' || email == 'test@provider.com') && password == '1234') {
//           // Determine role based on email
//           final String role = email.contains('provider') ? 'provider' : 'seeker';
//           final String name = role == 'seeker' ? 'John Seeker' : 'Sarah Provider';
//
//           // Create user object
//           final user = User(
//             id: role == 'seeker' ? '1' : '2',
//             name: name,
//             email: email,
//             role: role,
//             createdAt: DateTime.now(),
//           );
//
//           // Set user in service
//           _userService.setUser(user);
//
//           // Navigate to dashboard
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => DashboardScreen(),
//             ),
//           );
//
//           _showSuccessDialog(role);
//         } else {
//           _showErrorDialog('Invalid email or password. Please try again.');
//         }
//       });
//     } else {
//       _showValidationErrorDialog();
//     }
//   }
//
//   // Demo login methods for quick testing
//   Widget _buildDemoButtons() {
//     return Column(
//       children: [
//         const Text(
//           'Quick Login:',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//             color: AppColors.textGray,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             // Seeker Demo Button
//             ElevatedButton(
//               onPressed: () {
//                 _emailController.text = 'test@seeker.com';
//                 _passwordController.text = '1234';
//                 _login();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryBlue,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               ),
//               child: const Text(
//                 'Seeker Demo',
//                 style: TextStyle(fontSize: 12),
//               ),
//             ),
//
//             // Provider Demo Button
//             ElevatedButton(
//               onPressed: () {
//                 _emailController.text = 'test@provider.com';
//                 _passwordController.text = '1234';
//                 _login();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               ),
//               child: const Text(
//                 'Provider Demo',
//                 style: TextStyle(fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoadingButton() {
//     return Container(
//       width: double.infinity,
//       height: 54,
//       decoration: BoxDecoration(
//         color: AppColors.primaryBlue.withOpacity(0.7),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: const Center(
//         child: SizedBox(
//           width: 20,
//           height: 20,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
//
//   bool _isValidEmail(String email) {
//     final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
//     return emailRegex.hasMatch(email);
//   }
//
//   void _showSuccessDialog(String role) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: Row(
//             children: [
//               Icon(
//                 Icons.check_circle,
//                 color: Colors.green,
//                 size: 24,
//               ),
//               SizedBox(width: 8),
//               Text(
//                 'Login Successful',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//           content: Text(
//             'Welcome! You are logged in as a ${role.toUpperCase()}',
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (context) => DashboardScreen()),
//                 );
//               },
//               child: Text(
//                 'Continue',
//                 style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: Row(
//             children: [
//               Icon(Icons.error, color: Colors.red, size: 24),
//               SizedBox(width: 8),
//               Text('Login Failed', style: TextStyle(fontWeight: FontWeight.w600)),
//             ],
//           ),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Try Again', style: TextStyle(color: AppColors.primaryBlue)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showValidationErrorDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: Row(
//             children: [
//               Icon(Icons.warning, color: Colors.orange, size: 24),
//               SizedBox(width: 8),
//               Text('Validation Error', style: TextStyle(fontWeight: FontWeight.w600)),
//             ],
//           ),
//           content: Text('Please fix the errors in the form before submitting.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('OK', style: TextStyle(color: AppColors.primaryBlue)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildLogoSection() {
//     return SvgPicture.asset(
//       'assets/mainLockOnSvg.svg',
//       width: 100,
//       height: 100,
//     );
//   }
//
//   Widget _buildWelcomeText() {
//     return Column(
//       children: [
//         Text(
//           'Welcome back!',
//           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: AppColors.black),
//         ),
//         SizedBox(height: 8),
//         Text(
//           'Login to your account.',
//           style: TextStyle(
//             fontFamily: 'Plus Jakarta Sans',
//             fontWeight: FontWeight.w400,
//             fontSize: 16,
//             color: Color(0xFFB5B5B5),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDividerSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Row(
//         children: [
//           Expanded(child: Divider(color: AppColors.dividerGray, thickness: 1)),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text('OR', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.dividerGray)),
//           ),
//           Expanded(child: Divider(color: AppColors.dividerGray, thickness: 1)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGoogleButton() {
//     return Container(
//       width: 327,
//       height: 54,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFF535353).withOpacity(0.8), width: 1),
//       ),
//       child: ElevatedButton(
//         onPressed: () => print('Google login pressed'),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           elevation: 0,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/googlePNG.png', width: 20, height: 20),
//             SizedBox(width: 12),
//             Text('Continue with Google', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.black)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRegisterSection(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           'Don\'t have an account?',
//           style: TextStyle(
//             fontFamily: 'Plus Jakarta Sans',
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//             color: AppColors.black,
//           ),
//         ),
//         SizedBox(width: 4),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(isServiceProvider: false)));
//           },
//           child: Text(
//             'Register',
//             style: TextStyle(
//               fontFamily: 'Plus Jakarta Sans',
//               fontWeight: FontWeight.w500,
//               fontSize: 14,
//               color: AppColors.primaryGreen,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildServiceProviderButton() {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(isServiceProvider: true)));
//       },
//       child: Text(
//         'Register as Service Provider',
//         style: TextStyle(
//           fontFamily: 'Plus Jakarta Sans',
//           fontWeight: FontWeight.w600,
//           fontSize: 16,
//           color: AppColors.primaryGreen,
//         ),
//       ),
//     );
//   }
// }





/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hunarmand/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:hunarmand/screens/register_screen.dart';
import 'package:hunarmand/screens/dashboard_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Optional: pre-fill test credentials
    // _emailController.text = 'jemenda05@yopmail.com';
    // _passwordController.text = 'Madrid1!!!';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Check if login was successful
      if (authProvider.loginResponse?.token != null &&
          authProvider.errorMessage == null) {
        print('✅ Login successful, navigating to dashboard...');

        // Navigate to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      }
      // Error is shown automatically in the error widget
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                _buildLogoSection(),
                const SizedBox(height: 30),
                _buildWelcomeText(),
                const SizedBox(height: 40),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  prefixIcon: SvgPicture.asset(
                    'assets/emailEnvelop.svg',
                    width: 16,
                    height: 12.8,
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
                  prefixIcon: SvgPicture.asset(
                    'assets/passwordLock.svg',
                    width: 16,
                    height: 12.8,
                    color: AppColors.dividerGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Error Message Display with close button
                if (authProvider.errorMessage != null)
                  _buildErrorWidgetWithClose(authProvider.errorMessage!, authProvider),

                const SizedBox(height: 20),

                // Login Button
                authProvider.isLoading
                    ? _buildLoadingButton()
                    : CustomButton(
                  width: double.infinity,
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
                  onPressed: _login,
                ),

                const SizedBox(height: 20),

                _buildDividerSection(),
                const SizedBox(height: 20),
                _buildGoogleButton(),
                const SizedBox(height: 40),
                _buildRegisterSection(context),
                const SizedBox(height: 20),
                _buildServiceProviderButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidgetWithClose(String errorMessage, AuthProvider authProvider) {
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
          IconButton(
            icon: Icon(Icons.close, size: 16, color: Colors.red.shade600),
            onPressed: () => authProvider.clearError(),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.7),
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

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
  }

  Widget _buildLogoSection() {
    return SvgPicture.asset(
      'assets/mainLockOnSvg.svg',
      width: 100,
      height: 100,
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Welcome back!',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: AppColors.black),
        ),
        SizedBox(height: 8),
        Text(
          'Login to your account.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xFFB5B5B5),
          ),
        ),
      ],
    );
  }

  Widget _buildDividerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.dividerGray, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('OR', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.dividerGray)),
          ),
          Expanded(child: Divider(color: AppColors.dividerGray, thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildGoogleButton() {
    return Container(
      width: 327,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF535353).withOpacity(0.8), width: 1),
      ),
      child: ElevatedButton(
        onPressed: () => print('Google login pressed'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/googlePNG.png', width: 20, height: 20),
            SizedBox(width: 12),
            Text('Continue with Google', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.black,
          ),
        ),
        SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          },
          child: Text(
            'Register',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceProviderButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      },
      child: Text(
        'Register as Service Provider',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}


 */


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hunarmand/screens/welcome_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:hunarmand/screens/register_screen.dart';
import 'package:hunarmand/screens/dashboard_screen.dart';
import '../services/location_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Add location service instance
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    // Optional: pre-fill test credentials
    // _emailController.text = 'jemenda05@yopmail.com';
    // _passwordController.text = 'Madrid1!!!';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper method to check location permission
  Future<bool> _checkLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showLocationServiceDialog(
        "Location Services Disabled",
        "Please enable location services to use this app. Location is required for better user experience.",
            () => Geolocator.openLocationSettings(),
      );
      return false;
    }

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Request permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _showLocationPermissionDialog(
          "Location Permission Required",
          "Location permission is required to use this app. Please grant location permission to continue.",
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _showLocationPermissionDialog(
        "Location Permission Permanently Denied",
        "Location permission is permanently denied. Please enable it from app settings to continue.",
            () => openAppSettings(),
      );
      return false;
    }

    // Permission granted
    return true;
  }

  // Dialog for location service
  Future<void> _showLocationServiceDialog(
      String title,
      String message,
      VoidCallback? onSettingsPressed,
      ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (onSettingsPressed != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onSettingsPressed();
              },
              child: const Text('Open Settings'),
            ),
        ],
      ),
    );
  }

  // Dialog for location permission
  Future<void> _showLocationPermissionDialog(
      String title,
      String message, [
        VoidCallback? onSettingsPressed,
      ]) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (onSettingsPressed != null)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onSettingsPressed != null) {
                onSettingsPressed();
              } else {
                Geolocator.openAppSettings();
              }
            },
            child: Text(onSettingsPressed != null ? 'Open Settings' : 'OK'),
          ),
        ],
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // First check location permission
      bool hasLocationPermission = await _checkLocationPermission();

      if (!hasLocationPermission) {
        // Don't proceed with login if location permission is not granted
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Check if login was successful
      if (authProvider.loginResponse?.token != null &&
          authProvider.errorMessage == null) {
        print('✅ Login successful, navigating to dashboard...');

        // Optional: Get location after successful login
        try {
          Map<String, double>? location = await _locationService.getCurrentLocation();
          if (location != null) {
            print('📍 User location: ${location['latitude']}, ${location['longitude']}');
            // You can save this location to your backend or local storage
          }
        } catch (e) {
          print('⚠️ Failed to get location after login: $e');
        }

        // Navigate to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      }
      // Error is shown automatically in the error widget
    }
  }

  // Alternative login method with location check as separate step
  void _loginWithLocationCheck() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Check location permission first
      bool hasLocationPermission = await _checkLocationPermission();

      if (!hasLocationPermission) {
        // Show error or dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable location permission to login'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Let the authProvider handle loading state
      await authProvider.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (authProvider.loginResponse?.token != null &&
          authProvider.errorMessage == null) {
        print('✅ Login successful, navigating to dashboard...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      }
    }
  }
  // Optional: Get user location after login
  Future<void> _getUserLocation() async {
    try {
      Map<String, double>? location = await _locationService.getCurrentLocation();
      if (location != null) {
        print('📍 User location obtained after login');
        // Save to backend or local storage as needed
      }
    } catch (e) {
      print('⚠️ Error getting user location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                _buildLogoSection(),
                const SizedBox(height: 30),
                _buildWelcomeText(),
                const SizedBox(height: 40),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  prefixIcon: SvgPicture.asset(
                    'assets/emailEnvelop.svg',
                    width: 16,
                    height: 12.8,
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
                  prefixIcon: SvgPicture.asset(
                    'assets/passwordLock.svg',
                    width: 16,
                    height: 12.8,
                    color: AppColors.dividerGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Error Message Display with close button
                if (authProvider.errorMessage != null)
                  _buildErrorWidgetWithClose(authProvider.errorMessage!, authProvider),

                const SizedBox(height: 20),

                // Login Button - Updated to use _loginWithLocationCheck
                authProvider.isLoading
                    ? _buildLoadingButton()
                    : CustomButton(
                  width: double.infinity,
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
                  onPressed: _loginWithLocationCheck, // Changed to new method
                ),

                const SizedBox(height: 20),

                _buildDividerSection(),
                const SizedBox(height: 20),
                _buildGoogleButton(),
                const SizedBox(height: 40),
                _buildRegisterSection(context),
                const SizedBox(height: 20),
                _buildServiceProviderButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidgetWithClose(String errorMessage, AuthProvider authProvider) {
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
          IconButton(
            icon: Icon(Icons.close, size: 16, color: Colors.red.shade600),
            onPressed: () => authProvider.clearError(),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.7),
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

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
  }

  Widget _buildLogoSection() {
    return SvgPicture.asset(
      'assets/mainLockOnSvg.svg',
      width: 100,
      height: 100,
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Welcome back!',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: AppColors.black),
        ),
        SizedBox(height: 8),
        Text(
          'Login to your account.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xFFB5B5B5),
          ),
        ),
      ],
    );
  }

  Widget _buildDividerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.dividerGray, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('OR', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.dividerGray)),
          ),
          Expanded(child: Divider(color: AppColors.dividerGray, thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildGoogleButton() {
    return Container(
      width: 327,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF535353).withOpacity(0.8), width: 1),
      ),
      child: ElevatedButton(
        onPressed: () {
          // You might want to add location check for Google login too
          _handleGoogleLogin();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/googlePNG.png', width: 20, height: 20),
            SizedBox(width: 12),
            Text('Continue with Google', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.black)),
          ],
        ),
      ),
    );
  }

  // Add this method for Google login with location check
  Future<void> _handleGoogleLogin() async {
    // First check location permission
    bool hasLocationPermission = await _checkLocationPermission();

    if (!hasLocationPermission) {
      return;
    }

    // Proceed with Google login logic here
    print('Google login pressed');
  }

  Widget _buildRegisterSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.black,
          ),
        ),
        SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          },
          child: Text(
            'Register',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceProviderButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      },
      child: Text(
        'Register as Service Provider',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}