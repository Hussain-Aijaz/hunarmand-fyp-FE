
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../constants/colors.dart';
// import '../models/task_model.dart';
// import '../models/job_model.dart';
// import '../services/job_service.dart';
// import '../services/shared_prefs_service.dart';
// import 'provider_task_details_screen.dart';
//
// class ProviderTasksScreen extends StatefulWidget {
//   const ProviderTasksScreen({super.key});
//
//   @override
//   State<ProviderTasksScreen> createState() => _ProviderTasksScreenState();
// }
//
// class _ProviderTasksScreenState extends State<ProviderTasksScreen> {
//   int _selectedSegment = 0;
//   bool _showFilter = false;
//   DateTime? _fromDate;
//   DateTime? _toDate;
//
//   // API service
//   final JobService _jobService = JobService();
//   final SharedPrefsService _sharedPrefs = SharedPrefsService();
//
//   // State variables
//   bool _isLoading = false;
//   String? _errorMessage;
//   List<Job> _jobs = [];
//   List<Task> _tasks = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadJobs();
//   }
//
//   Future<void> _loadJobs() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       print('🔄 Loading jobs from API...');
//       final jobs = await _jobService.getJobsList();
//
//       setState(() {
//         _jobs = jobs;
//         _tasks = jobs.map((job) => job.toTask()).toList();
//         _isLoading = false;
//       });
//
//       print('✅ Loaded ${jobs.length} jobs');
//     } catch (e) {
//       print('❌ Error loading jobs: $e');
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//
//       // Show error snackbar
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to load jobs: ${e.toString().split('\n').first}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//   // Helper method to get task count for each segment
//   int _getTaskCount(String status) {
//     final filteredTasks = _getFilteredTasksByStatus(status);
//     return filteredTasks.length;
//   }
//
//   // Get filtered tasks based on selected segment and date range
//   List<Task> get _filteredTasks {
//     List<Task> statusFilteredTasks = _getFilteredTasksByStatus(_getStatusFromSegment());
//
//     // Apply date filter if dates are selected
//     if (_fromDate != null || _toDate != null) {
//       statusFilteredTasks = statusFilteredTasks.where((task) {
//         bool matchesFromDate = true;
//         bool matchesToDate = true;
//
//         if (_fromDate != null) {
//           matchesFromDate = task.date.isAfter(_fromDate!.subtract(const Duration(days: 1)));
//         }
//
//         if (_toDate != null) {
//           matchesToDate = task.date.isBefore(_toDate!.add(const Duration(days: 1)));
//         }
//
//         return matchesFromDate && matchesToDate;
//       }).toList();
//     }
//
//     return statusFilteredTasks;
//   }
//
//   List<Task> _getFilteredTasksByStatus(String status) {
//     if (status == 'All') return _tasks;
//     return _tasks.where((task) => task.status.toLowerCase() == status.toLowerCase()).toList();
//   }
//
//   String _getStatusFromSegment() {
//     switch (_selectedSegment) {
//       case 0: return 'All';
//       case 1: return 'Approved';
//       case 2: return 'Rejected';
//       case 3: return 'Ended';
//       default: return 'All';
//     }
//   }
//
//   // Update segment titles with dynamic counts
//   List<String> get _updatedSegmentTitles {
//     return [
//       'All(${_getTaskCount('All')})',
//       'Approved(${_getTaskCount('Approved')})',
//       'Rejected(${_getTaskCount('Rejected')})',
//       'Ended(${_getTaskCount('Ended')})',
//     ];
//   }
//
//   // Clear date filters
//   void _clearDateFilters() {
//     setState(() {
//       _fromDate = null;
//       _toDate = null;
//     });
//   }
//
//   // Refresh jobs
//   Future<void> _refreshJobs() async {
//     await _loadJobs();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFEFF),
//       appBar: _buildAppBar(),
//       body: RefreshIndicator(
//         onRefresh: _refreshJobs,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//
//               // Filter Section Only (Removed Post New Work Button)
//               _buildHeaderSection(),
//
//               // Filter Section
//               if (_showFilter) _buildFilterSection(),
//
//               const SizedBox(height: 20),
//
//               // Loading State
//               if (_isLoading) _buildLoadingState(),
//
//               // Error State
//               if (_errorMessage != null && !_isLoading) _buildErrorState(),
//
//               // Content State
//               if (!_isLoading && _errorMessage == null) ...[
//                 // Segment Buttons
//                 _buildSegmentButtons(),
//
//                 const SizedBox(height: 20),
//
//                 // Tasks List
//                 _buildTasksList(),
//               ],
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: _isLoading
//           ? null
//           : FloatingActionButton(
//         onPressed: _refreshJobs,
//         backgroundColor: AppColors.primaryBlue,
//         child: const Icon(Icons.refresh, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Container(
//       height: 200,
//       child: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 40,
//               height: 40,
//               child: CircularProgressIndicator(
//                 strokeWidth: 3,
//                 valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Loading jobs...',
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorState() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(top: 20),
//       decoration: BoxDecoration(
//         color: Colors.red[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.red[200]!),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Icon(Icons.error_outline, color: Colors.red[600], size: 24),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   'Failed to load jobs',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Colors.red[600],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _errorMessage!.split('\n').first,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton(
//             onPressed: _loadJobs,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryBlue,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text(
//               'Try Again',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: AppColors.white,
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(
//           Icons.arrow_back_ios_new,
//           size: 20,
//           color: AppColors.black,
//         ),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//       title: const Text(
//         'My Tasks',
//         style: TextStyle(
//           fontFamily: 'Plus Jakarta Sans',
//           fontWeight: FontWeight.w600,
//           fontSize: 16,
//           height: 1.0,
//           letterSpacing: 0,
//           color: AppColors.black,
//         ),
//       ),
//       centerTitle: true,
//       actions: [
//         IconButton(
//           onPressed: _refreshJobs,
//           icon: const Icon(
//             Icons.refresh,
//             size: 20,
//             color: AppColors.primaryBlue,
//           ),
//         ),
//         IconButton(
//           onPressed: () {
//             print('Search pressed');
//           },
//           icon: SvgPicture.asset(
//             'assets/search_icon.svg',
//             width: 20,
//             height: 20,
//             color: AppColors.primaryBlue,
//             placeholderBuilder: (BuildContext context) => Icon(
//               Icons.search,
//               size: 20,
//               color: AppColors.primaryBlue,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//       ],
//     );
//   }
//
//   Widget _buildHeaderSection() {
//     return Row(
//       children: [
//         const Spacer(),
//
//         // Filter Button Only
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               _showFilter = !_showFilter;
//             });
//           },
//           child: Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: AppColors.primaryBlue,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Center(
//               child: SvgPicture.asset(
//                 'assets/filter_icon.svg',
//                 width: 16,
//                 height: 16,
//                 color: AppColors.white,
//                 placeholderBuilder: (BuildContext context) => const Icon(
//                   Icons.filter_list,
//                   size: 16,
//                   color: AppColors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFilterSection() {
//     return Container(
//       margin: const EdgeInsets.only(top: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               // From Date
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'From',
//                       style: TextStyle(
//                         fontFamily: 'Plus Jakarta Sans',
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12,
//                         height: 1.0,
//                         letterSpacing: 0,
//                         color: Color(0xFF676767),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     GestureDetector(
//                       onTap: _selectFromDate,
//                       child: Container(
//                         height: 40,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: const Color(0xFFCFCFCF)),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Center(
//                           child: Text(
//                             _fromDate != null
//                                 ? '${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}'
//                                 : 'Select Date',
//                             style: TextStyle(
//                               color: _fromDate != null ? AppColors.black : Colors.grey,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(width: 16),
//
//               // To Date
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'To',
//                       style: TextStyle(
//                         fontFamily: 'Plus Jakarta Sans',
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12,
//                         height: 1.0,
//                         letterSpacing: 0,
//                         color: Color(0xFF676767),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     GestureDetector(
//                       onTap: _selectToDate,
//                       child: Container(
//                         height: 40,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: const Color(0xFFCFCFCF)),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Center(
//                           child: Text(
//                             _toDate != null
//                                 ? '${_toDate!.day}/${_toDate!.month}/${_toDate!.year}'
//                                 : 'Select Date',
//                             style: TextStyle(
//                               color: _toDate != null ? AppColors.black : Colors.grey,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           // Clear Filters Button
//           if (_fromDate != null || _toDate != null)
//             Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: _clearDateFilters,
//                     child: Container(
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(4),
//                         border: Border.all(color: Colors.grey[300]!),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Clear Date Filters',
//                           style: TextStyle(
//                             fontFamily: 'Plus Jakarta Sans',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 12,
//                             color: Color(0xFF676767),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSegmentButtons() {
//     return Container(
//       height: 32,
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Row(
//         children: List.generate(_updatedSegmentTitles.length, (index) {
//           return Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _selectedSegment = index;
//                 });
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: _selectedSegment == index
//                       ? AppColors.primaryBlue
//                       : Colors.transparent,
//                   borderRadius: _getBorderRadius(index),
//                   border: _selectedSegment != index
//                       ? Border.all(color: AppColors.primaryBlue)
//                       : null,
//                 ),
//                 child: Center(
//                   child: Text(
//                     _updatedSegmentTitles[index],
//                     style: TextStyle(
//                       fontFamily: 'Plus Jakarta Sans',
//                       fontWeight: FontWeight.w500,
//                       fontSize: 10,
//                       height: 1.0,
//                       letterSpacing: 0,
//                       color: _selectedSegment == index
//                           ? AppColors.white
//                           : AppColors.primaryBlue,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   BorderRadius _getBorderRadius(int index) {
//     if (index == 0) {
//       return const BorderRadius.only(
//         topLeft: Radius.circular(6),
//         bottomLeft: Radius.circular(6),
//       );
//     } else if (index == _updatedSegmentTitles.length - 1) {
//       return const BorderRadius.only(
//         topRight: Radius.circular(6),
//         bottomRight: Radius.circular(6),
//       );
//     }
//     return BorderRadius.zero;
//   }
//
//   Widget _buildTasksList() {
//     if (_filteredTasks.isEmpty) {
//       return _buildEmptyState();
//     }
//
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: _filteredTasks.length,
//       itemBuilder: (context, index) {
//         final task = _filteredTasks[index];
//         final job = index < _jobs.length ? _jobs[index] : null;
//
//         return _buildTaskItem(task, job);
//       },
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Container(
//       height: MediaQuery.of(context).size.height*0.5,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SvgPicture.asset(
//               'assets/empty_state.svg',
//               width: 80,
//               height: 80,
//               placeholderBuilder: (BuildContext context) => Icon(
//                 Icons.assignment,
//                 size: 80,
//                 color: Colors.grey[300],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No tasks found',
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16,
//                 color: Colors.grey[500],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _fromDate != null || _toDate != null
//                   ? 'Try adjusting your date filters'
//                   : 'No jobs available or API returned empty list',
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w400,
//                 fontSize: 12,
//                 color: Colors.grey[400],
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _refreshJobs,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryBlue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 'Refresh',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget _buildTaskItem(Task task, Job? job) {
//   //   return GestureDetector(
//   //     onTap: () {
//   //       Navigator.push(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (context) => ProviderTaskDetailsScreen(task: task, job: job),
//   //         ),
//   //       );
//   //     },
//   //     child: Container(
//   //       margin: const EdgeInsets.only(bottom: 12),
//   //       padding: const EdgeInsets.all(16),
//   //       decoration: BoxDecoration(
//   //         color: AppColors.white,
//   //         borderRadius: BorderRadius.circular(8),
//   //         boxShadow: [
//   //           BoxShadow(
//   //             color: Colors.black.withOpacity(0.1),
//   //             blurRadius: 4,
//   //             offset: const Offset(0, 2),
//   //           ),
//   //         ],
//   //       ),
//   //       child: Column(
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           // Task Name and Status
//   //           Row(
//   //             children: [
//   //               Expanded(
//   //                 child: Text(
//   //                   task.taskName,
//   //                   style: const TextStyle(
//   //                     fontFamily: 'Plus Jakarta Sans',
//   //                     fontWeight: FontWeight.w500,
//   //                     fontSize: 14,
//   //                     height: 1.0,
//   //                     letterSpacing: 0,
//   //                     color: AppColors.primaryBlue,
//   //                   ),
//   //                 ),
//   //               ),
//   //               Container(
//   //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//   //                 decoration: BoxDecoration(
//   //                   color: const Color(0xFF0082B1).withOpacity(0.04),
//   //                   borderRadius: BorderRadius.circular(4),
//   //                 ),
//   //                 child: Text(
//   //                   task.status,
//   //                   style: const TextStyle(
//   //                     fontFamily: 'Plus Jakarta Sans',
//   //                     fontWeight: FontWeight.w500,
//   //                     fontSize: 10,
//   //                     height: 1.0,
//   //                     letterSpacing: 0,
//   //                     color: AppColors.primaryBlue,
//   //                   ),
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //
//   //           const SizedBox(height: 12),
//   //
//   //           // Description Heading
//   //           const Text(
//   //             'Description:',
//   //             style: TextStyle(
//   //               fontFamily: 'Plus Jakarta Sans',
//   //               fontWeight: FontWeight.w500,
//   //               fontSize: 12,
//   //               height: 1.0,
//   //               letterSpacing: 0,
//   //               color: AppColors.primaryBlue,
//   //             ),
//   //           ),
//   //
//   //           const SizedBox(height: 4),
//   //
//   //           // Description Text
//   //           Text(
//   //             task.description,
//   //             style: const TextStyle(
//   //               fontFamily: 'Plus Jakarta Sans',
//   //               fontWeight: FontWeight.w500,
//   //               fontSize: 10,
//   //               height: 1.3,
//   //               letterSpacing: 0,
//   //               color: Color(0xFF727272),
//   //             ),
//   //           ),
//   //
//   //           const SizedBox(height: 12),
//   //
//   //           // Stats Section
//   //           Container(
//   //             height: 1,
//   //             color: const Color(0xFFD7D7D7),
//   //           ),
//   //
//   //           const SizedBox(height: 12),
//   //
//   //           Row(
//   //             children: [
//   //               // No. of Bids
//   //               Expanded(
//   //                 child: Column(
//   //                   children: [
//   //                     const Text(
//   //                       'No. of Bids',
//   //                       style: TextStyle(
//   //                         fontFamily: 'Plus Jakarta Sans',
//   //                         fontWeight: FontWeight.w400,
//   //                         fontSize: 10,
//   //                         height: 1.0,
//   //                         letterSpacing: 0,
//   //                         color: Color(0xFF727272),
//   //                       ),
//   //                     ),
//   //                     const SizedBox(height: 4),
//   //                     Text(
//   //                       task.noOfBids.toString(),
//   //                       style: const TextStyle(
//   //                         fontFamily: 'Plus Jakarta Sans',
//   //                         fontWeight: FontWeight.w500,
//   //                         fontSize: 11,
//   //                         height: 1.0,
//   //                         letterSpacing: 0,
//   //                         color: AppColors.black,
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ),
//   //
//   //               // Vertical Divider
//   //               Container(
//   //                 width: 1,
//   //                 height: 30,
//   //                 color: const Color(0xFFD7D7D7),
//   //               ),
//   //
//   //               // Minimum Bid
//   //               Expanded(
//   //                 child: Column(
//   //                   children: [
//   //                     const Text(
//   //                       'Minimum Bid',
//   //                       style: TextStyle(
//   //                         fontFamily: 'Plus Jakarta Sans',
//   //                         fontWeight: FontWeight.w400,
//   //                         fontSize: 10,
//   //                         height: 1.0,
//   //                         letterSpacing: 0,
//   //                         color: Color(0xFF727272),
//   //                       ),
//   //                     ),
//   //                     const SizedBox(height: 4),
//   //                     Text(
//   //                       task.minimumBid,
//   //                       style: const TextStyle(
//   //                         fontFamily: 'Plus Jakarta Sans',
//   //                         fontWeight: FontWeight.w500,
//   //                         fontSize: 11,
//   //                         height: 1.0,
//   //                         letterSpacing: 0,
//   //                         color: AppColors.black,
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ),
//   //
//   //               // Vertical Divider
//   //               Container(
//   //                 width: 1,
//   //                 height: 30,
//   //                 color: const Color(0xFFD7D7D7),
//   //               ),
//   //
//   //               // Date
//   //               Expanded(
//   //                 child: Column(
//   //                   children: [
//   //                     const Text(
//   //                       'Posted Date',
//   //                       style: TextStyle(
//   //                         fontFamily: 'Plus Jakarta Sans',
//   //                         fontWeight: FontWeight.w400,
//   //                         fontSize: 10,
//   //                         height: 1.0,
//   //                         letterSpacing: 0,
//   //                         color: Color(0xFF727272),
//   //                       ),
//   //                     ),
//   //                     const SizedBox(height: 4),
//   //                     Text(
//   //                       '${task.date.day}/${task.date.month}/${task.date.year}',
//   //                       style: const TextStyle(
//   //                         fontFamily: 'Plus Jakarta Sans',
//   //                         fontWeight: FontWeight.w500,
//   //                         fontSize: 11,
//   //                         height: 1.0,
//   //                         letterSpacing: 0,
//   //                         color: AppColors.black,
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget _buildTaskItem(Task task, Job? job) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProviderTaskDetailsScreen(task: task, job: job),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Task ID and Status Row
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Task ID
//                 Text(
//                   '${task.taskID}',
//                   style: const TextStyle(
//                     fontFamily: 'Plus Jakarta Sans',
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14,
//                     height: 1.0,
//                     letterSpacing: 0,
//                     color: AppColors.primaryBlue,
//                   ),
//                 ),
//
//                 const Spacer(),
//
//                 // Status - centered vertically with Task ID
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF0082B1).withOpacity(0.04),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     task.status,
//                     style: const TextStyle(
//                       fontFamily: 'Plus Jakarta Sans',
//                       fontWeight: FontWeight.w500,
//                       fontSize: 10,
//                       height: 1.0,
//                       letterSpacing: 0,
//                       color: AppColors.primaryBlue,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 8),
//
//             // Task Name (now with description style)
//             Text(
//               task.taskName,
//               style: const TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 10,
//                 height: 1.3,
//                 letterSpacing: 0,
//                 color: Color(0xFF727272),
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // Description Heading
//             const Text(
//               'Description:',
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 12,
//                 height: 1.0,
//                 letterSpacing: 0,
//                 color: AppColors.primaryBlue,
//               ),
//             ),
//
//             const SizedBox(height: 4),
//
//             // Description Text
//             Text(
//               task.description,
//               style: const TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 10,
//                 height: 1.3,
//                 letterSpacing: 0,
//                 color: Color(0xFF727272),
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // Stats Section
//             Container(
//               height: 1,
//               color: const Color(0xFFD7D7D7),
//             ),
//
//             const SizedBox(height: 12),
//
//             Row(
//               children: [
//                 // No. of Bids
//                 Expanded(
//                   child: Column(
//                     children: [
//                       const Text(
//                         'No. of Bids',
//                         style: TextStyle(
//                           fontFamily: 'Plus Jakarta Sans',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 10,
//                           height: 1.0,
//                           letterSpacing: 0,
//                           color: Color(0xFF727272),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         task.noOfBids.toString(),
//                         style: const TextStyle(
//                           fontFamily: 'Plus Jakarta Sans',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 11,
//                           height: 1.0,
//                           letterSpacing: 0,
//                           color: AppColors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Vertical Divider
//                 Container(
//                   width: 1,
//                   height: 30,
//                   color: const Color(0xFFD7D7D7),
//                 ),
//
//                 // Minimum Bid
//                 Expanded(
//                   child: Column(
//                     children: [
//                       const Text(
//                         'Minimum Bid',
//                         style: TextStyle(
//                           fontFamily: 'Plus Jakarta Sans',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 10,
//                           height: 1.0,
//                           letterSpacing: 0,
//                           color: Color(0xFF727272),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         task.minimumBid,
//                         style: const TextStyle(
//                           fontFamily: 'Plus Jakarta Sans',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 11,
//                           height: 1.0,
//                           letterSpacing: 0,
//                           color: AppColors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Vertical Divider
//                 Container(
//                   width: 1,
//                   height: 30,
//                   color: const Color(0xFFD7D7D7),
//                 ),
//
//                 // Date
//                 Expanded(
//                   child: Column(
//                     children: [
//                       const Text(
//                         'Posted Date',
//                         style: TextStyle(
//                           fontFamily: 'Plus Jakarta Sans',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 10,
//                           height: 1.0,
//                           letterSpacing: 0,
//                           color: Color(0xFF727272),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '${task.date.day}/${task.date.month}/${task.date.year}',
//                         style: const TextStyle(
//                           fontFamily: 'Plus Jakarta Sans',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 11,
//                           height: 1.0,
//                           letterSpacing: 0,
//                           color: AppColors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _selectFromDate() async {
//     final DateTime now = DateTime.now();
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _fromDate ?? now,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(now.year + 10),
//     );
//     if (picked != null && picked != _fromDate) {
//       setState(() {
//         _fromDate = picked;
//       });
//     }
//   }
//
//   Future<void> _selectToDate() async {
//     final DateTime now = DateTime.now();
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _toDate ?? now,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(now.year + 10),
//     );
//     if (picked != null && picked != _toDate) {
//       setState(() {
//         _toDate = picked;
//       });
//     }
//   }
// }
//



import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import '../models/task_model.dart';
import '../models/job_model.dart';
import '../services/job_service.dart';
import '../services/shared_prefs_service.dart';
import 'provider_task_details_screen.dart';

class ProviderTasksScreen extends StatefulWidget {
  const ProviderTasksScreen({super.key});

  @override
  State<ProviderTasksScreen> createState() => _ProviderTasksScreenState();
}

class _ProviderTasksScreenState extends State<ProviderTasksScreen> {
  int _selectedSegment = 0;
  bool _showFilter = false;
  DateTime? _fromDate;
  DateTime? _toDate;

  // API service
  final JobService _jobService = JobService();
  final SharedPrefsService _sharedPrefs = SharedPrefsService();

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  List<Job> _jobs = [];
  List<Task> _tasks = [];

  // Job status tags from API - ALL SEGMENTS INCLUDED
  final List<String> jobStatusTags = [
    'All',           // Always show All first
    'Waiting',
    'Approved',
    'Rejected',
    'Started',
    'Ended'
  ];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void didPush() {
    _loadJobs();
  }

  // Called when the route is popped off the navigator
  @override
  void didPopNext() {
    // Called when the next route is popped and this route becomes visible again
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🔄 Loading jobs from API...');
      final jobs = await _jobService.getJobsList();

      setState(() {
        _jobs = jobs;
        _tasks = jobs.map((job) => job.toTask()).toList();
        _isLoading = false;
      });

      print('✅ Loaded ${jobs.length} jobs');
      // Print status distribution
      _printStatusDistribution();
    } catch (e) {
      print('❌ Error loading jobs: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load jobs: ${e.toString().split('\n').first}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _printStatusDistribution() {
    print('📊 Job Status Distribution:');
    for (final tag in jobStatusTags) {
      final count = _getTaskCount(tag);
      print('   $tag: $count');
    }
  }

  // Helper method to get task count for each segment
  int _getTaskCount(String status) {
    if (status == 'All') return _tasks.length;
    return _tasks.where((task) => task.status == status).length;
  }

  // Get filtered tasks based on selected segment and date range
  List<Task> get _filteredTasks {
    String selectedStatus = jobStatusTags[_selectedSegment];
    List<Task> statusFilteredTasks;

    if (selectedStatus == 'All') {
      statusFilteredTasks = List.from(_tasks);
    } else {
      statusFilteredTasks = _tasks.where((task) => task.status == selectedStatus).toList();
    }

    // Apply date filter if dates are selected
    if (_fromDate != null || _toDate != null) {
      statusFilteredTasks = statusFilteredTasks.where((task) {
        bool matchesFromDate = true;
        bool matchesToDate = true;

        if (_fromDate != null) {
          matchesFromDate = task.date.isAfter(_fromDate!.subtract(const Duration(days: 1)));
        }

        if (_toDate != null) {
          matchesToDate = task.date.isBefore(_toDate!.add(const Duration(days: 1)));
        }

        return matchesFromDate && matchesToDate;
      }).toList();
    }

    // Sort by date (newest first)
    statusFilteredTasks.sort((a, b) => b.date.compareTo(a.date));

    return statusFilteredTasks;
  }

  // Get segment title with count
  String _getSegmentTitleWithCount(String status) {
    final count = _getTaskCount(status);
    return '$status($count)';
  }

  // Clear date filters
  void _clearDateFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
    });
  }

  // Refresh jobs
  Future<void> _refreshJobs() async {
    await _loadJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color(0xFFFAFEFF),
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshJobs,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Filter Section Only (Removed Post New Work Button)
              _buildHeaderSection(),

              // Filter Section
              if (_showFilter) _buildFilterSection(),

              const SizedBox(height: 20),

              // Loading State
              if (_isLoading) _buildLoadingState(),

              // Error State
              if (_errorMessage != null && !_isLoading) _buildErrorState(),

              // Content State
              if (!_isLoading && _errorMessage == null) ...[
                // Segment Buttons - Horizontal Scroll (SHOW ALL SEGMENTS)
                _buildSegmentButtons(),

                const SizedBox(height: 20),

                // Tasks List
                _buildTasksList(),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
        onPressed: _refreshJobs,
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 200,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Loading jobs...',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[600], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Failed to load jobs',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.red[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage!.split('\n').first,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loadJobs,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 20,
          color: AppColors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'My Tasks',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.0,
          letterSpacing: 0,
          color: AppColors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _refreshJobs,
          icon: const Icon(
            Icons.refresh,
            size: 20,
            color: AppColors.primaryBlue,
          ),
        ),
        IconButton(
          onPressed: () {
            print('Search pressed');
          },
          icon: SvgPicture.asset(
            'assets/search_icon.svg',
            width: 20,
            height: 20,
            color: AppColors.primaryBlue,
            placeholderBuilder: (BuildContext context) => Icon(
              Icons.search,
              size: 20,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        const Spacer(),

        // Filter Button Only
        GestureDetector(
          onTap: () {
            setState(() {
              _showFilter = !_showFilter;
            });
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/filter_icon.svg',
                width: 16,
                height: 16,
                color: AppColors.white,
                placeholderBuilder: (BuildContext context) => const Icon(
                  Icons.filter_list,
                  size: 16,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // From Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'From',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Color(0xFF676767),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectFromDate,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFCFCFCF)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            _fromDate != null
                                ? '${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}'
                                : 'Select Date',
                            style: TextStyle(
                              color: _fromDate != null ? AppColors.black : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // To Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'To',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Color(0xFF676767),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectToDate,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFCFCFCF)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            _toDate != null
                                ? '${_toDate!.day}/${_toDate!.month}/${_toDate!.year}'
                                : 'Select Date',
                            style: TextStyle(
                              color: _toDate != null ? AppColors.black : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Clear Filters Button
          if (_fromDate != null || _toDate != null)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _clearDateFilters,
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Center(
                        child: Text(
                          'Clear Date Filters',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xFF676767),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSegmentButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(jobStatusTags.length, (index) {
          final status = jobStatusTags[index];
          final isSelected = _selectedSegment == index;

          return Container(
            margin: EdgeInsets.only(right: index == jobStatusTags.length - 1 ? 0 : 8),
            child: ChoiceChip(
              label: Text(
                _getSegmentTitleWithCount(status),
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: isSelected ? Colors.white : AppColors.primaryBlue,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primaryBlue,
              backgroundColor: Colors.grey[50],
              side: BorderSide(color: AppColors.primaryBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedSegment = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTasksList() {
    if (_filteredTasks.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredTasks.length,
      itemBuilder: (context, index) {
        final task = _filteredTasks[index];
        final job = index < _jobs.length ? _jobs[index] : null;

        return _buildTaskItem(task, job);
      },
    );
  }

  Widget _buildEmptyState() {
    final currentStatus = jobStatusTags[_selectedSegment];

    return Container(
      height: MediaQuery.of(context).size.height*0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/empty_state.svg',
              width: 80,
              height: 80,
              placeholderBuilder: (BuildContext context) => Icon(
                Icons.assignment,
                size: 80,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              currentStatus == 'All'
                  ? 'No tasks found'
                  : 'No $currentStatus tasks',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _fromDate != null || _toDate != null
                  ? 'Try adjusting your date filters'
                  : currentStatus == 'All'
                  ? 'No tasks available'
                  : 'No tasks with status: $currentStatus',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshJobs,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Refresh',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task, Job? job) {
    // Get color based on status (same as ActiveTasksScreen)
    Color getStatusColor(String status) {
      switch (status) {
        case 'Waiting':
          return Colors.orange;
        case 'Approved':
          return Colors.green;
        case 'Rejected':
          return Colors.red;
        case 'Started':
          return Colors.blue;
        case 'Ended':
          return Colors.purple;
        default:
          return AppColors.primaryBlue;
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderTaskDetailsScreen(task: task, job: job),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task ID and Status Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Task ID
                Text(
                  '${task.taskID}',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.0,
                    letterSpacing: 0,
                    color: AppColors.primaryBlue,
                  ),
                ),

                const Spacer(),

                // Status Badge with color coding
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor(task.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: getStatusColor(task.status).withOpacity(0.3)),
                  ),
                  child: Text(
                    task.status,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      height: 1.0,
                      letterSpacing: 0,
                      color: getStatusColor(task.status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Task Name (now with description style)
            Text(
              task.taskName,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                height: 1.3,
                letterSpacing: 0,
                color: Color(0xFF727272),
              ),
            ),

            const SizedBox(height: 12),

            // Description Heading
            const Text(
              'Description:',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 1.0,
                letterSpacing: 0,
                color: AppColors.primaryBlue,
              ),
            ),

            const SizedBox(height: 4),

            // Description Text
            Text(
              task.description,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                height: 1.3,
                letterSpacing: 0,
                color: Color(0xFF727272),
              ),
            ),

            const SizedBox(height: 12),

            // Stats Section
            Container(
              height: 1,
              color: const Color(0xFFD7D7D7),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                // No. of Bids
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'No. of Bids',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          height: 1.0,
                          letterSpacing: 0,
                          color: Color(0xFF727272),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.noOfBids.toString(),
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          height: 1.0,
                          letterSpacing: 0,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Vertical Divider
                Container(
                  width: 1,
                  height: 30,
                  color: const Color(0xFFD7D7D7),
                ),

                // Minimum Bid
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Minimum Bid',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          height: 1.0,
                          letterSpacing: 0,
                          color: Color(0xFF727272),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.minimumBid,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          height: 1.0,
                          letterSpacing: 0,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Vertical Divider
                Container(
                  width: 1,
                  height: 30,
                  color: const Color(0xFFD7D7D7),
                ),

                // Date
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Posted Date',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          height: 1.0,
                          letterSpacing: 0,
                          color: Color(0xFF727272),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${task.date.day}/${task.date.month}/${task.date.year}',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          height: 1.0,
                          letterSpacing: 0,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFromDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });
    }
  }
}