// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hunarmand/screens/task_details_screen.dart';
// import '../constants/colors.dart';
// import '../models/task_model.dart';
// import '../widgets/create_task_dialog.dart';
//
// class ActiveTasksScreen extends StatefulWidget {
//   const ActiveTasksScreen({super.key});
//
//   @override
//   State<ActiveTasksScreen> createState() => _ActiveTasksScreenState();
// }
//
// class _ActiveTasksScreenState extends State<ActiveTasksScreen> {
//   int _selectedSegment = 0;
//   bool _showFilter = false;
//   DateTime? _fromDate;
//   DateTime? _toDate;
//
//   List<Task> _allTasks = [
//     Task(
//       taskID: 'T000001',
//       taskName: 'Home Cleaning Service',
//       status: 'Open',
//       description: 'Complete home cleaning including bedrooms, kitchen, and bathrooms. Deep cleaning required.',
//       noOfBids: 12,
//       minimumBid: '\$50',
//       date: DateTime.now().subtract(const Duration(days: 2)),
//       category: 'Home Cleaning',
//       priority: 'Medium',
//     ),
//     Task(
//       taskID: 'T000002',
//       taskName: 'Plumbing Repair',
//       status: 'Waiting',
//       description: 'Fix leaking kitchen sink and replace faucet. Need immediate attention.',
//       noOfBids: 8,
//       minimumBid: '\$80',
//       date: DateTime.now().subtract(const Duration(days: 1)),
//       category: 'Plumbing',
//       priority: 'Urgent',
//     ),
//     Task(
//       taskID: 'T000003',
//       taskName: 'Electrical Wiring',
//       status: 'Pending',
//       description: 'Install new electrical outlets in living room and bedroom. Safety standards must be followed.',
//       noOfBids: 15,
//       minimumBid: '\$120',
//       date: DateTime.now(),
//       category: 'Electrical',
//       priority: 'High',
//     ),
//     Task(
//       taskID: 'T000004',
//       taskName: 'Painting Work',
//       status: 'Ended',
//       description: 'Paint interior walls of 2-bedroom apartment. Color consultation included.',
//       noOfBids: 20,
//       minimumBid: '\$200',
//       date: DateTime.now().subtract(const Duration(days: 5)),
//       category: 'Painting',
//       priority: 'Medium',
//     ),
//     Task(
//       taskID: 'T000005',
//       taskName: 'Furniture Assembly',
//       status: 'Open',
//       description: 'Assemble IKEA furniture including bed, wardrobe, and study table.',
//       noOfBids: 6,
//       minimumBid: '\$60',
//       date: DateTime.now().subtract(const Duration(days: 3)),
//       category: 'Carpentry',
//       priority: 'Low',
//     ),
//     Task(
//       taskID: 'T000006',
//       taskName: 'Garden Maintenance',
//       status: 'Waiting',
//       description: 'Weekly garden maintenance including lawn mowing and plant care.',
//       noOfBids: 5,
//       minimumBid: '\$45',
//       date: DateTime.now().subtract(const Duration(days: 4)),
//       category: 'Gardening',
//       priority: 'Low',
//     ),
//     Task(
//       taskID: 'T000007',
//       taskName: 'AC Repair',
//       status: 'Pending',
//       description: 'Fix air conditioning unit not cooling properly.',
//       noOfBids: 10,
//       minimumBid: '\$90',
//       date: DateTime.now().subtract(const Duration(days: 1)),
//       category: 'Electrical',
//       priority: 'High',
//     ),
//     Task(
//       taskID: 'T000008',
//       taskName: 'Carpet Cleaning',
//       status: 'Ended',
//       description: 'Deep clean all carpets in 3-bedroom house.',
//       noOfBids: 18,
//       minimumBid: '\$75',
//       date: DateTime.now().subtract(const Duration(days: 7)),
//       category: 'Home Cleaning',
//       priority: 'Medium',
//     ),
//     Task(
//       taskID: 'T000009',
//       taskName: 'Window Cleaning',
//       status: 'Open',
//       description: 'Clean all interior and exterior windows of office building.',
//       noOfBids: 7,
//       minimumBid: '\$85',
//       date: DateTime.now().subtract(const Duration(days: 2)),
//       category: 'Home Cleaning',
//       priority: 'Medium',
//     ),
//     Task(
//       taskID: 'T000010',
//       taskName: 'Roof Repair',
//       status: 'Waiting',
//       description: 'Fix leaking roof and replace damaged shingles.',
//       noOfBids: 3,
//       minimumBid: '\$300',
//       date: DateTime.now().subtract(const Duration(days: 6)),
//       category: 'Other',
//       priority: 'Urgent',
//     ),
//     Task(
//       taskID: 'T000011',
//       taskName: 'Floor Tiling',
//       status: 'Pending',
//       description: 'Install ceramic tiles in kitchen and bathroom floors.',
//       noOfBids: 9,
//       minimumBid: '\$150',
//       date: DateTime.now().subtract(const Duration(days: 3)),
//       category: 'Other',
//       priority: 'Medium',
//     ),
//     Task(
//       taskID: 'T000012',
//       taskName: 'Pest Control',
//       status: 'Ended',
//       description: 'Complete pest control treatment for entire house.',
//       noOfBids: 14,
//       minimumBid: '\$65',
//       date: DateTime.now().subtract(const Duration(days: 10)),
//       category: 'Other',
//       priority: 'High',
//     ),
//     Task(
//       taskID: 'T000013',
//       taskName: 'Moving Service',
//       status: 'Open',
//       description: 'Help with moving furniture and boxes to new apartment.',
//       noOfBids: 11,
//       minimumBid: '\$110',
//       date: DateTime.now().subtract(const Duration(days: 1)),
//       category: 'Moving',
//       priority: 'Medium',
//     ),
//     Task(
//       taskID: 'T000014',
//       taskName: 'Smart Home Setup',
//       status: 'Waiting',
//       description: 'Install and configure smart home devices and automation.',
//       noOfBids: 4,
//       minimumBid: '\$180',
//       date: DateTime.now().subtract(const Duration(days: 5)),
//       category: 'Electrical',
//       priority: 'Medium',
//     ),
//     Task(
//       taskID: 'T000015',
//       taskName: 'Bathroom Renovation',
//       status: 'Pending',
//       description: 'Complete bathroom renovation including plumbing and tiling.',
//       noOfBids: 6,
//       minimumBid: '\$250',
//       date: DateTime.now().subtract(const Duration(days: 4)),
//       category: 'Plumbing',
//       priority: 'High',
//     ),
//     Task(
//       taskID: 'T000016',
//       taskName: 'Lawn Care',
//       status: 'Ended',
//       description: 'Regular lawn mowing and garden maintenance for 3 months.',
//       noOfBids: 22,
//       minimumBid: '\$35',
//       date: DateTime.now().subtract(const Duration(days: 15)),
//       category: 'Gardening',
//       priority: 'Low',
//     ),
//     Task(
//       taskID: 'T000017',
//       taskName: 'Kitchen Cabinet Installation',
//       status: 'Open',
//       description: 'Install new kitchen cabinets and countertops.',
//       noOfBids: 8,
//       minimumBid: '\$400',
//       date: DateTime.now().subtract(const Duration(days: 2)),
//       category: 'Carpentry',
//       priority: 'Medium',
//     ),
//     Task(
//       taskID: 'T000018',
//       taskName: 'Water Heater Replacement',
//       status: 'Waiting',
//       description: 'Replace old water heater with new energy-efficient model.',
//       noOfBids: 5,
//       minimumBid: '\$220',
//       date: DateTime.now().subtract(const Duration(days: 7)),
//       category: 'Plumbing',
//       priority: 'High',
//     ),
//     Task(
//       taskID: 'T000019',
//       taskName: 'Deck Building',
//       status: 'Pending',
//       description: 'Build wooden deck in backyard with seating area.',
//       noOfBids: 7,
//       minimumBid: '\$500',
//       date: DateTime.now().subtract(const Duration(days: 3)),
//       category: 'Carpentry',
//       priority: 'Medium',
//     ),
//     Task(
//       taskID: 'T000020',
//       taskName: 'House Painting Exterior',
//       status: 'Ended',
//       description: 'Paint entire exterior of house including trim work.',
//       noOfBids: 16,
//       minimumBid: '\$800',
//       date: DateTime.now().subtract(const Duration(days: 12)),
//       category: 'Painting',
//       priority: 'High',
//     ),
//   ];
//
//   // Method to generate next task ID
//   String get _nextTaskId {
//     if (_allTasks.isEmpty) {
//       return 'T000001';
//     }
//
//     // Extract numbers from existing task IDs and find the maximum
//     final numbers = _allTasks.map((task) {
//       final match = RegExp(r'T(\d+)').firstMatch(task.taskID);
//       return match != null ? int.parse(match.group(1)!) : 0;
//     }).toList();
//
//     final maxNumber = numbers.reduce((a, b) => a > b ? a : b);
//     final nextNumber = maxNumber + 1;
//
//     // Format as T000001, T000002, etc.
//     return 'T${nextNumber.toString().padLeft(6, '0')}';
//   }
//
//   // Method to add new task
//   void _addNewTask(Task newTask) {
//     setState(() {
//       _allTasks.add(newTask);
//       // Sort tasks by date (newest first)
//       _allTasks.sort((a, b) => b.date.compareTo(a.date));
//     });
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
//     // Sort by date (newest first)
//     statusFilteredTasks.sort((a, b) => b.date.compareTo(a.date));
//
//     return statusFilteredTasks;
//   }
//
//   List<Task> _getFilteredTasksByStatus(String status) {
//     if (status == 'All') return _allTasks;
//     return _allTasks.where((task) => task.status == status).toList();
//   }
//
//   String _getStatusFromSegment() {
//     switch (_selectedSegment) {
//       case 0: return 'All';
//       case 1: return 'Waiting';
//       case 2: return 'Pending';
//       case 3: return 'Ended';
//       default: return 'All';
//     }
//   }
//
//   // Update segment titles with dynamic counts
//   List<String> get _updatedSegmentTitles {
//     return [
//       'All(${_getTaskCount('All')})',
//       'Waiting(${_getTaskCount('Waiting')})',
//       'Pending(${_getTaskCount('Pending')})',
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFEFF),
//       appBar: _buildAppBar(),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//
//             // Post New Work Button and Filter
//             _buildHeaderSection(),
//
//             // Filter Section
//             if (_showFilter) _buildFilterSection(),
//
//             const SizedBox(height: 20),
//
//             // Segment Buttons
//             _buildSegmentButtons(),
//
//             const SizedBox(height: 20),
//
//             // Tasks List
//             _buildTasksList(),
//           ],
//         ),
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
//         'Active Task',
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
//         // Post New Work Button
//         if (!_showFilter)
//           GestureDetector(
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => CreateTaskDialog(
//                   onTaskCreated: _addNewTask,
//                   nextTaskId: _nextTaskId,
//                 ),
//               );
//             },
//             child: Container(
//               width: 150,
//               height: 21,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryBlue,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: const Center(
//                 child: Text(
//                   'Post New work',
//                   style: TextStyle(
//                     fontFamily: 'Plus Jakarta Sans',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 10,
//                     height: 1.0,
//                     letterSpacing: 0,
//                     color: AppColors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//         const Spacer(),
//
//         // Filter Button
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
//         return _buildTaskItem(_filteredTasks[index]);
//       },
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Container(
//       color: Colors.red,
//       height: 500,
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
//                   : 'There are no tasks in this category',
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w400,
//                 fontSize: 12,
//                 color: Colors.grey[400],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTaskItem(Task task) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TaskDetailsScreen(task: task),
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
//             // Task Name and Status
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     task.taskName,
//                     style: const TextStyle(
//                       fontFamily: 'Plus Jakarta Sans',
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                       height: 1.0,
//                       letterSpacing: 0,
//                       color: AppColors.primaryBlue,
//                     ),
//                   ),
//                 ),
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
//       lastDate: DateTime(now.year + 10), // 10 years from now
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
//       lastDate: DateTime(now.year + 10), // 10 years from now
//     );
//     if (picked != null && picked != _toDate) {
//       setState(() {
//         _toDate = picked;
//       });
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hunarmand/screens/task_details_screen.dart';
import '../constants/colors.dart';
import '../models/task_model.dart';
import '../models/job_model.dart';
import '../services/job_service.dart';
import '../widgets/create_task_dialog.dart';

class ActiveTasksScreen extends StatefulWidget {
  const ActiveTasksScreen({super.key});

  @override
  State<ActiveTasksScreen> createState() => _ActiveTasksScreenState();
}

class _ActiveTasksScreenState extends State<ActiveTasksScreen> {
  int _selectedSegment = 0;
  bool _showFilter = false;
  DateTime? _fromDate;
  DateTime? _toDate;

  // API service
  final JobService _jobService = JobService();

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  List<Job> _jobs = [];
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🔄 Loading jobs from API for ActiveTasksScreen...');
      final jobs = await _jobService.getJobsList();

      setState(() {
        _jobs = jobs;
        _tasks = jobs.map((job) => job.toTask()).toList();
        _isLoading = false;
      });

      print('✅ Loaded ${jobs.length} jobs for ActiveTasksScreen');
    } catch (e) {
      print('❌ Error loading jobs: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load tasks: ${e.toString().split('\n').first}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Method to generate next task ID (kept for CreateTaskDialog compatibility)
  String get _nextTaskId {
    if (_tasks.isEmpty) {
      return 'T000001';
    }

    // Extract numbers from existing task IDs and find the maximum
    final numbers = _tasks.map((task) {
      final match = RegExp(r'T(\d+)').firstMatch(task.taskID);
      return match != null ? int.parse(match.group(1)!) : 0;
    }).toList();

    final maxNumber = numbers.reduce((a, b) => a > b ? a : b);
    final nextNumber = maxNumber + 1;

    return 'T${nextNumber.toString().padLeft(6, '0')}';
  }

  // Method to add new task (for CreateTaskDialog)
  void _addNewTask(Task newTask) {
    setState(() {
      _tasks.add(newTask);
      // Sort tasks by date (newest first)
      _tasks.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  // Helper method to get task count for each segment
  int _getTaskCount(String status) {
    final filteredTasks = _getFilteredTasksByStatus(status);
    return filteredTasks.length;
  }

  // Get filtered tasks based on selected segment and date range
  List<Task> get _filteredTasks {
    List<Task> statusFilteredTasks = _getFilteredTasksByStatus(_getStatusFromSegment());

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

  List<Task> _getFilteredTasksByStatus(String status) {
    if (status == 'All') return _tasks;

    // Map API status to UI status
    final statusMap = {
      'Open': ['open', 'pending', 'waiting'],
      'Waiting': ['waiting', 'pending'],
      'Pending': ['pending', 'in_progress'],
      'Ended': ['ended', 'completed', 'closed', 'rejected'],
    };

    if (statusMap.containsKey(status)) {
      final validStatuses = statusMap[status]!;
      return _tasks.where((task) =>
          validStatuses.contains(task.status.toLowerCase())
      ).toList();
    }

    return _tasks.where((task) => task.status.toLowerCase() == status.toLowerCase()).toList();
  }

  String _getStatusFromSegment() {
    switch (_selectedSegment) {
      case 0: return 'All';
      case 1: return 'Waiting';
      case 2: return 'Pending';
      case 3: return 'Ended';
      default: return 'All';
    }
  }

  // Update segment titles with dynamic counts
  List<String> get _updatedSegmentTitles {
    return [
      'All(${_getTaskCount('All')})',
      'Waiting(${_getTaskCount('Waiting')})',
      'Pending(${_getTaskCount('Pending')})',
      'Ended(${_getTaskCount('Ended')})',
    ];
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
      backgroundColor: const Color(0xFFFAFEFF),
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshJobs,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Post New Work Button and Filter
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
                // Segment Buttons
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
              'Loading tasks...',
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
                  'Failed to load tasks',
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
        'Active Task',
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
        // Post New Work Button
        if (!_showFilter)
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => CreateTaskDialog(
                  onTaskCreated: _addNewTask,
                  nextTaskId: _nextTaskId,
                ),
              );
            },
            child: Container(
              width: 150,
              height: 21,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  'Post New work',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    height: 1.0,
                    letterSpacing: 0,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),

        const Spacer(),

        // Filter Button
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
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: List.generate(_updatedSegmentTitles.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSegment = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedSegment == index
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: _getBorderRadius(index),
                  border: _selectedSegment != index
                      ? Border.all(color: AppColors.primaryBlue)
                      : null,
                ),
                child: Center(
                  child: Text(
                    _updatedSegmentTitles[index],
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      height: 1.0,
                      letterSpacing: 0,
                      color: _selectedSegment == index
                          ? AppColors.white
                          : AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  BorderRadius _getBorderRadius(int index) {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(6),
        bottomLeft: Radius.circular(6),
      );
    } else if (index == _updatedSegmentTitles.length - 1) {
      return const BorderRadius.only(
        topRight: Radius.circular(6),
        bottomRight: Radius.circular(6),
      );
    }
    return BorderRadius.zero;
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
              'No tasks found',
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
                  : 'No tasks available',
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsScreen(task: task,job: job,),
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
                  'Task ID: ${task.taskID}',
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

                // Status - centered vertically with Task ID
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0082B1).withOpacity(0.04),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.status,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      height: 1.0,
                      letterSpacing: 0,
                      color: AppColors.primaryBlue,
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