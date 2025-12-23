// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../constants/colors.dart';
// import '../models/bid_model.dart';
// import '../models/job_model.dart';
// import '../models/task_model.dart';
// import '../models/auth_model.dart';
// import '../services/bid_service.dart';
// import '../providers/auth_provider.dart';
//
// class ProviderTaskDetailsScreen extends StatefulWidget {
//   final Task task;
//   final Job? job;
//
//   const ProviderTaskDetailsScreen({
//     super.key,
//     required this.task,
//     this.job,
//   });
//
//   @override
//   State<ProviderTaskDetailsScreen> createState() => _ProviderTaskDetailsScreenState();
// }
//
// class _ProviderTaskDetailsScreenState extends State<ProviderTaskDetailsScreen> {
//   final TextEditingController _bidAmountController = TextEditingController();
//   final BidService _bidService = BidService();
//   bool _isCreatingBid = false;
//   String? _errorMessage;
//   String? _successMessage;
//   List<Bid> _bids = [];
//   bool _isLoadingBids = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _bidAmountController.addListener(_validateInput);
//     _loadBids();
//   }
//
//   @override
//   void dispose() {
//     _bidAmountController.dispose();
//     super.dispose();
//   }
//
//   // Validate input to allow only numbers
//   void _validateInput() {
//     final text = _bidAmountController.text;
//     if (text.isEmpty) return;
//
//     // Remove any non-digit characters except decimal point
//     final validText = text.replaceAll(RegExp(r'[^0-9.]'), '');
//
//     // Ensure only one decimal point
//     final decimalParts = validText.split('.');
//     if (decimalParts.length > 2) {
//       // More than one decimal point, remove extra
//       final corrected = '${decimalParts[0]}.${decimalParts.sublist(1).join()}';
//       _bidAmountController.text = corrected;
//       _bidAmountController.selection = TextSelection.collapsed(offset: corrected.length);
//     } else if (validText != text) {
//       final selection = _bidAmountController.selection;
//       _bidAmountController.text = validText;
//       _bidAmountController.selection = selection.copyWith(
//         baseOffset: validText.length,
//         extentOffset: validText.length,
//       );
//     }
//   }
//
//   // Load bids for this job
//   Future<void> _loadBids() async {
//     if (widget.job == null) return;
//
//     if (!mounted) return;
//     setState(() {
//       _isLoadingBids = true;
//     });
//
//     try {
//       final bids = await _bidService.getBidsForJob(widget.job!.id);
//       if (mounted) {
//         setState(() {
//           _bids = bids;
//         });
//       }
//     } catch (e) {
//       print('Error loading bids: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingBids = false;
//         });
//       }
//     }
//   }
//
//   // Handle create bid button press
//   Future<void> _createBid() async {
//     // Get current user from auth provider
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final currentUser = authProvider.currentUser;
//
//     if (currentUser == null) {
//       _showError('Please login to create a bid');
//       return;
//     }
//
//     final bidAmount = _bidAmountController.text.trim();
//
//     if (bidAmount.isEmpty) {
//       _showError('Please enter a bid amount');
//       return;
//     }
//
//     if (widget.job == null) {
//       _showError('Job information is missing');
//       return;
//     }
//
//     // Get bidder ID from user profile
//     final bidderId = int.tryParse(currentUser.id);
//     if (bidderId == null) {
//       _showError('Invalid user ID');
//       return;
//     }
//
//     // Get job ID
//     final jobId = widget.job!.id;
//
//     // Parse amount
//     final amount = double.tryParse(bidAmount);
//     if (amount == null) {
//       _showError('Please enter a valid amount');
//       return;
//     }
//
//     if (amount <= 0) {
//       _showError('Amount must be greater than 0');
//       return;
//     }
//
//     setState(() {
//       _isCreatingBid = true;
//       _errorMessage = null;
//       _successMessage = null;
//     });
//
//     try {
//       final response = await _bidService.createBid(
//         amount: amount,
//         status: 'Draft',
//         jobId: jobId,
//         bidderId: bidderId,
//       );
//
//       if (!mounted) return;
//
//       if (response.errors != null) {
//         final errors = response.errors!;
//         final errorMsg = errors.values.first is List
//             ? (errors.values.first as List).first.toString()
//             : errors.values.first.toString();
//         _showError('Failed to create bid: $errorMsg');
//       } else if (response.bid != null) {
//         // Success! Show detailed success message
//         final bid = response.bid!;
//         _showSuccess('Bid created successfully! \n'
//             'ID: ${bid.id}, Amount: RS ${bid.amount}');
//
//         _bidAmountController.clear();
//
//         // Refresh bids list
//         await _loadBids();
//
//         // Show bid details dialog
//         _showBidDetailsDialog(bid);
//       } else {
//         _showError('Failed to create bid: No response data');
//       }
//     } catch (e) {
//       if (!mounted) return;
//       _showError('Error: ${e.toString().split('\n').first}');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isCreatingBid = false;
//         });
//       }
//     }
//   }
//
//   void _showError(String message) {
//     setState(() {
//       _errorMessage = message;
//       _successMessage = null;
//     });
//
//     // Clear error after 5 seconds
//     Future.delayed(const Duration(seconds: 5), () {
//       if (mounted) {
//         setState(() {
//           _errorMessage = null;
//         });
//       }
//     });
//   }
//
//   void _showSuccess(String message) {
//     setState(() {
//       _successMessage = message;
//       _errorMessage = null;
//     });
//
//     // Clear success after 5 seconds
//     Future.delayed(const Duration(seconds: 5), () {
//       if (mounted) {
//         setState(() {
//           _successMessage = null;
//         });
//       }
//     });
//   }
//
//   void _showBidDetailsDialog(Bid bid) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Bid Created Successfully'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Bid ID: ${bid.id}'),
//               Text('Amount: RS ${bid.amount}'),
//               Text('Status: ${bid.status}'),
//               Text('Job ID: ${bid.job}'),
//               Text('Bidder ID: ${bid.bidder}'),
//               Text('Created: ${_formatDate(bid.createdAt)}'),
//               const SizedBox(height: 16),
//               const Text(
//                 'Your bid has been submitted successfully!',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final currentUser = authProvider.currentUser;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFEFF),
//       appBar: _buildAppBar(context),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//
//             // Category and Priority Section
//             _buildCategoryPrioritySection(),
//
//             const SizedBox(height: 20),
//
//             // Description Section
//             _buildDescriptionSection(),
//
//             const SizedBox(height: 20),
//
//             // My Bid Section with Create Button
//             _buildMyBidSection(currentUser),
//
//             // Error/Success Messages
//             if (_errorMessage != null)
//               _buildMessageWidget(_errorMessage!, true),
//             if (_successMessage != null)
//               _buildMessageWidget(_successMessage!, false),
//
//             const SizedBox(height: 20),
//
//             // Bidding Status Section
//             _buildBiddingStatusSection(),
//
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMessageWidget(String message, bool isError) {
//     return Container(
//       margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isError ? Colors.red.shade50 : Colors.green.shade50,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: isError ? Colors.red.shade200 : Colors.green.shade200,
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             isError ? Icons.error_outline : Icons.check_circle,
//             color: isError ? Colors.red : Colors.green,
//             size: 20,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               message,
//               style: TextStyle(
//                 color: isError ? Colors.red.shade700 : Colors.green.shade700,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.close, size: 16),
//             onPressed: () {
//               setState(() {
//                 if (isError) {
//                   _errorMessage = null;
//                 } else {
//                   _successMessage = null;
//                 }
//               });
//             },
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMyBidSection(UserData? currentUser) {
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
//             'My Bid',
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
//
//           // Row with TextField and Create Button
//           Row(
//             children: [
//               // Text Field (Numbers only with decimal)
//               Expanded(
//                 child: Container(
//                   height: 48,
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       color: const Color(0xFF727272),
//                       width: 1,
//                     ),
//                   ),
//                   child: TextField(
//                     controller: _bidAmountController,
//                     keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Enter amount (e.g., 20000)',
//                       hintStyle: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12),
//                     ),
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: AppColors.black,
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: 12),
//
//               // Create Button
//               Container(
//                 width: 100,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: _isCreatingBid || currentUser == null
//                       ? AppColors.primaryBlue.withOpacity(0.5)
//                       : AppColors.primaryBlue,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: TextButton(
//                   onPressed: _isCreatingBid || currentUser == null
//                       ? null
//                       : _createBid,
//                   style: TextButton.styleFrom(
//                     padding: EdgeInsets.zero,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: _isCreatingBid
//                       ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                       : const Text(
//                     'Create',
//                     style: TextStyle(
//                       fontFamily: 'Plus Jakarta Sans',
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                       color: AppColors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           // User info and instructions
//           const SizedBox(height: 8),
//           if (currentUser == null)
//             const Text(
//               'Please login to create a bid',
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w400,
//                 fontSize: 12,
//                 color: Colors.orange,
//               ),
//             )
//           else
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Logged in as: ${currentUser.name}',
//                   style: const TextStyle(
//                     fontFamily: 'Plus Jakarta Sans',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 12,
//                     color: Color(0xFF707070),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'User ID: ${currentUser.id} | Job ID: ${widget.job?.id ?? 'N/A'}',
//                   style: const TextStyle(
//                     fontFamily: 'Plus Jakarta Sans',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 10,
//                     color: Color(0xFF909090),
//                   ),
//                 ),
//               ],
//             ),
//         ],
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
//           Expanded(
//             child: _buildInfoItem(
//               title: 'Category',
//               value: widget.task.category,
//             ),
//           ),
//           const SizedBox(width: 12),
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
//   Widget _buildBiddingStatusSection() {
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
//                 'Bidding Status',
//                 style: TextStyle(
//                   fontFamily: 'Plus Jakarta Sans',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                   height: 1.0,
//                   letterSpacing: 0,
//                   color: Color(0xFF676767),
//                 ),
//               ),
//               if (_isLoadingBids)
//                 const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               else
//                 Text(
//                   '${_bids.length} bids',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 12),
//
//           if (_isLoadingBids)
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           else if (_bids.isEmpty)
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Text(
//                 'No bids yet. Be the first to bid!',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 14,
//                 ),
//               ),
//             )
//           else
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: _bids.length,
//               itemBuilder: (context, index) {
//                 return _buildBidItem(_bids[index]);
//               },
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBidItem(Bid bid) {
//     // Check if this bid belongs to current user
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final currentUser = authProvider.currentUser;
//     final isMyBid = currentUser != null && bid.bidder.toString() == currentUser.id;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isMyBid ? AppColors.primaryBlue.withOpacity(0.1) : AppColors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: isMyBid ? AppColors.primaryBlue : const Color(0xFFE5E5E5),
//           width: isMyBid ? 1.5 : 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Status and Your Bid badge
//           Row(
//             children: [
//               Text(
//                 bid.status,
//                 style: TextStyle(
//                   fontFamily: 'Plus Jakarta Sans',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                   height: 1.0,
//                   letterSpacing: 0,
//                   color: bid.status == 'Accepted'
//                       ? const Color(0xFF00BB61)
//                       : bid.status == 'Declined'
//                       ? const Color(0xFFFF0000)
//                       : const Color(0xFF0082B1),
//                 ),
//               ),
//               if (isMyBid) ...[
//                 const SizedBox(width: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryBlue,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: const Text(
//                     'Your Bid',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//
//           const SizedBox(height: 8),
//
//           // Bidder Info Row
//           Row(
//             children: [
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
//               // Bidder ID
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Bidder #${bid.bidder}',
//                     style: const TextStyle(
//                       fontFamily: 'Plus Jakarta Sans',
//                       fontWeight: FontWeight.w500,
//                       fontSize: 12,
//                       height: 1.0,
//                       letterSpacing: 0,
//                       color: Color(0xFF0082B1),
//                     ),
//                   ),
//                   Text(
//                     'Bid ID: ${bid.id}',
//                     style: const TextStyle(
//                       fontSize: 10,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const Spacer(),
//
//               // Bid Amount Container
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0082B1),
//                   borderRadius: BorderRadius.circular(11),
//                 ),
//                 child: Text(
//                   'RS ${bid.amount}',
//                   style: const TextStyle(
//                     fontFamily: 'Plus Jakarta Sans',
//                     fontWeight: FontWeight.w700,
//                     fontSize: 11,
//                     height: 1.0,
//                     letterSpacing: 0,
//                     color: AppColors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           // Created time
//           const SizedBox(height: 8),
//           Text(
//             'Created: ${_formatDate(bid.createdAt)}',
//             style: const TextStyle(
//               fontSize: 10,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/bid_model.dart';
import '../models/job_model.dart';
import '../models/task_model.dart';
import '../models/auth_model.dart';
import '../services/bid_service.dart';
import '../providers/auth_provider.dart';

class ProviderTaskDetailsScreen extends StatefulWidget {
  final Task task;
  final Job? job;

  const ProviderTaskDetailsScreen({
    super.key,
    required this.task,
    this.job,
  });

  @override
  State<ProviderTaskDetailsScreen> createState() => _ProviderTaskDetailsScreenState();
}

class _ProviderTaskDetailsScreenState extends State<ProviderTaskDetailsScreen> {
  final TextEditingController _bidAmountController = TextEditingController();
  final BidService _bidService = BidService();
  bool _isCreatingBid = false;
  String? _errorMessage;
  String? _successMessage;
  List<Bid> _jobBids = [];
  bool _isLoadingBids = false;

  @override
  void initState() {
    super.initState();
    _bidAmountController.addListener(_validateInput);
    _loadJobBids(); // Load bids when screen opens
  }

  @override
  void dispose() {
    _bidAmountController.dispose();
    super.dispose();
  }

  // Validate input to allow only numbers
  void _validateInput() {
    final text = _bidAmountController.text;
    if (text.isEmpty) return;

    // Remove any non-digit characters except decimal point
    final validText = text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Ensure only one decimal point
    final decimalParts = validText.split('.');
    if (decimalParts.length > 2) {
      // More than one decimal point, remove extra
      final corrected = '${decimalParts[0]}.${decimalParts.sublist(1).join()}';
      _bidAmountController.text = corrected;
      _bidAmountController.selection = TextSelection.collapsed(offset: corrected.length);
    } else if (validText != text) {
      final selection = _bidAmountController.selection;
      _bidAmountController.text = validText;
      _bidAmountController.selection = selection.copyWith(
        baseOffset: validText.length,
        extentOffset: validText.length,
      );
    }
  }

  // Load bids for this specific job
  Future<void> _loadJobBids() async {
    if (widget.job == null) return;

    if (!mounted) return;
    setState(() {
      _isLoadingBids = true;
    });

    try {
      final bids = await _bidService.getBidsForJob(widget.job!.id);
      if (mounted) {
        setState(() {
          _jobBids = bids;
        });
      }
    } catch (e) {
      print('Error loading job bids: $e');
      // Show error to user
      if (mounted) {
        _showError('Failed to load bids: ${e.toString().split('\n').first}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBids = false;
        });
      }
    }
  }

  // Handle create bid button press
  Future<void> _createBid() async {
    // Get current user from auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      _showError('Please login to create a bid');
      return;
    }

    final bidAmount = _bidAmountController.text.trim();

    if (bidAmount.isEmpty) {
      _showError('Please enter a bid amount');
      return;
    }

    if (widget.job == null) {
      _showError('Job information is missing');
      return;
    }

    // Get bidder ID from user profile
    final bidderId = int.tryParse(currentUser.id);
    if (bidderId == null) {
      _showError('Invalid user ID');
      return;
    }

    // Get job ID
    final jobId = widget.job!.id;

    // Parse amount
    final amount = double.tryParse(bidAmount);
    if (amount == null) {
      _showError('Please enter a valid amount');
      return;
    }

    if (amount <= 0) {
      _showError('Amount must be greater than 0');
      return;
    }

    setState(() {
      _isCreatingBid = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final response = await _bidService.createBid(
        amount: amount,
        status: 'Draft',
        jobId: jobId,
        bidderId: bidderId,
      );

      if (!mounted) return;

      if (response.errors != null) {
        final errors = response.errors!;
        final errorMsg = errors.values.first is List
            ? (errors.values.first as List).first.toString()
            : errors.values.first.toString();
        _showError('Failed to create bid: $errorMsg');
      } else if (response.bid != null) {
        // Success! Show detailed success message
        final bid = response.bid!;
        _showSuccess('Bid created successfully! \n'
            'ID: ${bid.id}, Amount: RS ${bid.amount}');

        _bidAmountController.clear();

        // Refresh bids list
        await _loadJobBids();

        // Show bid details dialog
        _showBidDetailsDialog(bid);
      } else {
        _showError('Failed to create bid: No response data');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Error: ${e.toString().split('\n').first}');
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingBid = false;
        });
      }
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _successMessage = null;
    });

    // Clear error after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  void _showSuccess(String message) {
    setState(() {
      _successMessage = message;
      _errorMessage = null;
    });

    // Clear success after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _successMessage = null;
        });
      }
    });
  }

  void _showBidDetailsDialog(Bid bid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bid Created Successfully'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bid ID: ${bid.id}'),
              Text('Amount: RS ${bid.amount}'),
              Text('Status: ${bid.status}'),
              Text('Job ID: ${bid.job}'),
              Text('Created: ${_formatDate(bid.createdAt)}'),
              const SizedBox(height: 16),
              const Text(
                'Your bid has been submitted successfully!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFEFF),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
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

            // My Bid Section with Create Button
            _buildMyBidSection(currentUser),

            // Error/Success Messages
            if (_errorMessage != null)
              _buildMessageWidget(_errorMessage!, true),
            if (_successMessage != null)
              _buildMessageWidget(_successMessage!, false),

            const SizedBox(height: 20),

            // Bidding Status Section (only shows current job bids)
            _buildBiddingStatusSection(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageWidget(String message, bool isError) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () {
              setState(() {
                if (isError) {
                  _errorMessage = null;
                } else {
                  _successMessage = null;
                }
              });
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildMyBidSection(UserData? currentUser) {
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
            'My Bid',
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

          // Row with TextField and Create Button
          Row(
            children: [
              // Text Field (Numbers only with decimal)
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF727272),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _bidAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter amount (e.g., 20000)',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Create Button
              Container(
                width: 100,
                height: 48,
                decoration: BoxDecoration(
                  color: _isCreatingBid || currentUser == null
                      ? AppColors.primaryBlue.withOpacity(0.5)
                      : AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: _isCreatingBid || currentUser == null
                      ? null
                      : _createBid,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isCreatingBid
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text(
                    'Create',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // User info
          const SizedBox(height: 8),
          if (currentUser == null)
            const Text(
              'Please login to create a bid',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.orange,
              ),
            )
          else
            Text(
              'Ready to submit your bid',
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF707070),
              ),
            ),
        ],
      ),
    );
  }

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
          Expanded(
            child: _buildInfoItem(
              title: 'Category',
              value: widget.task.category,
            ),
          ),
          const SizedBox(width: 12),
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

  Widget _buildBiddingStatusSection() {
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
                'Bidding Status',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.0,
                  letterSpacing: 0,
                  color: Color(0xFF676767),
                ),
              ),
              Row(
                children: [
                  if (_isLoadingBids)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Text(
                      '${_jobBids.length} bids',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (_isLoadingBids)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_jobBids.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const Icon(
                    Icons.assignment_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No bids for this job yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Be the first to bid!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else
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

  Widget _buildBidItem(Bid bid) {
    // Check if this bid belongs to current user
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    final isMyBid = currentUser != null && bid.bidder.toString() == currentUser.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMyBid ? AppColors.primaryBlue.withOpacity(0.1) : AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMyBid ? AppColors.primaryBlue : const Color(0xFFE5E5E5),
          width: isMyBid ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and Your Bid badge
          Row(
            children: [
              // Status
              Text(
                bid.status,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 1.0,
                  letterSpacing: 0,
                  color: bid.status == 'Accepted'
                      ? const Color(0xFF00BB61)
                      : bid.status == 'Declined'
                      ? const Color(0xFFFF0000)
                      : const Color(0xFF0082B1),
                ),
              ),

              const Spacer(),

              // Your Bid badge
              if (isMyBid)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Your Bid',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Bidder Info Row
          Row(
            children: [
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

              // Bidder ID and Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bid #${bid.id}',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Color(0xFF0082B1),
                      ),
                    ),
                    if (isMyBid)
                      const Text(
                        'Submitted by you',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),

              // Bid Amount Container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0082B1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  'RS ${bid.amount}',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    height: 1.0,
                    letterSpacing: 0,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),

          // Created time
          const SizedBox(height: 8),
          Text(
            'Created: ${_formatDate(bid.createdAt)}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

 */


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/bid_model.dart';
import '../models/job_model.dart';
import '../models/task_model.dart';
import '../models/auth_model.dart';
import '../services/bid_service.dart';
import '../providers/auth_provider.dart';

class ProviderTaskDetailsScreen extends StatefulWidget {
  final Task task;
  final Job? job;

  const ProviderTaskDetailsScreen({
    super.key,
    required this.task,
    this.job,
  });

  @override
  State<ProviderTaskDetailsScreen> createState() => _ProviderTaskDetailsScreenState();
}

class _ProviderTaskDetailsScreenState extends State<ProviderTaskDetailsScreen> {
  final TextEditingController _bidAmountController = TextEditingController();
  final BidService _bidService = BidService();
  bool _isCreatingBid = false;
  bool _isUpdatingBid = false;
  String? _errorMessage;
  String? _successMessage;
  List<Bid> _jobBids = [];
  bool _isLoadingBids = false;
  Bid? _editingBid; // Store the bid being edited
  bool _showBidField = false; // Initially hidden if there's a draft bid

  @override
  void initState() {
    super.initState();
    _bidAmountController.addListener(_validateInput);
    _loadJobBids();
  }

  @override
  void dispose() {
    _bidAmountController.dispose();
    super.dispose();
  }

  // Validate input to allow only numbers
  void _validateInput() {
    final text = _bidAmountController.text;
    if (text.isEmpty) return;

    // Remove any non-digit characters except decimal point
    final validText = text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Ensure only one decimal point
    final decimalParts = validText.split('.');
    if (decimalParts.length > 2) {
      // More than one decimal point, remove extra
      final corrected = '${decimalParts[0]}.${decimalParts.sublist(1).join()}';
      _bidAmountController.text = corrected;
      _bidAmountController.selection = TextSelection.collapsed(offset: corrected.length);
    } else if (validText != text) {
      final selection = _bidAmountController.selection;
      _bidAmountController.text = validText;
      _bidAmountController.selection = selection.copyWith(
        baseOffset: validText.length,
        extentOffset: validText.length,
      );
    }
  }

  // Check if there's any draft bid in the list
  bool get _hasDraftBid {
    return _jobBids.any((bid) => bid.status == 'Draft');
  }

  // Get user's draft bid (if exists)
  Bid? get _userDraftBid {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    if (currentUser == null) return null;

    return _jobBids.firstWhere(
          (bid) => bid.status == 'Draft' && bid.bidder.toString() == currentUser.id,
      orElse: () => null as Bid,
    );
  }

  // Load bids for this specific job
  Future<void> _loadJobBids() async {
    if (widget.job == null) return;

    if (!mounted) return;
    setState(() {
      _isLoadingBids = true;
      _editingBid = null;
    });

    try {
      final bids = await _bidService.getAllBids(widget.job!.id);

      if (mounted) {
        setState(() {
          _jobBids = bids;
          // Show bid field only if there's NO draft bid
          _showBidField = !_hasDraftBid;
        });
      }
    } catch (e) {
      print('Error loading job bids: $e');
      if (mounted) {
        _showError('Failed to load bids: ${e.toString().split('\n').first}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBids = false;
        });
      }
    }
  }

  // Start editing a bid
  void _startEditingBid(Bid bid) {
    setState(() {
      _editingBid = bid;
      _showBidField = true;
      _bidAmountController.text = bid.amount.toString();
    });
  }

  // Cancel editing
  void _cancelEditing() {
    setState(() {
      _editingBid = null;
      _showBidField = !_hasDraftBid; // Hide if there's still a draft bid
      _bidAmountController.clear();
    });
  }

  // Handle create/update bid button press
  Future<void> _handleBidAction() async {
    // Get current user from auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      _showError('Please login to create a bid');
      return;
    }

    final bidAmount = _bidAmountController.text.trim();

    if (bidAmount.isEmpty) {
      _showError('Please enter a bid amount');
      return;
    }

    if (widget.job == null) {
      _showError('Job information is missing');
      return;
    }

    // Parse amount
    final amount = double.tryParse(bidAmount);
    if (amount == null) {
      _showError('Please enter a valid amount');
      return;
    }

    if (amount <= 0) {
      _showError('Amount must be greater than 0');
      return;
    }

    setState(() {
      if (_editingBid == null) {
        _isCreatingBid = true;
      } else {
        _isUpdatingBid = true;
      }
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      if (_editingBid == null) {
        // Get bidder ID from user profile
        final bidderId = int.tryParse(currentUser.id);
        if (bidderId == null) {
          _showError('Invalid user ID');
          return;
        }

        // Get job ID
        final jobId = widget.job!.id;

        // Create new bid
        final response = await _bidService.createBid(
          amount: amount,
          status: 'Draft',
          jobId: jobId,
          bidderId: bidderId,
        );

        if (!mounted) return;

        if (response.errors != null) {
          final errors = response.errors!;
          final errorMsg = errors.values.first is List
              ? (errors.values.first as List).first.toString()
              : errors.values.first.toString();
          _showError('Failed to create bid: $errorMsg');
        } else if (response.bid != null) {
          // Success!
          final bid = response.bid!;
          _showSuccess('Bid created successfully!');

          _bidAmountController.clear();

          // Refresh bids list
          await _loadJobBids();
        } else {
          _showError('Failed to create bid: No response data');
        }
      } else {
        // Update existing bid
        final response = await _bidService.updateBidWithBidObject(
          bid: _editingBid!,
          amount: amount,
          status: 'Draft',
        );

        if (!mounted) return;

        if (response.errors != null) {
          final errors = response.errors!;
          final errorMsg = errors.values.first is List
              ? (errors.values.first as List).first.toString()
              : errors.values.first.toString();
          _showError('Failed to update bid: $errorMsg');
        } else if (response.bid != null) {
          // Success!
          final bid = response.bid!;
          _showSuccess('Bid updated successfully!');

          _cancelEditing();

          // Refresh bids list
          await _loadJobBids();
        } else {
          _showError('Failed to update bid: No response data');
        }
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Error: ${e.toString().split('\n').first}');
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingBid = false;
          _isUpdatingBid = false;
        });
      }
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _successMessage = null;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  void _showSuccess(String message) {
    setState(() {
      _successMessage = message;
      _errorMessage = null;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _successMessage = null;
        });
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFEFF),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
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

            // Only show My Bid section if there's NO draft bid OR we're editing
            if (_showBidField || !_hasDraftBid)
              _buildMyBidSection(currentUser),

            // Error/Success Messages
            if (_errorMessage != null)
              _buildMessageWidget(_errorMessage!, true),
            if (_successMessage != null)
              _buildMessageWidget(_successMessage!, false),

            const SizedBox(height: 20),

            // Bidding Status Section
            _buildBiddingStatusSection(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageWidget(String message, bool isError) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () {
              setState(() {
                if (isError) {
                  _errorMessage = null;
                } else {
                  _successMessage = null;
                }
              });
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildMyBidSection(UserData? currentUser) {
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
          Text(
            _editingBid != null ? 'Edit Bid' : 'My Bid',
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

          // Bid input field
          Row(
            children: [
              // Text Field
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF727272),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _bidAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _editingBid != null ? 'Edit bid amount' : 'Enter amount (e.g., 20000)',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      suffixIcon: _editingBid != null
                          ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: _cancelEditing,
                        tooltip: 'Cancel edit',
                      )
                          : null,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Create/Update Button
              Container(
                width: 100,
                height: 48,
                decoration: BoxDecoration(
                  color: (_isCreatingBid || _isUpdatingBid || currentUser == null)
                      ? AppColors.primaryBlue.withOpacity(0.5)
                      : AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: (_isCreatingBid || _isUpdatingBid || currentUser == null)
                      ? null
                      : _handleBidAction,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: (_isCreatingBid || _isUpdatingBid)
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
                    _editingBid != null ? 'Update' : 'Create',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // User info
          const SizedBox(height: 8),
          if (currentUser == null)
            const Text(
              'Please login to create a bid',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.orange,
              ),
            )
          else if (_editingBid != null)
            const Text(
              'Editing your draft bid',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF707070),
              ),
            )
          else
            const Text(
              'Ready to submit your bid',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF707070),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBidItem(Bid bid) {
    // Check if this bid belongs to current user
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    final isMyBid = currentUser != null && bid.bidder.toString() == currentUser.id;

    // Determine styling based on bid status
    final isDraft = bid.status == 'Draft';
    final isAccepted = bid.status == 'Accepted';
    final isDeclined = bid.status == 'Declined';

    Color backgroundColor;
    Color borderColor;

    if (isMyBid) {
      if (isDraft) {
        backgroundColor = AppColors.primaryBlue.withOpacity(0.1);
        borderColor = AppColors.primaryBlue;
      } else if (isAccepted) {
        backgroundColor = const Color(0xFF00BB61).withOpacity(0.1);
        borderColor = const Color(0xFF00BB61);
      } else if (isDeclined) {
        backgroundColor = const Color(0xFFFF0000).withOpacity(0.1);
        borderColor = const Color(0xFFFF0000);
      } else {
        backgroundColor = Colors.orange.withOpacity(0.1);
        borderColor = Colors.orange;
      }
    } else {
      backgroundColor = AppColors.white;
      borderColor = const Color(0xFFE5E5E5);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: isMyBid ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and actions
          Row(
            children: [
              // Status
              Text(
                bid.status,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 1.0,
                  letterSpacing: 0,
                  color: isAccepted
                      ? const Color(0xFF00BB61)
                      : isDeclined
                      ? const Color(0xFFFF0000)
                      : const Color(0xFF0082B1),
                ),
              ),

              const Spacer(),

              // Your Bid badge
              if (isMyBid)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Your Bid',
                    style: TextStyle(
                      fontSize: 10,
                      color: isMyBid ? Colors.white : AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // Edit button for user's draft bid - ALWAYS SHOW IF DRAFT
              if (isMyBid && isDraft && !_showBidField)
                IconButton(
                  icon: const Icon(Icons.edit, size: 16, color: AppColors.primaryBlue),
                  onPressed: () => _startEditingBid(bid),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Edit bid',
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Bidder Info Row
          Row(
            children: [
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

              // Bidder ID and Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bid #${bid.id}',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Color(0xFF0082B1),
                      ),
                    ),
                    if (isMyBid)
                      const Text(
                        'Submitted by you',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),

              // Bid Amount Container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  'RS ${bid.amount}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    height: 1.0,
                    letterSpacing: 0,
                    color: isMyBid ? Colors.white : AppColors.white,
                  ),
                ),
              ),
            ],
          ),

          // Created time
          const SizedBox(height: 8),
          Text(
            'Created: ${_formatDate(bid.createdAt)}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Rest of the methods remain the same...
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
            Expanded(
              child: _buildInfoItem(
                title: 'Category',
                value: widget.task.category,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoItem(
                title: 'Priority',
                value: widget.task.priority,
              ),
            ),
          ],
        )
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

  Widget _buildBiddingStatusSection() {
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
                'Bidding Status',
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

          if (_isLoadingBids)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_jobBids.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const Icon(
                    Icons.assignment_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No bids for this job yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Be the first to bid!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else
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
}