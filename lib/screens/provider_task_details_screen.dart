


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
//   final FocusNode _bidAmountFocusNode = FocusNode();
//   final BidService _bidService = BidService();
//   bool _isCreatingBid = false;
//   bool _isUpdatingBid = false;
//   bool _isDeletingBid = false;
//   String? _errorMessage;
//   String? _successMessage;
//   List<Bid> _jobBids = [];
//   bool _isLoadingBids = false;
//   Bid? _editingBid; // Store the bid being edited
//   bool _showBidField = false; // Initially hidden if there's a draft bid
//
//   @override
//   void initState() {
//     super.initState();
//     _bidAmountController.addListener(_validateInput);
//     _loadJobBids();
//
//     // Listen for focus changes to center text when editing
//     _bidAmountFocusNode.addListener(() {
//       if (_bidAmountFocusNode.hasFocus && _editingBid != null) {
//         // Center the text when editing starts
//         _centerText();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _bidAmountController.dispose();
//     _bidAmountFocusNode.dispose();
//     super.dispose();
//   }
//
//   // Center the text in the text field
//   void _centerText() {
//     if (_bidAmountController.text.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _bidAmountController.selection = TextSelection.collapsed(
//           offset: _bidAmountController.text.length,
//         );
//       });
//     }
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
//   // Check if there's any draft bid in the list
//   bool get _hasDraftBid {
//     return _jobBids.any((bid) => bid.status == 'Draft');
//   }
//
//   // Get user's draft bid (if exists)
//   Bid? get _userDraftBid {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final currentUser = authProvider.currentUser;
//     if (currentUser == null) return null;
//
//     return _jobBids.firstWhere(
//           (bid) => bid.status == 'Draft' && bid.bidder.toString() == currentUser.id,
//       orElse: () => null as Bid,
//     );
//   }
//
//   // Load bids for this specific job
//   Future<void> _loadJobBids() async {
//     if (widget.job == null) return;
//
//     if (!mounted) return;
//     setState(() {
//       _isLoadingBids = true;
//       _editingBid = null;
//     });
//
//     try {
//       final bids = await _bidService.getAllBids(widget.job!.id);
//
//       if (mounted) {
//         setState(() {
//           _jobBids = bids;
//           // Show bid field only if there's NO draft bid
//           _showBidField = !_hasDraftBid;
//         });
//       }
//     } catch (e) {
//       print('Error loading job bids: $e');
//       if (mounted) {
//         _showError('Failed to load bids: ${e.toString().split('\n').first}');
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
//   // Start editing a bid
//   void _startEditingBid(Bid bid) {
//     setState(() {
//       _editingBid = bid;
//       _showBidField = true;
//       _bidAmountController.text = bid.amount.toString();
//     });
//
//     // Focus and center the text after a small delay
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _bidAmountFocusNode.requestFocus();
//       _centerText();
//     });
//   }
//
//   // Cancel editing
//   void _cancelEditing() {
//     setState(() {
//       _editingBid = null;
//       _showBidField = !_hasDraftBid; // Hide if there's still a draft bid
//       _bidAmountController.clear();
//     });
//     _bidAmountFocusNode.unfocus();
//   }
//
// // Delete a bid
//   Future<void> _deleteBid(Bid bid) async {
//     if (_isDeletingBid) return;
//
//     // Show confirmation dialog
//     final confirmed = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Bid'),
//         content: const Text('Are you sure you want to delete this draft bid?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//
//     if (confirmed != true) return;
//
//     setState(() {
//       _isDeletingBid = true;
//       _errorMessage = null;
//       _successMessage = null;
//     });
//
//     try {
//       // Get job ID from bid
//       final jobId = _parseId(bid.job);
//       if (jobId == null) {
//         throw Exception('Invalid job ID');
//       }
//
//       // Delete the bid using the new method
//       final response = await _bidService.deleteBid(bid.id, jobId);
//
//       if (!mounted) return;
//
//       // REMOVED: Checking response.statusCode - this doesn't exist on CreateBidResponse
//       // The deleteBid method already handles status codes internally
//
//       // Check if the delete was successful based on whether errors exist
//       if (response.errors == null || response.errors!.isEmpty) {
//         // Success! (this covers both 200 and 204 responses)
//         _showSuccess('Bid deleted successfully!');
//
//         // Cancel editing if deleting the bid being edited
//         if (_editingBid?.id == bid.id) {
//           _cancelEditing();
//         }
//
//         // Refresh bids list - CRITICAL: Refresh after successful deletion
//         await _loadJobBids();
//
//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('✅ Bid deleted successfully!'),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );
//       } else {
//         // Handle errors from the response
//         final errors = response.errors!;
//         final errorMsg = errors.values.first is List
//             ? (errors.values.first as List).first.toString()
//             : errors.values.first.toString();
//         _showError('Failed to delete bid: $errorMsg');
//       }
//     } catch (e) {
//       if (!mounted) return;
//       _showError('Error: ${e.toString().split('\n').first}');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isDeletingBid = false;
//         });
//       }
//     }
//   }
//
//   // Helper method to parse ID
//   int? _parseId(dynamic id) {
//     if (id == null) return null;
//     if (id is int) return id;
//     if (id is String) return int.tryParse(id);
//     return null;
//   }
//
//   // Handle create/update bid button press
//   Future<void> _handleBidAction() async {
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
//       if (_editingBid == null) {
//         _isCreatingBid = true;
//       } else {
//         _isUpdatingBid = true;
//       }
//       _errorMessage = null;
//       _successMessage = null;
//     });
//
//     try {
//       if (_editingBid == null) {
//         // Get bidder ID from user profile
//         final bidderId = int.tryParse(currentUser.id);
//         if (bidderId == null) {
//           _showError('Invalid user ID');
//           return;
//         }
//
//         // Get job ID
//         final jobId = widget.job!.id;
//
//         // Create new bid
//         final response = await _bidService.createBid(
//           amount: amount,
//           status: 'Draft',
//           jobId: jobId,
//           bidderId: bidderId,
//         );
//
//         if (!mounted) return;
//
//         if (response.errors != null) {
//           final errors = response.errors!;
//           final errorMsg = errors.values.first is List
//               ? (errors.values.first as List).first.toString()
//               : errors.values.first.toString();
//           _showError('Failed to create bid: $errorMsg');
//         } else if (response.bid != null) {
//           // Success!
//           final bid = response.bid!;
//           _showSuccess('Bid created successfully!');
//
//           _bidAmountController.clear();
//           _bidAmountFocusNode.unfocus();
//
//           // Refresh bids list
//           await _loadJobBids();
//         } else {
//           _showError('Failed to create bid: No response data');
//         }
//       } else {
//         // Update existing bid
//         final response = await _bidService.updateBidWithBidObject(
//           bid: _editingBid!,
//           amount: amount,
//           status: 'Draft',
//         );
//
//         if (!mounted) return;
//
//         if (response.errors != null) {
//           final errors = response.errors!;
//           final errorMsg = errors.values.first is List
//               ? (errors.values.first as List).first.toString()
//               : errors.values.first.toString();
//           _showError('Failed to update bid: $errorMsg');
//         } else if (response.bid != null) {
//           // Success!
//           final bid = response.bid!;
//           _showSuccess('Bid updated successfully!');
//
//           _cancelEditing();
//
//           // Refresh bids list
//           await _loadJobBids();
//         } else {
//           _showError('Failed to update bid: No response data');
//         }
//       }
//     } catch (e) {
//       if (!mounted) return;
//       _showError('Error: ${e.toString().split('\n').first}');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isCreatingBid = false;
//           _isUpdatingBid = false;
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
//     Future.delayed(const Duration(seconds: 5), () {
//       if (mounted) {
//         setState(() {
//           _successMessage = null;
//         });
//       }
//     });
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
//             // Only show My Bid section if there's NO draft bid OR we're editing
//             if (_showBidField || !_hasDraftBid)
//               _buildMyBidSection(currentUser),
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
//           Text(
//             _editingBid != null ? 'Edit Bid' : 'My Bid',
//             style: const TextStyle(
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
//           // Bid input field
//           Row(
//             children: [
//               // Text Field - CENTERED TEXT WHEN EDITING
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
//                   child: Stack(
//                     children: [
//                       // Center-aligned text field for editing
//                       if (_editingBid != null)
//                         Center(
//                           child: TextField(
//                             controller: _bidAmountController,
//                             focusNode: _bidAmountFocusNode,
//                             keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                             textAlign: TextAlign.center, // Center text when editing
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               hintText: 'Enter amount',
//                               hintStyle: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey,
//                               ),
//                               contentPadding: EdgeInsets.symmetric(horizontal: 12),
//                             ),
//                             style: const TextStyle(
//                               fontSize: 16, // Larger font for center display
//                               color: AppColors.black,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//
//                       // Left-aligned text field for creating new bid
//                       if (_editingBid == null)
//                         TextField(
//                           controller: _bidAmountController,
//                           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: 'Enter amount (e.g., 20000)',
//                             hintStyle: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//                           ),
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: AppColors.black,
//                           ),
//                         ),
//
//                       // Cancel edit button (only when editing)
//                       if (_editingBid != null)
//                         Positioned(
//                           right: 8,
//                           top: 0,
//                           bottom: 0,
//                           child: IconButton(
//                             icon: const Icon(Icons.close, size: 18),
//                             onPressed: _cancelEditing,
//                             tooltip: 'Cancel edit',
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: 12),
//
//               // Create/Update Button
//               Container(
//                 width: 100,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: (_isCreatingBid || _isUpdatingBid || currentUser == null)
//                       ? AppColors.primaryBlue.withOpacity(0.5)
//                       : AppColors.primaryBlue,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: TextButton(
//                   onPressed: (_isCreatingBid || _isUpdatingBid || currentUser == null)
//                       ? null
//                       : _handleBidAction,
//                   style: TextButton.styleFrom(
//                     padding: EdgeInsets.zero,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: (_isCreatingBid || _isUpdatingBid)
//                       ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                       : Text(
//                     _editingBid != null ? 'Update' : 'Create',
//                     style: const TextStyle(
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
//           // User info
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
//           else if (_editingBid != null)
//             const Text(
//               'Editing your draft bid',
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w400,
//                 fontSize: 12,
//                 color: Color(0xFF707070),
//               ),
//             )
//           else
//             const Text(
//               'Ready to submit your bid',
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w400,
//                 fontSize: 12,
//                 color: Color(0xFF707070),
//               ),
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
//     // Determine styling based on bid status
//     final isDraft = bid.status == 'Draft';
//     final isAccepted = bid.status == 'Approved';
//     final isDeclined = bid.status == 'Rejected';
//
//     Color backgroundColor;
//     Color borderColor;
//
//     if (isMyBid) {
//       if (isDraft) {
//         backgroundColor = AppColors.primaryBlue.withOpacity(0.1);
//         borderColor = AppColors.primaryBlue;
//       } else if (isAccepted) {
//         backgroundColor = const Color(0xFF00BB61).withOpacity(0.1);
//         borderColor = const Color(0xFF00BB61);
//       } else if (isDeclined) {
//         backgroundColor = const Color(0xFFFF0000).withOpacity(0.1);
//         borderColor = const Color(0xFFFF0000);
//       } else {
//         backgroundColor = Colors.orange.withOpacity(0.1);
//         borderColor = Colors.orange;
//       }
//     } else {
//       backgroundColor = AppColors.white;
//       borderColor = const Color(0xFFE5E5E5);
//     }
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: borderColor,
//           width: isMyBid ? 1.5 : 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Status and actions
//           Row(
//             children: [
//               // Status
//               Text(
//                 bid.status,
//                 style: TextStyle(
//                   fontFamily: 'Plus Jakarta Sans',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                   height: 1.0,
//                   letterSpacing: 0,
//                   color: isAccepted
//                       ? const Color(0xFF00BB61)
//                       : isDeclined
//                       ? const Color(0xFFFF0000)
//                       : const Color(0xFF0082B1),
//                 ),
//               ),
//
//               const Spacer(),
//
//               // Your Bid badge
//               if (isMyBid)
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: borderColor,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     'Your Bid',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: isMyBid ? Colors.white : AppColors.primaryBlue,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//
//               // Action buttons for user's draft bid
//               if (isMyBid && isDraft)
//                 Row(
//                   children: [
//                     // Edit button
//                     IconButton(
//                       icon: const Icon(Icons.edit, size: 16, color: AppColors.primaryBlue),
//                       onPressed: () => _startEditingBid(bid),
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(),
//                       tooltip: 'Edit bid',
//                     ),
//                     const SizedBox(width: 8),
//
//                     // Delete button
//                     _isDeletingBid
//                         ? const SizedBox(
//                       width: 16,
//                       height: 16,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//                       ),
//                     )
//                         : IconButton(
//                       icon: const Icon(Icons.delete, size: 16, color: Colors.red),
//                       onPressed: () => _deleteBid(bid),
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(),
//                       tooltip: 'Delete bid',
//                     ),
//                   ],
//                 ),
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
//               // Bidder ID and Info
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Bid #${bid.id}',
//                       style: const TextStyle(
//                         fontFamily: 'Plus Jakarta Sans',
//                         fontWeight: FontWeight.w500,
//                         fontSize: 12,
//                         height: 1.0,
//                         letterSpacing: 0,
//                         color: Color(0xFF0082B1),
//                       ),
//                     ),
//                     if (isMyBid)
//                       const Text(
//                         'Submitted by you',
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: AppColors.primaryBlue,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//
//               // Bid Amount Container
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: borderColor,
//                   borderRadius: BorderRadius.circular(11),
//                 ),
//                 child: Text(
//                   'RS ${bid.amount}',
//                   style: TextStyle(
//                     fontFamily: 'Plus Jakarta Sans',
//                     fontWeight: FontWeight.w700,
//                     fontSize: 12,
//                     height: 1.0,
//                     letterSpacing: 0,
//                     color: isMyBid ? Colors.white : AppColors.white,
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
//
//   // Rest of the methods remain the same...
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
//         child: Row(
//           children: [
//             Expanded(
//               child: _buildInfoItem(
//                 title: 'Category',
//                 value: widget.task.category,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildInfoItem(
//                 title: 'Priority',
//                 value: widget.task.priority,
//               ),
//             ),
//           ],
//         )
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
//
//           const SizedBox(height: 12),
//
//           if (_isLoadingBids)
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           else if (_jobBids.isEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Column(
//                 children: [
//                   const Icon(
//                     Icons.assignment_outlined,
//                     size: 48,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     'No bids for this job yet',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Be the first to bid!',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: AppColors.primaryBlue,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           else
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
import '../services/job_update_service.dart';
import 'dart:convert';

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
  final FocusNode _bidAmountFocusNode = FocusNode();
  final BidService _bidService = BidService();
  final JobUpdateService _jobUpdateService = JobUpdateService();
  bool _isCreatingBid = false;
  bool _isUpdatingBid = false;
  bool _isDeletingBid = false;
  bool _isUpdatingJob = false;
  String? _errorMessage;
  String? _successMessage;
  List<Bid> _jobBids = [];
  bool _isLoadingBids = false;
  Bid? _editingBid;
  bool _showBidField = false;
  bool _isTaskStarted = false;
  String? _taskStatus; // Track task/job status from server

  @override
  void initState() {
    super.initState();
    _bidAmountController.addListener(_validateInput);
    _loadInitialData();

    _bidAmountFocusNode.addListener(() {
      if (_bidAmountFocusNode.hasFocus && _editingBid != null) {
        _centerText();
      }
    });
  }

  // Load both bids and check task status
  Future<void> _loadInitialData() async {
    await _loadJobBids();
    _checkTaskStatus();
  }

  // Check task/job status and set button state accordingly
  void _checkTaskStatus() {
    // First check if we have job data
    if (widget.job != null) {
      setState(() {
        _taskStatus = widget.job!.status;

        // If task status is Started, set button to END state
        if (_taskStatus == 'Started') {
          _isTaskStarted = true;
        } else if (_taskStatus == 'Ended' || _taskStatus == 'Completed') {
          _isTaskStarted = false;
          // If task is already ended/completed, hide the button
          // We'll handle this in the button visibility check
        }
      });
    }
    // If no job data, check task data
    else if (widget.task.status != null) {
      setState(() {
        _taskStatus = widget.task.status;

        if (_taskStatus == 'Started') {
          _isTaskStarted = true;
        } else if (_taskStatus == 'Ended' || _taskStatus == 'Completed') {
          _isTaskStarted = false;
        }
      });
    }
  }

  @override
  void dispose() {
    _bidAmountController.dispose();
    _bidAmountFocusNode.dispose();
    super.dispose();
  }

  // Check if current user has any approved bid AND task is in appropriate state
  bool get _shouldShowStartEndButton {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;

    if (currentUser == null) return false;

    // Check if user has an approved bid
    final hasApprovedBid = _jobBids.any((bid) =>
    bid.status == 'Approved' &&
        bid.bidder.toString() == currentUser.id
    );

    if (!hasApprovedBid) return false;

    // Check task status
    final status = _taskStatus?.toLowerCase() ?? '';

    // Show button if:
    // 1. Task is "Approved" (ready to start) OR
    // 2. Task is "Started" (ready to end) OR
    // 3. Task status is null/empty (default case)
    // 4. But NOT if task is "Ended", "Completed", or "Cancelled"
    final isEndedOrCompleted = status == 'ended' ||
        status == 'completed' ||
        status == 'cancelled';

    return !isEndedOrCompleted;
  }

  // Check if task is in a state where bidding is allowed
  bool get _isBiddingAllowed {
    final status = _taskStatus?.toLowerCase() ?? '';

    // Allow bidding if task is:
    // - Draft
    // - Pending
    // - Approved (but not started yet)
    // - Empty/null (default)
    final isActiveState = status.isEmpty ||
        status == 'draft' ||
        status == 'pending' ||
        status == 'approved';

    final isInactiveState = status == 'started' ||
        status == 'ended' ||
        status == 'completed' ||
        status == 'cancelled';

    return isActiveState && !isInactiveState;
  }

  void _centerText() {
    if (_bidAmountController.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _bidAmountController.selection = TextSelection.collapsed(
          offset: _bidAmountController.text.length,
        );
      });
    }
  }

  void _validateInput() {
    final text = _bidAmountController.text;
    if (text.isEmpty) return;

    final validText = text.replaceAll(RegExp(r'[^0-9.]'), '');
    final decimalParts = validText.split('.');
    if (decimalParts.length > 2) {
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

  bool get _hasDraftBid {
    return _jobBids.any((bid) => bid.status == 'Draft');
  }

  Bid? get _userDraftBid {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    if (currentUser == null) return null;

    return _jobBids.firstWhere(
          (bid) => bid.status == 'Draft' && bid.bidder.toString() == currentUser.id,
      orElse: () => null as Bid,
    );
  }

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
          // Only show bid field if there's NO draft bid AND bidding is allowed
          _showBidField = !_hasDraftBid && _isBiddingAllowed;
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

  void _startEditingBid(Bid bid) {
    // Don't allow editing if task is started/ended
    if (!_isBiddingAllowed) {
      _showError('Cannot edit bid while task is ${_taskStatus ?? 'in progress'}');
      return;
    }

    setState(() {
      _editingBid = bid;
      _showBidField = true;
      _bidAmountController.text = bid.amount.toString();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bidAmountFocusNode.requestFocus();
      _centerText();
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingBid = null;
      _showBidField = !_hasDraftBid && _isBiddingAllowed;
      _bidAmountController.clear();
    });
    _bidAmountFocusNode.unfocus();
  }

  Future<void> _deleteBid(Bid bid) async {
    // Don't allow deleting if task is started/ended
    if (!_isBiddingAllowed) {
      _showError('Cannot delete bid while task is ${_taskStatus ?? 'in progress'}');
      return;
    }

    if (_isDeletingBid) return;

    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bid'),
        content: const Text('Are you sure you want to delete this draft bid?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeletingBid = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final jobId = _parseId(bid.job);
      if (jobId == null) {
        throw Exception('Invalid job ID');
      }

      final response = await _bidService.deleteBid(bid.id, jobId);

      if (!mounted) return;

      if (response.errors == null || response.errors!.isEmpty) {
        _showSuccess('Bid deleted successfully!');

        if (_editingBid?.id == bid.id) {
          _cancelEditing();
        }

        await _loadJobBids();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Bid deleted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final errors = response.errors!;
        final errorMsg = errors.values.first is List
            ? (errors.values.first as List).first.toString()
            : errors.values.first.toString();
        _showError('Failed to delete bid: $errorMsg');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Error: ${e.toString().split('\n').first}');
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingBid = false;
        });
      }
    }
  }

  int? _parseId(dynamic id) {
    if (id == null) return null;
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
    return null;
  }

  Future<void> _handleBidAction() async {
    // Don't allow creating/updating bids if task is started/ended
    if (!_isBiddingAllowed) {
      _showError('Cannot submit bid while task is ${_taskStatus ?? 'in progress'}');
      return;
    }

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
        final bidderId = int.tryParse(currentUser.id);
        if (bidderId == null) {
          _showError('Invalid user ID');
          return;
        }

        final jobId = widget.job!.id;

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
          _showSuccess('Bid created successfully!');
          _bidAmountController.clear();
          _bidAmountFocusNode.unfocus();
          await _loadJobBids();
        } else {
          _showError('Failed to create bid: No response data');
        }
      } else {
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
          _showSuccess('Bid updated successfully!');
          _cancelEditing();
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

  // Update job status (Start/End) using JobUpdateService
  Future<void> _updateJobStatus(String status) async {
    if (widget.job == null) {
      _showError('Job information is missing');
      return;
    }

    if (_isUpdatingJob) return;

    setState(() {
      _isUpdatingJob = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      print('🔄 Calling JobUpdateService for status: $status');

      // Prepare request body with task data
      final requestBody = {
        "category": widget.task.category,
        "subject": widget.task.taskName,
        "description": widget.task.description,
        "status": status,
        "priority": widget.task.priority,
        "started_at": "",
        "ended_at": ""
      };

      // Call JobUpdateService
      final result = await _jobUpdateService.updateJobStatus(
        jobId: widget.job!.id,
        status: status,
        body: requestBody,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        setState(() {
          _isTaskStarted = (status == 'Started');
          _taskStatus = status; // Update local status
        });

        _showSuccess('Job ${status.toLowerCase()} successfully!');

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Job ${status.toLowerCase()} successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Refresh the page
        await _loadJobBids();

      } else {
        final errorMessage = result['message'] ?? 'Unknown error';
        _showError('Failed to update job: $errorMessage');
      }
    } catch (e) {
      print('💥 Error updating job: $e');
      if (!mounted) return;
      _showError('Error: ${e.toString().split('\n').first}');

      // Revert the button state if API fails
      if (status == 'Started') {
        setState(() {
          _isTaskStarted = false;
        });
      } else {
        setState(() {
          _isTaskStarted = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingJob = false;
        });
      }
    }
  }

  void _handleStartEndButton() {
    if (_isUpdatingJob) return;

    final newStatus = _isTaskStarted ? 'Ended' : 'Started';
    _updateJobStatus(newStatus);
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

  // Build the Start/End button widget with right padding
  Widget _buildStartEndButton() {
    // Determine button state based on task status
    final shouldShowEnd = _taskStatus == 'Started';

    return Container(
      margin: const EdgeInsets.only(right: 16), // Right padding
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: shouldShowEnd ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: shouldShowEnd ? Colors.red : Colors.green,
          width: 1.5,
        ),
      ),
      child: _isUpdatingJob
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      )
          : TextButton(
        onPressed: _handleStartEndButton,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              shouldShowEnd ? Icons.stop_circle : Icons.play_arrow,
              size: 16,
              color: shouldShowEnd ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 4),
            Text(
              shouldShowEnd ? 'END' : 'START',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: shouldShowEnd ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
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
            _buildCategoryPrioritySection(),

            // Show task status badge
            if (_taskStatus != null && _taskStatus!.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getStatusColor(_taskStatus!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(_taskStatus!),
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _taskStatus!.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),
            _buildDescriptionSection(),
            const SizedBox(height: 20),

            // Only show My Bid section if:
            // 1. There's NO draft bid OR we're editing
            // 2. AND bidding is allowed (task not started/ended)
            if ((_showBidField || !_hasDraftBid) && _isBiddingAllowed)
              _buildMyBidSection(currentUser),

            // Show message if bidding is not allowed
            if (!_isBiddingAllowed && _taskStatus != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Bidding is closed. Task status: ${_taskStatus!.toUpperCase()}',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (_errorMessage != null)
              _buildMessageWidget(_errorMessage!, true),
            if (_successMessage != null)
              _buildMessageWidget(_successMessage!, false),
            const SizedBox(height: 20),
            _buildBiddingStatusSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper methods for status display
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'started':
        return Colors.green;
      case 'ended':
      case 'completed':
        return Colors.purple;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Icons.drafts;
      case 'pending':
        return Icons.pending;
      case 'approved':
        return Icons.check_circle;
      case 'started':
        return Icons.play_arrow;
      case 'ended':
      case 'completed':
        return Icons.check;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  // Rest of the widget methods remain the same...
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
          Row(
            children: [
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
                  child: Stack(
                    children: [
                      if (_editingBid != null)
                        Center(
                          child: TextField(
                            controller: _bidAmountController,
                            focusNode: _bidAmountFocusNode,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter amount',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (_editingBid == null)
                        TextField(
                          controller: _bidAmountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter amount (e.g., 20000)',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                      if (_editingBid != null)
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: _cancelEditing,
                            tooltip: 'Cancel edit',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    final isMyBid = currentUser != null && bid.bidder.toString() == currentUser.id;
    final isDraft = bid.status == 'Draft';
    final isAccepted = bid.status == 'Approved';
    final isDeclined = bid.status == 'Rejected';

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
          Row(
            children: [
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
              // Only show edit/delete if task allows bidding
              if (isMyBid && isDraft && _isBiddingAllowed)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 16, color: AppColors.primaryBlue),
                      onPressed: () => _startEditingBid(bid),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Edit bid',
                    ),
                    const SizedBox(width: 8),
                    _isDeletingBid
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                        : IconButton(
                      icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                      onPressed: () => _deleteBid(bid),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Delete bid',
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
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
        // Show button only if user has approved bid AND task is in appropriate state
        if (_shouldShowStartEndButton) _buildStartEndButton(),
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
        ));
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
}*/



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/bid_model.dart';
import '../models/job_model.dart';
import '../models/task_model.dart';
import '../models/auth_model.dart';
import '../services/bid_service.dart';
import '../providers/auth_provider.dart';
import '../services/job_update_service.dart';
import 'dart:convert';

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
  final FocusNode _bidAmountFocusNode = FocusNode();
  final BidService _bidService = BidService();
  final JobUpdateService _jobUpdateService = JobUpdateService();
  bool _isCreatingBid = false;
  bool _isUpdatingBid = false;
  bool _isDeletingBid = false;
  bool _isUpdatingJob = false;
  String? _errorMessage;
  String? _successMessage;
  List<Bid> _jobBids = [];
  bool _isLoadingBids = false;
  Bid? _editingBid;
  bool _showBidField = false;
  bool _isTaskStarted = false;
  String? _taskStatus;

  @override
  void initState() {
    super.initState();
    _bidAmountController.addListener(_validateInput);
    _loadInitialData();

    _bidAmountFocusNode.addListener(() {
      if (_bidAmountFocusNode.hasFocus && _editingBid != null) {
        _centerText();
      }
    });
  }

  Future<void> _loadInitialData() async {
    await _loadJobBids();
    _checkTaskStatus();
  }

  void _checkTaskStatus() {
    // Get task status from job or task
    if (widget.job != null && widget.job!.status != null) {
      setState(() {
        _taskStatus = widget.job!.status;
        // Set button state based on task status
        _isTaskStarted = _taskStatus == 'Started';
      });
    } else if (widget.task.status != null) {
      setState(() {
        _taskStatus = widget.task.status;
        _isTaskStarted = _taskStatus == 'Started';
      });
    }
  }

  @override
  void dispose() {
    _bidAmountController.dispose();
    _bidAmountFocusNode.dispose();
    super.dispose();
  }

  // SIMPLIFIED: Show button only if user has approved bid
  bool get _shouldShowStartEndButton {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;

    if (currentUser == null) return false;

    // Check if user has an approved bid
    final hasApprovedBid = _jobBids.any((bid) =>
    bid.status == 'Approved' &&
        bid.bidder.toString() == currentUser.id
    );

    if (!hasApprovedBid) return false;

    // Only show button if task is not Ended/Completed
    final status = _taskStatus?.toLowerCase() ?? '';
    return status != 'ended' && status != 'completed';
  }

  // SIMPLIFIED: Only close bidding when task is Started or Ended
  bool get _isBiddingAllowed {
    final status = _taskStatus?.toLowerCase() ?? '';

    // Close bidding ONLY when task is Started or Ended
    // Allow bidding for all other statuses (Draft, Pending, Approved, etc.)
    return status != 'started' && status != 'ended';
  }

  void _centerText() {
    if (_bidAmountController.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _bidAmountController.selection = TextSelection.collapsed(
          offset: _bidAmountController.text.length,
        );
      });
    }
  }

  void _validateInput() {
    final text = _bidAmountController.text;
    if (text.isEmpty) return;

    final validText = text.replaceAll(RegExp(r'[^0-9.]'), '');
    final decimalParts = validText.split('.');
    if (decimalParts.length > 2) {
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

  bool get _hasDraftBid {
    return _jobBids.any((bid) => bid.status == 'Draft');
  }

  Bid? get _userDraftBid {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    if (currentUser == null) return null;

    return _jobBids.firstWhere(
          (bid) => bid.status == 'Draft' && bid.bidder.toString() == currentUser.id,
      orElse: () => null as Bid,
    );
  }

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
          // Only show bid field if there's NO draft bid AND bidding is allowed
          _showBidField = !_hasDraftBid && _isBiddingAllowed;
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

  void _startEditingBid(Bid bid) {
    // Don't allow editing if task is started/ended
    if (!_isBiddingAllowed) {
      _showError('Cannot edit bid while task is ${_taskStatus ?? 'in progress'}');
      return;
    }

    setState(() {
      _editingBid = bid;
      _showBidField = true;
      _bidAmountController.text = bid.amount.toString();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bidAmountFocusNode.requestFocus();
      _centerText();
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingBid = null;
      _showBidField = !_hasDraftBid && _isBiddingAllowed;
      _bidAmountController.clear();
    });
    _bidAmountFocusNode.unfocus();
  }

  Future<void> _deleteBid(Bid bid) async {
    // Don't allow deleting if task is started/ended
    if (!_isBiddingAllowed) {
      _showError('Cannot delete bid while task is ${_taskStatus ?? 'in progress'}');
      return;
    }

    if (_isDeletingBid) return;

    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bid'),
        content: const Text('Are you sure you want to delete this draft bid?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeletingBid = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final jobId = _parseId(bid.job);
      if (jobId == null) {
        throw Exception('Invalid job ID');
      }

      final response = await _bidService.deleteBid(bid.id, jobId);

      if (!mounted) return;

      if (response.errors == null || response.errors!.isEmpty) {
        _showSuccess('Bid deleted successfully!');

        if (_editingBid?.id == bid.id) {
          _cancelEditing();
        }

        await _loadJobBids();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Bid deleted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final errors = response.errors!;
        final errorMsg = errors.values.first is List
            ? (errors.values.first as List).first.toString()
            : errors.values.first.toString();
        _showError('Failed to delete bid: $errorMsg');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Error: ${e.toString().split('\n').first}');
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingBid = false;
        });
      }
    }
  }

  int? _parseId(dynamic id) {
    if (id == null) return null;
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
    return null;
  }

  Future<void> _handleBidAction() async {
    // Don't allow creating/updating bids if task is started/ended
    if (!_isBiddingAllowed) {
      _showError('Cannot submit bid while task is ${_taskStatus ?? 'in progress'}');
      return;
    }

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
        final bidderId = int.tryParse(currentUser.id);
        if (bidderId == null) {
          _showError('Invalid user ID');
          return;
        }

        final jobId = widget.job!.id;

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
          _showSuccess('Bid created successfully!');
          _bidAmountController.clear();
          _bidAmountFocusNode.unfocus();
          await _loadJobBids();
        } else {
          _showError('Failed to create bid: No response data');
        }
      } else {
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
          _showSuccess('Bid updated successfully!');
          _cancelEditing();
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

  Future<void> _updateJobStatus(String status) async {
    if (widget.job == null) {
      _showError('Job information is missing');
      return;
    }

    if (_isUpdatingJob) return;

    setState(() {
      _isUpdatingJob = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      print('🔄 Calling JobUpdateService for status: $status');

      final requestBody = {
        "category": widget.task.category,
        "subject": widget.task.taskName,
        "description": widget.task.description,
        "status": status,
        "priority": widget.task.priority,
        "started_at": "",
        "ended_at": ""
      };

      final result = await _jobUpdateService.updateJobStatus(
        jobId: widget.job!.id,
        status: status,
        body: requestBody,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        setState(() {
          _isTaskStarted = (status == 'Started');
          _taskStatus = status;
        });

        _showSuccess('Job ${status.toLowerCase()} successfully!');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Job ${status.toLowerCase()} successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        await _loadJobBids();

      } else {
        final errorMessage = result['message'] ?? 'Unknown error';
        _showError('Failed to update job: $errorMessage');
      }
    } catch (e) {
      print('💥 Error updating job: $e');
      if (!mounted) return;
      _showError('Error: ${e.toString().split('\n').first}');

      if (status == 'Started') {
        setState(() {
          _isTaskStarted = false;
        });
      } else {
        setState(() {
          _isTaskStarted = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingJob = false;
        });
      }
    }
  }

  void _handleStartEndButton() {
    if (_isUpdatingJob) return;

    final newStatus = _isTaskStarted ? 'Ended' : 'Started';
    _updateJobStatus(newStatus);
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

  Widget _buildStartEndButton() {
    // Button state based on task status
    final shouldShowEnd = _taskStatus == 'Started';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: shouldShowEnd ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: shouldShowEnd ? Colors.red : Colors.green,
          width: 1.5,
        ),
      ),
      child: _isUpdatingJob
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      )
          : TextButton(
        onPressed: _handleStartEndButton,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              shouldShowEnd ? Icons.stop_circle : Icons.play_arrow,
              size: 16,
              color: shouldShowEnd ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 4),
            Text(
              shouldShowEnd ? 'END' : 'START',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: shouldShowEnd ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
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
            _buildCategoryPrioritySection(),

            // Task Status Indicator
            if (_taskStatus != null && _taskStatus!.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getStatusColor(_taskStatus!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'STATUS: ${_taskStatus!.toUpperCase()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            const SizedBox(height: 20),
            _buildDescriptionSection(),
            const SizedBox(height: 20),

            // Show My Bid section only if bidding is allowed
            if ((_showBidField || !_hasDraftBid) && _isBiddingAllowed)
              _buildMyBidSection(currentUser),

            // Show bidding closed message if task is Started or Ended
            if (!_isBiddingAllowed && (_taskStatus == 'Started' || _taskStatus == 'Ended'))
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Bidding is closed. Task is ${_taskStatus!.toUpperCase()}',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (_errorMessage != null)
              _buildMessageWidget(_errorMessage!, true),
            if (_successMessage != null)
              _buildMessageWidget(_successMessage!, false),
            const SizedBox(height: 20),
            _buildBiddingStatusSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'started':
        return Colors.green;
      case 'ended':
        return Colors.purple;
      case 'approved':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Rest of the widget methods remain exactly the same as before...
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
          Row(
            children: [
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
                  child: Stack(
                    children: [
                      if (_editingBid != null)
                        Center(
                          child: TextField(
                            controller: _bidAmountController,
                            focusNode: _bidAmountFocusNode,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter amount',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (_editingBid == null)
                        TextField(
                          controller: _bidAmountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter amount (e.g., 20000)',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                      if (_editingBid != null)
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: _cancelEditing,
                            tooltip: 'Cancel edit',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    final isMyBid = currentUser != null && bid.bidder.toString() == currentUser.id;
    final isDraft = bid.status == 'Draft';
    final isAccepted = bid.status == 'Approved';
    final isDeclined = bid.status == 'Rejected';

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
          Row(
            children: [
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
              // Only show edit/delete if bidding is allowed
              if (isMyBid && isDraft && _isBiddingAllowed)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 16, color: AppColors.primaryBlue),
                      onPressed: () => _startEditingBid(bid),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Edit bid',
                    ),
                    const SizedBox(width: 8),
                    _isDeletingBid
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                        : IconButton(
                      icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                      onPressed: () => _deleteBid(bid),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Delete bid',
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
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
        if (_shouldShowStartEndButton) _buildStartEndButton(),
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
        ));
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