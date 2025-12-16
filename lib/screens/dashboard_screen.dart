// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hunarmand/screens/profile_screen.dart';
// import 'package:provider/provider.dart';
// import '../constants/colors.dart';
// import '../providers/auth_provider.dart';
// import '../widgets/stats_card.dart';
// import 'active_tasks_screen.dart';
// import 'provider_tasks_screen.dart';
// import '../services/user_service.dart';
//
// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//   //  final UserService userService = UserService();
//     final bool isProvider = authProvider.isProvider;
//     final String userName = authProvider.currentUser?.name ?? 'User';
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFEFF),
//       appBar: _buildAppBar(context),
//       body: _buildBody(context, isProvider),
//     );
//   }
//
//   AppBar _buildAppBar(BuildContext context) {
//     // final UserService userService = UserService();
//     // final String userName = userService.currentUser?.name ?? 'User';
//     //final bool isProvider = userService.isProvider;
//
//     return AppBar(
//       backgroundColor: AppColors.white,
//       elevation: 0,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 16),
//         child: GestureDetector(
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
//           },
//           child: CircleAvatar(
//             radius: 14.5,
//             backgroundColor: Colors.grey[300],
//             child: ClipOval(
//               child: SvgPicture.asset(
//                 'assets/profileSvg.svg',
//                 width: 29,
//                 height: 28.41,
//                 fit: BoxFit.cover,
//                 placeholderBuilder: (BuildContext context) => Container(
//                   width: 29,
//                   height: 28.41,
//                   color: AppColors.primaryBlue,
//                   child: const Icon(Icons.person, color: AppColors.white, size: 16),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       title: Container(
//         margin: const EdgeInsets.only(left: 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'WELCOME TO HUNARMAND',
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w700,
//                 fontSize: 12,
//                 height: 1.25,
//                 color: AppColors.black,
//               ),
//             ),
//             Text(
//               'Hello, $userName',
//               style: const TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 10,
//                 color: AppColors.textGray,
//               ),
//             ),
//           ],
//         ),
//       ),
//       centerTitle: false,
//       actions: [
//         IconButton(
//           onPressed: () => print('Notification pressed'),
//           icon: SvgPicture.asset(
//             'assets/notificationIcon.svg',
//             width: 17,
//             height: 19.98,
//             placeholderBuilder: (BuildContext context) => Icon(Icons.notifications, size: 20, color: AppColors.primaryBlue),
//           ),
//         ),
//         const SizedBox(width: 8),
//       ],
//     );
//   }
//
//   Widget _buildBody(BuildContext context, bool isProvider) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Role-specific greeting
//           Text(
//             isProvider ? 'Welcome, Service Provider!' : 'Hello, Task Seeker!',
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textGray),
//           ),
//
//           const SizedBox(height: 15),
//           _buildRecentActivitiesSection(context, isProvider),
//           const SizedBox(height: 20),
//           _buildStatsCards(isProvider),
//           const SizedBox(height: 20),
//           _buildMyWorksCard(isProvider,context),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecentActivitiesSection(BuildContext context, bool isProvider) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           isProvider ? 'Recent Tasks' : 'Recent Activities',
//           style: const TextStyle(
//             fontFamily: 'Plus Jakarta Sans',
//             fontWeight: FontWeight.w500,
//             fontSize: 16.93,
//             color: AppColors.black,
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             // Navigate to appropriate screen based on role
//             if (isProvider) {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const ProviderTasksScreen()));
//             } else {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const ActiveTasksScreen()));
//             }
//           },
//           child: Container(
//             width: 57.5,
//             height: 11.75,
//             child: Center(
//               child: SvgPicture.asset('assets/viewAllSvg.svg', width: 12, height: 12),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatsCards(bool isProvider) {
//     return Column(
//       children: [
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: StatsCard(
//                 count: isProvider ? '24' : '12',
//                 title: isProvider ? 'Tasks Completed' : 'Work Posted',
//                 onButtonPressed: () {
//                   print(isProvider ? 'Tasks Completed pressed' : 'Work Posted pressed');
//                 },
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: StatsCard(
//                 count: isProvider ? '8' : '15',
//                 title: isProvider ? 'Active Bids' : 'Completed',
//                 onButtonPressed: () {
//                   print(isProvider ? 'Active Bids pressed' : 'Completed pressed');
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMyWorksCard(bool isProvider, BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 120,
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
//       ),
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       SvgPicture.asset(
//                         'assets/taskIconSvg.svg',
//                         width: 22.89,
//                         height: 26.67,
//                         placeholderBuilder: (BuildContext context) => Icon(Icons.work_outline, size: 26, color: AppColors.primaryBlue),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         isProvider ? 'My Tasks' : 'My Works',
//                         style: const TextStyle(
//                           fontFamily: 'Plus Jakarta Sans',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18,
//                           color: AppColors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         isProvider ? 'Manage Tasks' : 'Approve/Reject',
//                         style: const TextStyle(
//                           fontFamily: 'Plus Jakarta Sans',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 12.63,
//                           color: Color(0xFF8B8B8B),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       isProvider ? '156' : '345',
//                       style: const TextStyle(
//                         fontFamily: 'Plus Jakarta Sans',
//                         fontWeight: FontWeight.w500,
//                         fontSize: 12.63,
//                         color: AppColors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       isProvider ? 'Requests' : 'Tasks',
//                       style: const TextStyle(
//                         fontFamily: 'Plus Jakarta Sans',
//                         fontWeight: FontWeight.w400,
//                         fontSize: 12.63,
//                         color: Color(0xFF8B8B8B),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 12,
//             right: 12,
//             child: GestureDetector(
//               onTap: () {
//                 // Navigate based on role
//                 if (isProvider) {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ProviderTasksScreen()));
//                 } else {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ActiveTasksScreen()));
//                 }
//               },
//               child: Container(
//                 child: Center(
//                   child: SvgPicture.asset('assets/cardFrowardSvg.svg', width: 21.7, height: 21.26),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:hunarmand/screens/profile_screen.dart';
import '../constants/colors.dart';
import '../widgets/stats_card.dart';
import 'active_tasks_screen.dart';
import 'provider_tasks_screen.dart';
import '../providers/auth_provider.dart'; // IMPORTANT: Use AuthProvider

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use AuthProvider instead of UserService
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isProvider = authProvider.isProvider;
    final String userName = authProvider.currentUser?.name ?? 'User';

    return Scaffold(
      backgroundColor: const Color(0xFFFAFEFF),
      appBar: _buildAppBar(context, userName, isProvider),
      body: _buildBody(context, isProvider, userName),
    );
  }

  AppBar _buildAppBar(BuildContext context, String userName, bool isProvider) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          child: CircleAvatar(
            radius: 14.5,
            backgroundColor: Colors.grey[300],
            child: ClipOval(
              child: SvgPicture.asset(
                'assets/profileSvg.svg',
                width: 29,
                height: 28.41,
                fit: BoxFit.cover,
                placeholderBuilder: (BuildContext context) => Container(
                  width: 29,
                  height: 28.41,
                  color: AppColors.primaryBlue,
                  child: const Icon(Icons.person, color: AppColors.white, size: 16),
                ),
              ),
            ),
          ),
        ),
      ),
      title: Container(
        margin: const EdgeInsets.only(left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WELCOME TO HUNARMAND',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                height: 1.25,
                color: AppColors.black,
              ),
            ),
            Text(
              'Hello, $userName', // Now this will show actual name
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: AppColors.textGray,
              ),
            ),
            // Optional: Add role badge
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isProvider
                    ? AppColors.primaryGreen.withOpacity(0.1)
                    : AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isProvider ? 'Provider' : 'Seeker',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w600,
                  color: isProvider ? AppColors.primaryGreen : AppColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () => print('Notification pressed'),
          icon: SvgPicture.asset(
            'assets/notificationIcon.svg',
            width: 17,
            height: 19.98,
            placeholderBuilder: (BuildContext context) => Icon(
              Icons.notifications,
              size: 20,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(BuildContext context, bool isProvider, String userName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role-specific greeting with actual user name
          Text(
            isProvider ? 'Welcome, $userName!' : 'Hello, $userName!',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isProvider ? 'Service Provider Dashboard' : 'Task Seeker Dashboard',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textGray,
            ),
          ),

          const SizedBox(height: 15),
          _buildRecentActivitiesSection(context, isProvider),
          const SizedBox(height: 20),
          _buildStatsCards(isProvider),
          const SizedBox(height: 20),
          _buildMyWorksCard(isProvider, context),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesSection(BuildContext context, bool isProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isProvider ? 'Recent Tasks' : 'Recent Activities',
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w500,
            fontSize: 16.93,
            color: AppColors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to appropriate screen based on role
            if (isProvider) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProviderTasksScreen()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActiveTasksScreen()),
              );
            }
          },
          child: Container(
            width: 57.5,
            height: 11.75,
            child: Center(
              child: SvgPicture.asset(
                'assets/viewAllSvg.svg',
                width: 12,
                height: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(bool isProvider) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                count: isProvider ? '24' : '12',
                title: isProvider ? 'Tasks Completed' : 'Work Posted',
                onButtonPressed: () {
                  print(isProvider ? 'Tasks Completed pressed' : 'Work Posted pressed');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatsCard(
                count: isProvider ? '8' : '15',
                title: isProvider ? 'Active Bids' : 'Completed',
                onButtonPressed: () {
                  print(isProvider ? 'Active Bids pressed' : 'Completed pressed');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMyWorksCard(bool isProvider, BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/taskIconSvg.svg',
                        width: 22.89,
                        height: 26.67,
                        placeholderBuilder: (BuildContext context) => Icon(
                          Icons.work_outline,
                          size: 26,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isProvider ? 'My Tasks' : 'My Works',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isProvider ? 'Manage Tasks' : 'Approve/Reject',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.63,
                          color: Color(0xFF8B8B8B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      isProvider ? '156' : '345',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.63,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isProvider ? 'Requests' : 'Tasks',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.63,
                        color: Color(0xFF8B8B8B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                // Navigate based on role
                if (isProvider) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProviderTasksScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ActiveTasksScreen()),
                  );
                }
              },
              child: Container(
                child: Center(
                  child: SvgPicture.asset(
                    'assets/cardFrowardSvg.svg',
                    width: 21.7,
                    height: 21.26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}