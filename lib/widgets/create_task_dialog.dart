// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../constants/colors.dart';
// import '../models/task_model.dart';
// import '../widgets/custom_button.dart';
//
// class CreateTaskDialog extends StatefulWidget {
//   final Function(Task) onTaskCreated;
//   final String nextTaskId;
//
//   const CreateTaskDialog({
//     super.key,
//     required this.onTaskCreated,
//     required this.nextTaskId,
//   });
//
//   @override
//   State<CreateTaskDialog> createState() => _CreateTaskDialogState();
// }
//
// class _CreateTaskDialogState extends State<CreateTaskDialog> {
//   final List<String> _categories = [
//     'Home Cleaning',
//     'Plumbing',
//     'Electrical',
//     'Painting',
//     'Carpentry',
//     'Gardening',
//     'Moving',
//     'Other'
//   ];
//
//   final List<String> _priorities = [
//     'Low',
//     'Medium',
//     'High',
//     'Urgent'
//   ];
//
//   String? _selectedCategory;
//   String? _selectedPriority;
//   final _subjectController = TextEditingController();
//   final _descriptionController = TextEditingController();
//
//   @override
//   void dispose() {
//     _subjectController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     // Calculate responsive dimensions
//     final dialogWidth = screenWidth * 0.85; // 85% of screen width
//     final dialogHeight = screenHeight * 0.7; // 70% of screen height
//
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Container(
//         width: dialogWidth,
//         height: dialogHeight,
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             // App Bar
//             _buildAppBar(),
//             // Content
//             Expanded(
//               child: _buildContent(dialogWidth),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAppBar() {
//     return Container(
//       height: 50,
//       decoration: const BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(12),
//           topRight: Radius.circular(12),
//         ),
//       ),
//       child: Stack(
//         children: [
//           // Back Button
//           Align(
//             alignment: Alignment.centerLeft,
//             child: IconButton(
//               icon: const Icon(
//                 Icons.arrow_back_ios_new,
//                 size: 18,
//                 color: Color(0xFF555555),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ),
//           // Title
//           const Center(
//             child: Text(
//               'Create New Task',
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//                 height: 1.0,
//                 letterSpacing: 0,
//                 color: Color(0xFF555555),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContent(double dialogWidth) {
//     return Container(
//       color: const Color(0xFFFAFEFF),
//       padding: EdgeInsets.symmetric(
//         horizontal: dialogWidth * 0.05,
//         vertical: 16,
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Task ID Section
//             _buildTaskIdSection(dialogWidth),
//
//             const SizedBox(height: 20),
//
//             // Category and Priority Row
//             _buildCategoryPriorityRow(dialogWidth),
//
//             const SizedBox(height: 20),
//
//             // Subject Section
//             _buildSubjectSection(dialogWidth),
//
//             const SizedBox(height: 20),
//
//             // Description Section
//             _buildDescriptionSection(dialogWidth),
//
//             const SizedBox(height: 30),
//
//             // Place Request Button
//             _buildPlaceRequestButton(dialogWidth),
//
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTaskIdSection(double dialogWidth) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Task ID',
//           style: TextStyle(
//             fontFamily: 'Plus Jakarta Sans',
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//             height: 1.0,
//             letterSpacing: 0,
//             color: Color(0xFF676767),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             Container(
//               width: dialogWidth * 0.35,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: const Color(0xFF727272),
//                   width: 1,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   widget.nextTaskId,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: AppColors.black,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//             const Spacer(),
//             GestureDetector(
//               onTap: () {
//                 print('Attachment button pressed');
//               },
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: const Color(0xFF727272),
//                     width: 1,
//                   ),
//                 ),
//                 child: Center(
//                   child: SvgPicture.asset(
//                     'assets/attachmentSVG.svg',
//                     width: 18,
//                     height: 18,
//                     placeholderBuilder: (BuildContext context) => const Icon(
//                       Icons.attach_file,
//                       size: 18,
//                       color: AppColors.primaryBlue,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCategoryPriorityRow(double dialogWidth) {
//     return Row(
//       children: [
//         // Category Dropdown
//         Expanded(
//           child: _buildDropdown(
//             title: 'Category',
//             value: _selectedCategory,
//             items: _categories,
//             onChanged: (value) {
//               setState(() {
//                 _selectedCategory = value;
//               });
//             },
//           ),
//         ),
//         const SizedBox(width: 12),
//         // Priority Dropdown
//         Expanded(
//           child: _buildDropdown(
//             title: 'Priority',
//             value: _selectedPriority,
//             items: _priorities,
//             onChanged: (value) {
//               setState(() {
//                 _selectedPriority = value;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDropdown({
//     required String title,
//     required String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
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
//           height: 48,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: const Color(0xFF727272),
//               width: 1,
//             ),
//           ),
//           child: DropdownButtonFormField<String>(
//             value: value,
//             items: items.map((String item) {
//               return DropdownMenuItem<String>(
//                 value: item,
//                 child: Text(
//                   item,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: AppColors.black,
//                   ),
//                 ),
//               );
//             }).toList(),
//             onChanged: onChanged,
//             decoration: const InputDecoration(
//               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               border: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               hintText: 'Select',
//               hintStyle: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//             icon: const Padding(
//               padding: EdgeInsets.only(right: 8),
//               child: Icon(
//                 Icons.arrow_drop_down,
//                 size: 24,
//                 color: Color(0xFF727272),
//               ),
//             ),
//             isExpanded: true,
//             dropdownColor: AppColors.white,
//             style: const TextStyle(
//               fontSize: 14,
//               color: AppColors.black,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSubjectSection(double dialogWidth) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Subject',
//           style: TextStyle(
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
//           height: 48,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: const Color(0xFF727272),
//               width: 1,
//             ),
//           ),
//           child: TextField(
//             controller: _subjectController,
//             style: const TextStyle(
//               fontSize: 14,
//               color: AppColors.black,
//             ),
//             decoration: const InputDecoration(
//               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               border: InputBorder.none,
//               hintText: 'Enter subject',
//               hintStyle: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDescriptionSection(double dialogWidth) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Description',
//           style: TextStyle(
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
//           height: 120,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: const Color(0xFF727272),
//               width: 1,
//             ),
//           ),
//           child: TextField(
//             controller: _descriptionController,
//             maxLines: 5,
//             style: const TextStyle(
//               fontSize: 14,
//               color: AppColors.black,
//             ),
//             decoration: const InputDecoration(
//               contentPadding: EdgeInsets.all(12),
//               border: InputBorder.none,
//               hintText: 'Enter task description...',
//               hintStyle: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//               alignLabelWithHint: true,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPlaceRequestButton(double dialogWidth) {
//     return Center(
//       child: SizedBox(
//         width: dialogWidth * 0.6,
//         child: CustomButton(
//           width: double.infinity,
//           height: 48,
//           backgroundColor: AppColors.primaryBlue,
//           borderRadius: 8,
//           child: const Text(
//             'Place Request',
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//               color: AppColors.white,
//             ),
//           ),
//           onPressed: () {
//             _placeRequest();
//           },
//         ),
//       ),
//     );
//   }
//
//   void _placeRequest() {
//     // Validate and submit the task
//     if (_selectedCategory == null) {
//       _showError('Please select Category');
//       return;
//     }
//     if (_selectedPriority == null) {
//       _showError('Please select Priority');
//       return;
//     }
//     if (_subjectController.text.isEmpty) {
//       _showError('Please enter Subject');
//       return;
//     }
//     if (_descriptionController.text.isEmpty) {
//       _showError('Please enter Description');
//       return;
//     }
//
//     // Create new task
//     final newTask = Task(
//       taskID: widget.nextTaskId,
//       taskName: _subjectController.text,
//       status: 'Open',
//       description: _descriptionController.text,
//       noOfBids: 0,
//       minimumBid: '\$0',
//       date: DateTime.now(),
//       category: _selectedCategory!,
//       priority: _selectedPriority!,
//     );
//
//     // Call the callback to add task to parent list
//     widget.onTaskCreated(newTask);
//
//     // Show success message and close dialog
//     _showSuccess();
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
//
//   void _showSuccess() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Task created successfully!'),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//     Navigator.of(context).pop();
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import '../models/task_model.dart';
import '../widgets/custom_button.dart';
import '../services/meta_service.dart';
import '../services/job_creation_service.dart';

class CreateTaskDialog extends StatefulWidget {
  final Function(Task) onTaskCreated;
  final String nextTaskId;

  const CreateTaskDialog({
    super.key,
    required this.onTaskCreated,
    required this.nextTaskId,
  });

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final MetaService _metaService = MetaService();
  final JobCreationService _jobCreationService = JobCreationService();

  List<String> _categories = [];
  List<String> _priorities = [];

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;

  String? _selectedCategory;
  String? _selectedPriority;
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEnums();
  }

  Future<void> _loadEnums() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔄 Loading enums...');

      // Load categories and priorities in parallel
      final categoriesFuture = _metaService.getCategories();
      final prioritiesFuture = _metaService.getPriorities();

      final results = await Future.wait([categoriesFuture, prioritiesFuture]);

      setState(() {
        _categories = results[0];
        _priorities = results[1];
        _isLoading = false;

        // Set default values if available
        if (_categories.isNotEmpty) {
          _selectedCategory = _categories.first;
        }
        if (_priorities.isNotEmpty) {
          _selectedPriority = _priorities.first;
        }
      });

      print('✅ Loaded ${_categories.length} categories and ${_priorities.length} priorities');
    } catch (e) {
      print('❌ Error loading enums: $e');
      setState(() {
        _errorMessage = 'Failed to load categories and priorities';
        _isLoading = false;
      });

      // Set default fallback values
      _categories = [
        'Plumbing', 'Electrical', 'Carpentry', 'Cleaning', 'Painting',
        'Landscaping', 'Roofing', 'Flooring', 'HVAC', 'Appliance Repair',
        'General Contracting', 'Other'
      ];

      _priorities = ['Low', 'Medium', 'High'];
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final dialogWidth = screenWidth * 0.85;
    final dialogHeight = screenHeight * 0.7;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _buildContent(dialogWidth),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Color(0xFF555555),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          const Center(
            child: Text(
              'Create New Task',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.0,
                letterSpacing: 0,
                color: Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(double dialogWidth) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return Container(
      color: const Color(0xFFFAFEFF),
      padding: EdgeInsets.symmetric(
        horizontal: dialogWidth * 0.05,
        vertical: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task ID Section
            // _buildTaskIdSection(dialogWidth),
            //
            // const SizedBox(height: 20),

            // Category and Priority Row
            _buildCategoryPriorityRow(dialogWidth),

            const SizedBox(height: 20),

            // Subject Section
            _buildSubjectSection(dialogWidth),

            const SizedBox(height: 20),

            // Description Section
            _buildDescriptionSection(dialogWidth),

            // Error/Success Messages
            if (_errorMessage != null) _buildMessageWidget(_errorMessage!, true),
            if (_successMessage != null) _buildMessageWidget(_successMessage!, false),

            const SizedBox(height: 30),

            // Place Request Button
            _buildPlaceRequestButton(dialogWidth),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
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
            'Loading categories...',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load data',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEnums,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageWidget(String message, bool isError) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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

  Widget _buildTaskIdSection(double dialogWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task ID',
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
        Row(
          children: [
            Container(
              width: dialogWidth * 0.35,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF727272),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  widget.nextTaskId,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                print('Attachment button pressed');
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF727272),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/attachmentSVG.svg',
                    width: 18,
                    height: 18,
                    placeholderBuilder: (BuildContext context) => const Icon(
                      Icons.attach_file,
                      size: 18,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryPriorityRow(double dialogWidth) {
    return Row(
      children: [
        // Category Dropdown
        Expanded(
          child: _buildDropdown(
            title: 'Category',
            value: _selectedCategory,
            items: _categories,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        // Priority Dropdown
        Expanded(
          child: _buildDropdown(
            title: 'Priority',
            value: _selectedPriority,
            items: _priorities,
            onChanged: (value) {
              setState(() {
                _selectedPriority = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String title,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
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
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF727272),
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Select',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            icon: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.arrow_drop_down,
                size: 24,
                color: Color(0xFF727272),
              ),
            ),
            isExpanded: true,
            dropdownColor: AppColors.white,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectSection(double dialogWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subject',
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
            controller: _subjectController,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.black,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: InputBorder.none,
              hintText: 'Enter subject',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(double dialogWidth) {
    return Column(
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
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF727272),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 5,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.black,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(12),
              border: InputBorder.none,
              hintText: 'Enter task description...',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              alignLabelWithHint: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceRequestButton(double dialogWidth) {
    return Center(
      child: SizedBox(
        width: dialogWidth * 0.6,
        child: CustomButton(
          width: double.infinity,
          height: 48,
          backgroundColor: _isSubmitting
              ? AppColors.primaryBlue.withOpacity(0.5)
              : AppColors.primaryBlue,
          borderRadius: 8,
          child: _isSubmitting
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : const Text(
            'Place Request',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
          onPressed: _isSubmitting ? () {} : () => _placeRequest(),
        ),
      ),
    );
  }

  // Future<void> _placeRequest() async {
  //   // Validate inputs
  //   if (_selectedCategory == null) {
  //     _showError('Please select Category');
  //     return;
  //   }
  //   if (_selectedPriority == null) {
  //     _showError('Please select Priority');
  //     return;
  //   }
  //   if (_subjectController.text.isEmpty) {
  //     _showError('Please enter Subject');
  //     return;
  //   }
  //   if (_descriptionController.text.isEmpty) {
  //     _showError('Please enter Description');
  //     return;
  //   }
  //
  //   setState(() {
  //     _isSubmitting = true;
  //     _errorMessage = null;
  //     _successMessage = null;
  //   });
  //
  //   try {
  //     // Call API to create job
  //     final response = await _jobCreationService.createJob(
  //       taskId: widget.nextTaskId,
  //       category: _selectedCategory!,
  //       subject: _subjectController.text,
  //       description: _descriptionController.text,
  //       priority: _selectedPriority!,
  //     );
  //
  //     if (mounted) {
  //       setState(() {
  //         _isSubmitting = false;
  //         _successMessage = 'Task created successfully! ID: ${response['id']}';
  //       });
  //
  //       // Create local task object
  //       final newTask = Task(
  //         taskID: widget.nextTaskId,
  //         taskName: _subjectController.text,
  //         status: 'Open',
  //         description: _descriptionController.text,
  //         noOfBids: 0,
  //         minimumBid: '\$0',
  //         date: DateTime.now(),
  //         category: _selectedCategory!,
  //         priority: _selectedPriority!,
  //       );
  //
  //       // Call the callback to add task to parent list
  //       widget.onTaskCreated(newTask);
  //
  //       // Close dialog after delay
  //       Future.delayed(const Duration(seconds: 2), () {
  //         if (mounted) {
  //           Navigator.of(context).pop();
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         _isSubmitting = false;
  //         _errorMessage = 'Failed to create task: ${e.toString().split('\n').first}';
  //       });
  //     }
  //   }
  // }

  Future<void> _placeRequest() async {
    // Validate inputs
    if (_selectedCategory == null) {
      _showError('Please select Category');
      return;
    }
    if (_selectedPriority == null) {
      _showError('Please select Priority');
      return;
    }
    if (_subjectController.text.isEmpty) {
      _showError('Please enter Subject');
      return;
    }
    if (_descriptionController.text.isEmpty) {
      _showError('Please enter Description');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      // Call API to create job
      final response = await _jobCreationService.createJob(
        taskId: widget.nextTaskId,
        category: _selectedCategory!,
        subject: _subjectController.text,
        description: _descriptionController.text,
        priority: _selectedPriority!,
      );

      if (mounted) {
        // Create local task object
        final newTask = Task(
          taskID: widget.nextTaskId,
          taskName: _subjectController.text,
          status: 'Waiting', // Set initial status as 'Waiting'
          description: _descriptionController.text,
          noOfBids: 0,
          minimumBid: '\$0',
          date: DateTime.now(),
          category: _selectedCategory!,
          priority: _selectedPriority!,
        );

        // Call the callback to add task to parent list
        widget.onTaskCreated(newTask);

        // Show success message briefly and then close
        setState(() {
          _isSubmitting = false;
          _successMessage = 'Task created successfully! ID: ${response['id']}';
        });

        // Wait for 1.5 seconds to show success message, then close
        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'Failed to create task: ${e.toString().split('\n').first}';
        });
      }
    }
  }


  void _showError(String message) {
    setState(() {
      _errorMessage = message;
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
}