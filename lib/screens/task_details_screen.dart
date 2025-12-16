import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/task_model.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
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

            // Bidding Section
            _buildBiddingSection(),
          ],
        ),
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
            task.taskID,
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
            task.taskName,
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
          // Category
          Expanded(
            child: _buildInfoItem(
              title: 'Category',
              value: task.category,
            ),
          ),

          const SizedBox(width: 12),

          // Priority
          Expanded(
            child: _buildInfoItem(
              title: 'Priority',
              value: task.priority,
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
              task.description,
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
    // Sample bid data
    final List<Map<String, String>> bids = [
      {
        'name': 'John Doe',
        'amount': 'RS 350',
      },
      {
        'name': 'Sarah Smith',
        'amount': 'RS 400',
      },
      {
        'name': 'Mike Johnson',
        'amount': 'RS 320',
      },
      {
        'name': 'Emily Brown',
        'amount': 'RS 380',
      },
    ];

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
          const SizedBox(height: 12),

          // Bids List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bids.length,
            itemBuilder: (context, index) {
              return _buildBidItem(bids[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBidItem(Map<String, String> bid) {
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
          // Top Row: Profile, Name, and Bid Amount
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

              // Bidder Name
              Text(
                bid['name']!,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 1.0,
                  letterSpacing: 0,
                  color: Color(0xFF0082B1),
                ),
              ),

              const Spacer(),

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
                    bid['amount']!,
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

          const SizedBox(height: 12),

          // Accept and Decline Buttons
          Row(
            children: [
              // Accept Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Handle accept bid
                    print('Accept bid from ${bid['name']}');
                  },
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
                  onTap: () {
                    // Handle decline bid
                    print('Decline bid from ${bid['name']}');
                  },
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
        ],
      ),
    );
  }
}