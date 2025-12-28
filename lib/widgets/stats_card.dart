import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';

class StatsCard extends StatelessWidget {
  final String count;
  final String title;
  final VoidCallback onButtonPressed;
  final Color? color;

  const StatsCard({
    super.key,
    required this.count,
    required this.title,
    required this.onButtonPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primaryBlue;
    return Container(
      width: 167,
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.42),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 30.69,
                    height: 1.25,
                    letterSpacing: 0,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.12,
                    letterSpacing: 0,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),

          // Top Right Button
          // Positioned(
          //   top: 12,
          //   right: 12,
          //   child: GestureDetector(
          //     onTap: () {
          //       print('My Works card forward button pressed');
          //     },
          //     child: Container(
          //
          //       child: Center(
          //         child: SvgPicture.asset(
          //           'assets/cardFrowardSvg.svg',
          //           width: 21.7,
          //           height: 21.26,
          //
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}