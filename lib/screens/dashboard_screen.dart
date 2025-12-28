
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:hunarmand/screens/profile_screen.dart';
// import '../constants/colors.dart';
// import '../widgets/stats_card.dart';
// import 'active_tasks_screen.dart';
// import 'provider_tasks_screen.dart';
// import '../providers/auth_provider.dart'; // IMPORTANT: Use AuthProvider
//
// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Use AuthProvider instead of UserService
//     final authProvider = Provider.of<AuthProvider>(context);
//     final bool isProvider = authProvider.isProvider;
//     final String userName = authProvider.currentUser?.name ?? 'User';
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFEFF),
//       appBar: _buildAppBar(context, userName, isProvider),
//       body: _buildBody(context, isProvider, userName),
//     );
//   }
//
//   AppBar _buildAppBar(BuildContext context, String userName, bool isProvider) {
//     return AppBar(
//       backgroundColor: AppColors.white,
//       elevation: 0,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 16),
//         child: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const ProfileScreen()),
//             );
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
//                 fontSize: 14,
//                 height: 1.25,
//                 color: AppColors.black,
//               ),
//             ),
//             // Text(
//             //   'Hello, $userName', // Now this will show actual name
//             //   style: const TextStyle(
//             //     fontFamily: 'Plus Jakarta Sans',
//             //     fontWeight: FontWeight.w500,
//             //     fontSize: 10,
//             //     color: AppColors.textGray,
//             //   ),
//             // ),
//             // Optional: Add role badge
//             Container(
//               margin: const EdgeInsets.only(top: 2),
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//               decoration: BoxDecoration(
//                 color: isProvider
//                     ? AppColors.primaryGreen.withOpacity(0.1)
//                     : AppColors.primaryBlue.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 isProvider ? 'Provider' : 'Seeker',
//                 style: TextStyle(
//                   fontSize: 7,
//                   fontWeight: FontWeight.w600,
//                   color: isProvider ? AppColors.primaryGreen : AppColors.primaryBlue,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       centerTitle: false,
//       // actions: [
//       //   IconButton(
//       //     onPressed: () => print('Notification pressed'),
//       //     icon: SvgPicture.asset(
//       //       'assets/notificationIcon.svg',
//       //       width: 17,
//       //       height: 19.98,
//       //       placeholderBuilder: (BuildContext context) => Icon(
//       //         Icons.notifications,
//       //         size: 20,
//       //         color: AppColors.primaryBlue,
//       //       ),
//       //     ),
//       //   ),
//       //   const SizedBox(width: 8),
//       // ],
//     );
//   }
//
//   Widget _buildBody(BuildContext context, bool isProvider, String userName) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Role-specific greeting with actual user name
//           Text(
//             isProvider ? 'Welcome, $userName!' : 'Hello, $userName!',
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: AppColors.textGray,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             isProvider ? 'Service Provider Dashboard' : 'Service Seeker Dashboard',
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//               color: AppColors.textGray,
//             ),
//           ),
//
//           const SizedBox(height: 15),
//           _buildRecentActivitiesSection(context, isProvider),
//           const SizedBox(height: 20),
//           _buildMyWorksCard(isProvider, context),
//           const SizedBox(height: 16),
//           Text(
//             'Summary',//isProvider ? 'Recent Tasks' : 'Recent Activities',
//             style: const TextStyle(
//               fontFamily: 'Plus Jakarta Sans',
//               fontWeight: FontWeight.w500,
//               fontSize: 16.93,
//               color: AppColors.black,
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildStatsCards(isProvider),
//
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
//         // GestureDetector(
//         //   onTap: () {
//         //     // Navigate to appropriate screen based on role
//         //     if (isProvider) {
//         //       Navigator.push(
//         //         context,
//         //         MaterialPageRoute(builder: (context) => const ProviderTasksScreen()),
//         //       );
//         //     } else {
//         //       Navigator.push(
//         //         context,
//         //         MaterialPageRoute(builder: (context) => const ActiveTasksScreen()),
//         //       );
//         //     }
//         //   },
//         //   child: Container(
//         //     width: 57.5,
//         //     height: 11.75,
//         //     child: Center(
//         //       child: SvgPicture.asset(
//         //         'assets/viewAllSvg.svg',
//         //         width: 12,
//         //         height: 12,
//         //       ),
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
//
//   Widget _buildStatsCards(bool isProvider) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: StatsCard(
//                 count: isProvider ? '24' : '12',
//                 title: isProvider ? 'Tasks Completed' : 'Started',
//                 onButtonPressed: () {
//                   print(isProvider ? 'Tasks Completed pressed' : 'Work Posted pressed');
//                 },
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: StatsCard(
//                 count: isProvider ? '8' : '15',
//                 title: isProvider ? 'Active Bids' : 'Ended',
//                 onButtonPressed: () {
//                   print(isProvider ? 'Active Bids pressed' : 'Completed pressed');
//                 },
//               ),
//             ),
//           ],
//         ),
//
//         Row(
//           children: [
//             Expanded(
//               child: StatsCard(
//                 count: isProvider ? '24' : '12',
//                 title: isProvider ? 'Approved Bids' : 'Waiting',
//                 onButtonPressed: () {
//                  // print(isProvider ? 'Tasks Completed pressed' : 'Work Posted pressed');
//                 },
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: StatsCard(
//                 count: isProvider ? '8' : '15',
//                 title: isProvider ? 'Rejected Bids' : 'Bids received',
//                 onButtonPressed: () {
//                   //print(isProvider ? 'Active Bids pressed' : 'Completed pressed');
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
//     return GestureDetector(
//       onTap: () {
//         // Navigate to appropriate screen based on role
//         if (isProvider) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ProviderTasksScreen()),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ActiveTasksScreen()),
//           );
//         }
//       },
//       child: Container(
//         width: double.infinity,
//         height: 120,
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         SvgPicture.asset(
//                           'assets/taskIconSvg.svg',
//                           width: 22.89,
//                           height: 26.67,
//                           placeholderBuilder: (BuildContext context) => Icon(
//                             Icons.work_outline,
//                             size: 26,
//                             color: AppColors.primaryBlue,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           isProvider ? 'My Tasks' : 'All Jobs',
//                           style: const TextStyle(
//                             fontFamily: 'Plus Jakarta Sans',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 18,
//                             color: AppColors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         const SizedBox(),
//                         // Text(
//                         //   isProvider ? 'Manage Tasks' : 'Approve/Reject',
//                         //   style: const TextStyle(
//                         //     fontFamily: 'Plus Jakarta Sans',
//                         //     fontWeight: FontWeight.w400,
//                         //     fontSize: 12.63,
//                         //     color: Color(0xFF8B8B8B),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         isProvider ? '156' : '345',
//                         style: const TextStyle(
//                           fontFamily: 'Plus Jakarta Sans',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12.63,
//                           color: AppColors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         isProvider ? 'Requests' : 'Jobs',
//                         style: const TextStyle(
//                           fontFamily: 'Plus Jakarta Sans',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 12.63,
//                           color: Color(0xFF8B8B8B),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 12,
//               right: 12,
//               child: GestureDetector(
//                 onTap: () {
//                   // Navigate based on role
//                   if (isProvider) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const ProviderTasksScreen()),
//                     );
//                   } else {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const ActiveTasksScreen()),
//                     );
//                   }
//                 },
//                 child: Container(
//                   child: Center(
//                     child: SvgPicture.asset(
//                       'assets/cardFrowardSvg.svg',
//                       width: 21.7,
//                       height: 21.26,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:hunarmand/screens/profile_screen.dart';
import '../constants/colors.dart';
import '../models/auth_model.dart';
import '../widgets/stats_card.dart';
import 'active_tasks_screen.dart';
import 'provider_tasks_screen.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isProvider = authProvider.isProvider;
    final String userName = authProvider.currentUser?.name ?? 'User';
    final UserData? userData = authProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFEFF),
      appBar: _buildAppBar(context, userName, isProvider, authProvider),
      body: _buildBody(context, isProvider, userName, userData),
    );
  }

  AppBar _buildAppBar(BuildContext context, String userName, bool isProvider, AuthProvider authProvider) {
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
                fontSize: 14,
                height: 1.25,
                color: AppColors.black,
              ),
            ),
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
                authProvider.userRoleDisplayName,
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
    );
  }

  Widget _buildBody(BuildContext context, bool isProvider, String userName, UserData? userData) {
    // Calculate bid received for seekers (approved + rejected)
    final int bidReceived = (userData?.approvedBids ?? 0) + (userData?.rejectedBids ?? 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting section
          _buildGreetingSection(isProvider, userName),

          const SizedBox(height: 15),
          _buildRecentActivitiesSection(context, isProvider),

          const SizedBox(height: 20),
          _buildMyWorksCard(isProvider, context, userData),

          const SizedBox(height: 16),
          const Text(
            'Summary',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              fontSize: 16.93,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 16),
          // Show different stats based on user role
          isProvider
              ? _buildProviderStats(userData)
              : _buildSeekerStats(userData, bidReceived),
        ],
      ),
    );
  }

  Widget _buildGreetingSection(bool isProvider, String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isProvider ? 'Welcome, $userName!' : 'Hello, $userName!',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isProvider ? 'Service Provider Dashboard' : 'Service Seeker Dashboard',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textGray,
          ),
        ),
      ],
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
      ],
    );
  }

  Widget _buildProviderStats(UserData? userData) {
    return Column(
      children: [
        // First Row: Started Jobs and Ended Jobs
        Row(
          children: [
            Expanded(
              child: StatsCard(
                count: (userData?.startedJobs?.toString() ?? '0'),
                title: 'Started Jobs',
                onButtonPressed: () {
                  print('Started Jobs pressed');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatsCard(
                count: (userData?.endedJobs?.toString() ?? '0'),
                title: 'Ended Jobs',
                onButtonPressed: () {
                  print('Ended Jobs pressed');
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Second Row: Approved Bids and Rejected Bids
        Row(
          children: [
            Expanded(
              child: StatsCard(
                count: (userData?.approvedBids?.toString() ?? '0'),
                title: 'Approved Bids',
                onButtonPressed: () {
                  print('Approved Bids pressed');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatsCard(
                count: (userData?.rejectedBids?.toString() ?? '0'),
                title: 'Rejected Bids',
                onButtonPressed: () {
                  print('Rejected Bids pressed');
                },
              ),
            ),
          ],
        ),

        // const SizedBox(height: 16),
        //
        // // Third Row: Total Bids and Waiting Jobs (optional)
        // Row(
        //   children: [
        //     Expanded(
        //       child: StatsCard(
        //         count: (userData?.totalBids?.toString() ?? '0'),
        //         title: 'Total Bids',
        //         onButtonPressed: () {
        //           print('Total Bids pressed');
        //         },
        //       ),
        //     ),
        //     const SizedBox(width: 16),
        //     Expanded(
        //       child: StatsCard(
        //         count: (userData?.waitingJobs?.toString() ?? '0'),
        //         title: 'Waiting Jobs',
        //         onButtonPressed: () {
        //           print('Waiting Jobs pressed');
        //         },
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildSeekerStats(UserData? userData, int bidReceived) {
    return Column(
      children: [
        // First Row: Started and Ended
        Row(
          children: [
            Expanded(
              child: StatsCard(
                count: (userData?.startedJobs?.toString() ?? '0'),
                title: 'Started',
                onButtonPressed: () {
                  print('Started Jobs pressed');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatsCard(
                count: (userData?.endedJobs?.toString() ?? '0'),
                title: 'Ended',
                onButtonPressed: () {
                  print('Ended Jobs pressed');
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Second Row: Waiting and Bids Received
        Row(
          children: [
            Expanded(
              child: StatsCard(
                count: (userData?.waitingJobs?.toString() ?? '0'),
                title: 'Waiting',
                onButtonPressed: () {
                  print('Waiting Jobs pressed');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatsCard(
                count: bidReceived.toString(),
                title: 'Bids Received',
                onButtonPressed: () {
                  print('Bids Received pressed');
                },
              ),
            ),
          ],
        ),

        // const SizedBox(height: 16),
        //
        // // Third Row: Total Jobs (optional)
        // Row(
        //   children: [
        //     Expanded(
        //       child: StatsCard(
        //         count: ((userData?.startedJobs ?? 0) +
        //             (userData?.waitingJobs ?? 0) +
        //             (userData?.endedJobs ?? 0)).toString(),
        //         title: 'Total Jobs',
        //         onButtonPressed: () {
        //           print('Total Jobs pressed');
        //         },
        //       ),
        //     ),
        //     const SizedBox(width: 16),
        //     Expanded(
        //       child: StatsCard(
        //         count: (userData?.totalBids?.toString() ?? '0'),
        //         title: 'Total Bids',
        //         onButtonPressed: () {
        //           print('Total Bids pressed');
        //         },
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildMyWorksCard(bool isProvider, BuildContext context, UserData? userData) {
    final int totalCount = isProvider
        ? (userData?.totalBids ?? 0)
        : ((userData?.startedJobs ?? 0) + (userData?.waitingJobs ?? 0) + (userData?.endedJobs ?? 0));

    return GestureDetector(
      onTap: () {
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
                          isProvider ? 'My Jobs' : 'My Jobs',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isProvider ? 'Manage your bids' : 'Track your jobs',
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
                        totalCount.toString(),
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.63,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isProvider ? 'Bids' : 'Jobs',
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
      ),
    );
  }
}