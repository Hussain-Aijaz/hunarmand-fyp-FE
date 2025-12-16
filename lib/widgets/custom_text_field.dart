// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final Widget? prefixIcon;
//   final bool isPassword;
//   final bool isPasswordVisible;
//   final VoidCallback? onTogglePassword;
//   final String? Function(String?)? validator;
//   final bool autoValidate;
//
//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.prefixIcon,
//     this.isPassword = false,
//     this.isPasswordVisible = false,
//     this.onTogglePassword,
//     this.validator,
//     this.autoValidate = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: const Color(0xFFE7E6E9),
//                 width: 1,
//               ),
//             ),
//           ),
//           child: Row(
//             children: [
//               if (prefixIcon != null) ...[
//                 prefixIcon!,
//                 const SizedBox(width: 12),
//               ],
//               Expanded(
//                 child: TextFormField(  // Changed from TextField to TextFormField
//                   controller: controller,
//                   obscureText: isPassword && !isPasswordVisible,
//                   validator: validator,
//                   autovalidateMode: autoValidate
//                       ? AutovalidateMode.onUserInteraction
//                       : AutovalidateMode.disabled,
//                   decoration: InputDecoration(
//                     hintText: hintText,
//                     hintStyle: TextStyle(
//                       color: const Color(0xFF7D8695),
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                     errorStyle: const TextStyle(
//                       fontSize: 12,
//                       height: 0.8,
//                     ),
//                   ),
//                 ),
//               ),
//               if (isPassword && onTogglePassword != null) ...[
//                 IconButton(
//                   onPressed: onTogglePassword,
//                   icon: Icon(
//                     isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                     color: const Color(0xFF7D8695),
//                     size: 20,
//                   ),
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         // Space for error message
//         if (validator != null) const SizedBox(height: 4),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePassword;
  final String? Function(String?)? validator;
  final bool autoValidate;
  final TextInputType? keyboardType; // ADD THIS
  final TextInputAction? textInputAction; // ADD THIS

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePassword,
    this.validator,
    this.autoValidate = false,
    this.keyboardType, // ADD THIS
    this.textInputAction, // ADD THIS
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFE7E6E9),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: TextFormField(
                  controller: controller,
                  obscureText: isPassword && !isPasswordVisible,
                  validator: validator,
                  autovalidateMode: autoValidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  keyboardType: keyboardType, // USE HERE
                  textInputAction: textInputAction, // USE HERE
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: const Color(0xFF7D8695),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    errorStyle: const TextStyle(
                      fontSize: 12,
                      height: 0.8,
                    ),
                  ),
                ),
              ),
              if (isPassword && onTogglePassword != null) ...[
                IconButton(
                  onPressed: onTogglePassword,
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF7D8695),
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
        ),
        // Space for error message
        if (validator != null) const SizedBox(height: 4),
      ],
    );
  }
}