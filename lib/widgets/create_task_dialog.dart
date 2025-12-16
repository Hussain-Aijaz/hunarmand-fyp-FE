import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import '../models/task_model.dart';
import '../widgets/custom_button.dart';

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
  final List<String> _categories = [
    'Home Cleaning',
    'Plumbing',
    'Electrical',
    'Painting',
    'Carpentry',
    'Gardening',
    'Moving',
    'Other'
  ];

  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
    'Urgent'
  ];

  String? _selectedCategory;
  String? _selectedPriority;
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

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

    // Calculate responsive dimensions
    final dialogWidth = screenWidth * 0.85; // 85% of screen width
    final dialogHeight = screenHeight * 0.7; // 70% of screen height

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
            // App Bar
            _buildAppBar(),
            // Content
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
          // Back Button
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
          // Title
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
            _buildTaskIdSection(dialogWidth),

            const SizedBox(height: 20),

            // Category and Priority Row
            _buildCategoryPriorityRow(dialogWidth),

            const SizedBox(height: 20),

            // Subject Section
            _buildSubjectSection(dialogWidth),

            const SizedBox(height: 20),

            // Description Section
            _buildDescriptionSection(dialogWidth),

            const SizedBox(height: 30),

            // Place Request Button
            _buildPlaceRequestButton(dialogWidth),

            const SizedBox(height: 16),
          ],
        ),
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
          backgroundColor: AppColors.primaryBlue,
          borderRadius: 8,
          child: const Text(
            'Place Request',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
          onPressed: () {
            _placeRequest();
          },
        ),
      ),
    );
  }

  void _placeRequest() {
    // Validate and submit the task
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

    // Create new task
    final newTask = Task(
      taskID: widget.nextTaskId,
      taskName: _subjectController.text,
      status: 'Open',
      description: _descriptionController.text,
      noOfBids: 0,
      minimumBid: '\$0',
      date: DateTime.now(),
      category: _selectedCategory!,
      priority: _selectedPriority!,
    );

    // Call the callback to add task to parent list
    widget.onTaskCreated(newTask);

    // Show success message and close dialog
    _showSuccess();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task created successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop();
  }
}