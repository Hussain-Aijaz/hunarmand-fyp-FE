//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../constants/colors.dart';
// import '../models/task_model.dart';
// import '../models/bid_model.dart';
// import '../models/job_model.dart';
// import '../services/bid_service.dart';
// import '../providers/auth_provider.dart';
//
// class TaskDetailsScreen extends StatefulWidget {
//   final Task task;
//   final Job? job;
//
//   const TaskDetailsScreen({
//     super.key,
//     required this.task,
//     this.job,
//   });
//
//   @override
//   State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
// }
//
// class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
//   final BidService _bidService = BidService();
//   List<Bid> _jobBids = [];
//   bool _isLoadingBids = false;
//   String? _errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadJobBids();
//   }
//
//   // Load bids for this specific job using correct endpoint
//   Future<void> _loadJobBids() async {
//     if (widget.job == null) {
//       print('⚠️ No job object provided, cannot load bids');
//       return;
//     }
//
//     if (!mounted) return;
//     setState(() {
//       _isLoadingBids = true;
//       _errorMessage = null;
//     });
//
//     try {
//       print('📋 Fetching bids for job ${widget.job!.id}...');
//       print('🔗 Endpoint: /api/v1/bids/?jobs_list=list&job=${widget.job!.id}');
//
//       final bids = await _bidService.getAllBids(widget.job!.id);
//
//       if (mounted) {
//         setState(() {
//           _jobBids = bids;
//         });
//       }
//       print('✅ Loaded ${bids.length} bids for job ${widget.job!.id}');
//     } catch (e) {
//       print('❌ Error loading job bids: $e');
//       if (mounted) {
//         setState(() {
//           _errorMessage = 'Failed to load bids: ${e.toString().split('\n').first}';
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingBids = false;
//         });
//       }
//     }
//   }
//
//   // Refresh bids
//   Future<void> _refreshBids() async {
//     await _loadJobBids();
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFEFF),
//       appBar: _buildAppBar(context),
//       body: RefreshIndicator(
//         onRefresh: _refreshBids,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//
//               // Category and Priority Section
//               _buildCategoryPrioritySection(),
//
//               const SizedBox(height: 20),
//
//               // Description Section
//               _buildDescriptionSection(),
//
//               const SizedBox(height: 20),
//
//               // Bidding Section
//               _buildBiddingSection(),
//
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   AppBar _buildAppBar(BuildContext context) {
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
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.task.taskID,
//             style: const TextStyle(
//               fontFamily: 'Plus Jakarta Sans',
//               fontWeight: FontWeight.w500,
//               fontSize: 16,
//               height: 1.25,
//               letterSpacing: 0,
//               color: AppColors.black,
//             ),
//           ),
//           Text(
//             widget.task.taskName,
//             style: const TextStyle(
//               fontFamily: 'Plus Jakarta Sans',
//               fontWeight: FontWeight.w400,
//               fontSize: 9,
//               height: 1.0,
//               letterSpacing: 0,
//               color: Color(0xFF707070),
//             ),
//           ),
//         ],
//       ),
//       centerTitle: false,
//       actions: [
//         IconButton(
//           icon: const Icon(
//             Icons.refresh,
//             size: 20,
//             color: AppColors.primaryBlue,
//           ),
//           onPressed: _refreshBids,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCategoryPrioritySection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Category
//           Expanded(
//             child: _buildInfoItem(
//               title: 'Category',
//               value: widget.task.category,
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           // Priority
//           Expanded(
//             child: _buildInfoItem(
//               title: 'Priority',
//               value: widget.task.priority,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoItem({required String title, required String value}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontFamily: 'Plus Jakarta Sans',
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//             height: 1.0,
//             letterSpacing: 0,
//             color: Color(0xFF676767),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           width: double.infinity,
//           height: 48,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: const Color(0xFF727272),
//               width: 1,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: AppColors.black,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDescriptionSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Description',
//             style: TextStyle(
//               fontFamily: 'Plus Jakarta Sans',
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//               height: 1.0,
//               letterSpacing: 0,
//               color: Color(0xFF676767),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                 color: const Color(0xFF727272),
//                 width: 1,
//               ),
//             ),
//             child: Text(
//               widget.task.description,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: AppColors.black,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBiddingSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Bidding',
//                 style: TextStyle(
//                   fontFamily: 'Plus Jakarta Sans',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                   height: 1.0,
//                   letterSpacing: 0,
//                   color: Color(0xFF676767),
//                 ),
//               ),
//               if (!_isLoadingBids)
//                 Text(
//                   '${_jobBids.length} bids',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 12),
//
//           // Debug info (optional - remove in production)
//           if (widget.job != null && _jobBids.isEmpty)
//             Text(
//               'Job ID: ${widget.job!.id}',
//               style: const TextStyle(
//                 fontSize: 10,
//                 color: Colors.grey,
//               ),
//             ),
//
//           // Loading State
//           if (_isLoadingBids)
//             _buildLoadingState(),
//
//           // Error State
//           if (_errorMessage != null && !_isLoadingBids)
//             _buildErrorState(),
//
//           // Empty State
//           if (_jobBids.isEmpty && !_isLoadingBids && _errorMessage == null)
//             _buildEmptyState(),
//
//           // Bids List
//           if (_jobBids.isNotEmpty && !_isLoadingBids)
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: _jobBids.length,
//               itemBuilder: (context, index) {
//                 return _buildBidItem(_jobBids[index]);
//               },
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 20),
//       child: Center(
//         child: Column(
//           children: [
//             SizedBox(
//               width: 30,
//               height: 30,
//               child: CircularProgressIndicator(
//                 strokeWidth: 3,
//                 valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Loading bids...',
//               style: TextStyle(
//                 fontSize: 12,
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
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 40,
//             color: Colors.red[400],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Failed to load bids',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.red[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             _errorMessage!,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton(
//             onPressed: _refreshBids,
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
//   Widget _buildEmptyState() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         children: [
//           Icon(
//             Icons.assignment_outlined,
//             size: 48,
//             color: Colors.grey[300],
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             'No bids yet',
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             widget.job != null
//                 ? 'No bids received for this job yet'
//                 : 'Job information not available',
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: AppColors.primaryBlue,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBidItem(Bid bid) {
//     // Get bidder name from bid data or use default
//     String bidderName = 'Bidder #${bid.id}';
//
//     // Check bid status for styling
//     final isAccepted = bid.status == 'Accepted';
//     final isDeclined = bid.status == 'Declined';
//     final isDraft = bid.status == 'Draft';
//
//     Color statusColor;
//     switch (bid.status.toLowerCase()) {
//       case 'accepted':
//         statusColor = const Color(0xFF00BB61);
//         break;
//       case 'declined':
//         statusColor = const Color(0xFFFF0000);
//         break;
//       case 'draft':
//         statusColor = Colors.orange;
//         break;
//       default:
//         statusColor = const Color(0xFF0082B1);
//     }
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: const Color(0xFFE5E5E5),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Top Row: Status, Profile, Name, and Bid Amount
//           Row(
//             children: [
//               // Status Badge
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   bid.status,
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: statusColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: 8),
//
//               // Profile Picture
//               Container(
//                 width: 25,
//                 height: 25,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.grey[300],
//                 ),
//                 child: const Icon(
//                   Icons.person,
//                   size: 15,
//                   color: AppColors.primaryBlue,
//                 ),
//               ),
//
//               const SizedBox(width: 10),
//
//               // Bidder Name/ID
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       bidderName,
//                       style: const TextStyle(
//                         fontFamily: 'Plus Jakarta Sans',
//                         fontWeight: FontWeight.w500,
//                         fontSize: 12,
//                         height: 1.0,
//                         letterSpacing: 0,
//                         color: Color(0xFF0082B1),
//                       ),
//                     ),
//                     Text(
//                       'Bid ID: ${bid.id}',
//                       style: const TextStyle(
//                         fontSize: 10,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Bid Amount Container
//               Container(
//                 width: 95,
//                 height: 17,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0082B1),
//                   borderRadius: BorderRadius.circular(11),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'RS ${bid.amount}',
//                     style: const TextStyle(
//                       fontFamily: 'Plus Jakarta Sans',
//                       fontWeight: FontWeight.w700,
//                       fontSize: 11,
//                       height: 1.0,
//                       letterSpacing: 0,
//                       color: AppColors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 8),
//
//           // Created Date and Job ID
//           Row(
//             children: [
//               Text(
//                 'Submitted: ${_formatDate(bid.createdAt)}',
//                 style: const TextStyle(
//                   fontSize: 10,
//                   color: Colors.grey,
//                 ),
//               ),
//               const Spacer(),
//               if (bid.job != null)
//                 Text(
//                   'Job: ${bid.job}',
//                   style: const TextStyle(
//                     fontSize: 10,
//                     color: Colors.grey,
//                   ),
//                 ),
//             ],
//           ),
//
//           const SizedBox(height: 12),
//
//           // Accept and Decline Buttons (only show if bid is not already accepted/declined)
//           if (!isAccepted && !isDeclined)
//             Row(
//               children: [
//                 // Accept Button
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       _acceptBid(bid);
//                     },
//                     child: Container(
//                       width: 95,
//                       height: 17,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF00BB61),
//                         borderRadius: BorderRadius.circular(11),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Accept',
//                           style: TextStyle(
//                             fontFamily: 'Plus Jakarta Sans',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 11,
//                             height: 1.0,
//                             letterSpacing: 0,
//                             color: AppColors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 12),
//
//                 // Decline Button
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       _declineBid(bid);
//                     },
//                     child: Container(
//                       width: 95,
//                       height: 17,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFF0000),
//                         borderRadius: BorderRadius.circular(11),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Decline',
//                           style: TextStyle(
//                             fontFamily: 'Plus Jakarta Sans',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 11,
//                             height: 1.0,
//                             letterSpacing: 0,
//                             color: AppColors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//           // Status message if bid is already accepted/declined
//           if (isAccepted)
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF00BB61).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: const Text(
//                 '✓ Bid Accepted',
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: Color(0xFF00BB61),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//
//           if (isDeclined)
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFF0000).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: const Text(
//                 '✗ Bid Declined',
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: Color(0xFFFF0000),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _acceptBid(Bid bid) async {
//     print('Accepting bid ${bid.id}');
//     // TODO: Implement API call to accept bid
//     // You'll need an API endpoint like: PUT /api/v1/bids/{bidId}/?bids_detail=update
//     // With body: {"status": "Accepted"}
//
//     // For now, show a message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Accepting bid #${bid.id}...'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//   Future<void> _declineBid(Bid bid) async {
//     print('Declining bid ${bid.id}');
//     // TODO: Implement API call to decline bid
//     // You'll need an API endpoint like: PUT /api/v1/bids/{bidId}/?bids_detail=update
//     // With body: {"status": "Declined"}
//
//     // For now, show a message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Declining bid #${bid.id}...'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/task_model.dart';
import '../models/bid_model.dart';
import '../models/job_model.dart';
import '../services/bid_service.dart';
import '../providers/auth_provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  final Job? job;

  const TaskDetailsScreen({
    super.key,
    required this.task,
    this.job,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final BidService _bidService = BidService();
  List<Bid> _jobBids = [];
  bool _isLoadingBids = false;
  bool _isProcessingBid = false;
  String? _errorMessage;
  String? _successMessage;
  int? _processingBidId; // Track which bid is being processed

  @override
  void initState() {
    super.initState();
    _loadJobBids();
  }

  // Load bids for this specific job
  Future<void> _loadJobBids() async {
    if (widget.job == null) {
      print('⚠️ No job object provided, cannot load bids');
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoadingBids = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      print('📋 Fetching bids for job ${widget.job!.id}...');
      final bids = await _bidService.getBidsForJob(widget.job!.id);

      if (mounted) {
        setState(() {
          _jobBids = bids;
        });
      }
      print('✅ Loaded ${bids.length} bids for job ${widget.job!.id}');
    } catch (e) {
      print('❌ Error loading job bids: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load bids: ${e.toString().split('\n').first}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBids = false;
        });
      }
    }
  }

  // Refresh bids
  Future<void> _refreshBids() async {
    await _loadJobBids();
  }

  // Accept a bid
  Future<void> _acceptBid(Bid bid) async {
    if (_isProcessingBid) return; // Prevent multiple clicks

    setState(() {
      _isProcessingBid = true;
      _processingBidId = bid.id;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      print('✅ Accepting bid ${bid.id}...');

      final response = await _bidService.acceptBidWithBidObject(
        bid: bid,
      );

      if (!mounted) return;

      if (response.errors != null) {
        final errors = response.errors!;
        final errorMsg = errors.values.first is List
            ? (errors.values.first as List).first.toString()
            : errors.values.first.toString();

        setState(() {
          _errorMessage = 'Failed to accept bid: $errorMsg';
        });
      } else if (response.bid != null) {
        // Success!
        setState(() {
          _successMessage = 'Bid #${bid.id} accepted successfully!';
        });

        // Refresh bids list to show updated status
        await _loadJobBids();

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Bid #${bid.id} accepted successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to accept bid: No response data';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to accept bid: ${e.toString().split('\n').first}';
      });

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to accept bid: ${e.toString().split('\n').first}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingBid = false;
          _processingBidId = null;
        });
      }
    }
  }

  // Decline a bid
  Future<void> _declineBid(Bid bid) async {
    if (_isProcessingBid) return; // Prevent multiple clicks

    setState(() {
      _isProcessingBid = true;
      _processingBidId = bid.id;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      print('❌ Declining bid ${bid.id}...');

      final response = await _bidService.declineBidWithBidObject(
        bid: bid,
      );

      if (!mounted) return;

      if (response.errors != null) {
        final errors = response.errors!;
        final errorMsg = errors.values.first is List
            ? (errors.values.first as List).first.toString()
            : errors.values.first.toString();

        setState(() {
          _errorMessage = 'Failed to decline bid: $errorMsg';
        });
      } else if (response.bid != null) {
        // Success!
        setState(() {
          _successMessage = 'Bid #${bid.id} declined successfully!';
        });

        // Refresh bids list to show updated status
        await _loadJobBids();

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Bid #${bid.id} declined successfully!'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to decline bid: No response data';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to decline bid: ${e.toString().split('\n').first}';
      });

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to decline bid: ${e.toString().split('\n').first}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingBid = false;
          _processingBidId = null;
        });
      }
    }
  }

  // Clear messages
  void _clearMessages() {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFEFF),
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: _refreshBids,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Category and Priority Section
              _buildCategoryPrioritySection(),

              const SizedBox(height: 20),

              // Description Section
              _buildDescriptionSection(),

              const SizedBox(height: 20),

              // Success/Error Messages
              if (_successMessage != null)
                _buildMessageWidget(_successMessage!, false),
              if (_errorMessage != null)
                _buildMessageWidget(_errorMessage!, true),

              const SizedBox(height: 20),

              // Bidding Section
              _buildBiddingSection(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageWidget(String message, bool isError) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError ? Colors.red.shade200 : Colors.green.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle,
            color: isError ? Colors.red : Colors.green,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isError ? Colors.red.shade700 : Colors.green.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: _clearMessages,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // Rest of the methods remain the same with minor updates...
  AppBar _buildAppBar(BuildContext context) {
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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.task.taskID,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.25,
              letterSpacing: 0,
              color: AppColors.black,
            ),
          ),
          Text(
            widget.task.taskName,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
              fontSize: 9,
              height: 1.0,
              letterSpacing: 0,
              color: Color(0xFF707070),
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.refresh,
            size: 20,
            color: AppColors.primaryBlue,
          ),
          onPressed: _refreshBids,
        ),
      ],
    );
  }

  Widget _buildCategoryPrioritySection() {
    return Container(
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
      child: Row(
        children: [
          // Category
          Expanded(
            child: _buildInfoItem(
              title: 'Category',
              value: widget.task.category,
            ),
          ),

          const SizedBox(width: 12),

          // Priority
          Expanded(
            child: _buildInfoItem(
              title: 'Priority',
              value: widget.task.priority,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            height: 1.0,
            letterSpacing: 0,
            color: Color(0xFF676767),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF727272),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
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
          const Text(
            'Description',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.0,
              letterSpacing: 0,
              color: Color(0xFF676767),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF727272),
                width: 1,
              ),
            ),
            child: Text(
              widget.task.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiddingSection() {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bidding',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.0,
                  letterSpacing: 0,
                  color: Color(0xFF676767),
                ),
              ),
              if (!_isLoadingBids)
                Text(
                  '${_jobBids.length} bids',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Loading State
          if (_isLoadingBids)
            _buildLoadingState(),

          // Error State
          if (_errorMessage != null && !_isLoadingBids && _jobBids.isEmpty)
            _buildErrorState(),

          // Empty State
          if (_jobBids.isEmpty && !_isLoadingBids && _errorMessage == null)
            _buildEmptyState(),

          // Bids List
          if (_jobBids.isNotEmpty && !_isLoadingBids)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _jobBids.length,
              itemBuilder: (context, index) {
                return _buildBidItem(_jobBids[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Loading bids...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 40,
            color: Colors.red[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load bids',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _refreshBids,
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

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 48,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          const Text(
            'No bids yet',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.job != null
                ? 'No bids received for this job yet'
                : 'Job information not available',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidItem(Bid bid) {
    final isAccepted = bid.status == 'Accepted';
    final isDeclined = bid.status == 'Rejected' || bid.status == 'Declined';
    final isDraft = bid.status == 'Draft';
    final isProcessing = _processingBidId == bid.id && _isProcessingBid;

    Color statusColor;
    switch (bid.status.toLowerCase()) {
      case 'accepted':
        statusColor = const Color(0xFF00BB61);
        break;
      case 'rejected':
      case 'declined':
        statusColor = const Color(0xFFFF0000);
        break;
      case 'draft':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = const Color(0xFF0082B1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Top Row: Status, Profile, Name, and Bid Amount
          Row(
            children: [
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  bid.status,
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Profile Picture
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: const Icon(
                  Icons.person,
                  size: 15,
                  color: AppColors.primaryBlue,
                ),
              ),

              const SizedBox(width: 10),

              // Bidder Name/ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bidder #${bid.bidder}',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Color(0xFF0082B1),
                      ),
                    ),
                    Text(
                      'Bid ID: ${bid.id}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Bid Amount Container
              Container(
                width: 95,
                height: 17,
                decoration: BoxDecoration(
                  color: const Color(0xFF0082B1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: Text(
                    'RS ${bid.amount}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      height: 1.0,
                      letterSpacing: 0,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Created Date
          Text(
            'Submitted: ${_formatDate(bid.createdAt)}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 12),

          // Show buttons only if bid is not already accepted/declined
          if (!isAccepted && !isDeclined && !isProcessing)
            Row(
              children: [
                // Accept Button
                Expanded(
                  child: GestureDetector(
                    onTap: () => _acceptBid(bid),
                    child: Container(
                      width: 95,
                      height: 17,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BB61),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Center(
                        child: Text(
                          'Accept',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            height: 1.0,
                            letterSpacing: 0,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Decline Button
                Expanded(
                  child: GestureDetector(
                    onTap: () => _declineBid(bid),
                    child: Container(
                      width: 95,
                      height: 17,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Center(
                        child: Text(
                          'Decline',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            height: 1.0,
                            letterSpacing: 0,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          // Show loading indicator if processing
          if (isProcessing)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                ),
              ),
            ),

          // Show status message if bid is already accepted/declined
          if (isAccepted && !isProcessing)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF00BB61).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 12,
                    color: Color(0xFF00BB61),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Accepted',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF00BB61),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          if (isDeclined && !isProcessing)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cancel,
                    size: 12,
                    color: Color(0xFFFF0000),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Rejected',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFFFF0000),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}