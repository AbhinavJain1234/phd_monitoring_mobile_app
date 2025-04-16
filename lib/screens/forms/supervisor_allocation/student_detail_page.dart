import 'dart:math';

import 'package:flutter/material.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/collapsible_card.dart';

class StudentDetailsPage extends StatelessWidget {
  const StudentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Application Status'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStatusTimeline(),
                ],
              ),
            ),

            // Content Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Student Section
                  CollapsibleCard(
                    title: 'Student Details',
                    color: Colors.green,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                            Icons.assignment_ind, 'Roll Number', '102203465'),
                        _buildDetailRow(
                            Icons.person, 'Name', 'Akarsh Srivastava'),
                        _buildDetailRow(Icons.calendar_today, 'Admission Date',
                            'March 31, 2024'),
                        _buildDetailRow(Icons.email, 'Email', 'stu5@gmail.com'),
                        _buildDetailRow(Icons.phone, 'Mobile', '941548683'),
                        const SizedBox(height: 16),
                        const Text(
                          'Research Areas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildChipsList(['Radiowaves', 'AI', 'Cybersecurity']),
                        const SizedBox(height: 16),
                        const Text(
                          'Tentative Supervisors',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSupervisorsList([
                          'sup2 Sharma',
                          'sup4 1',
                          'sup5 1',
                          'sup8 1',
                          'sup7 1',
                          'sup6 1',
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // PhD Coordinator Section
                  CollapsibleCard(
                    title: 'PhD Coordinator Review',
                    color: Colors.blue,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusWithDate(
                          'Status: Recommended',
                          DateTime.now().subtract(const Duration(days: 2)),
                        ),
                        _buildCommentSection('N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // HOD Section
                  CollapsibleCard(
                    title: 'HOD Review',
                    color: Colors.indigo,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusWithDate(
                          'Status: Approved',
                          DateTime.now().subtract(const Duration(days: 1)),
                        ),
                        _buildCommentSection('Approved and Alloted'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildRecommendationForm(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TextOverflowHelper {
  static String truncateWithEllipsis(String text, int maxLength) {
    return text.length <= maxLength
        ? text
        : '${text.substring(0, min(maxLength, text.length))}...';
  }
}

Widget _buildChipsList(List<String> items) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: items.map((item) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Chip(
          label: Text(
            item,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.green),
          ),
          backgroundColor: Colors.green.withOpacity(0.1),
        ),
      );
    }).toList(),
  );
}

Widget _buildSupervisorsList(List<String> supervisors) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: supervisors.length,
    itemBuilder: (context, index) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.1),
          child: Text(
            supervisors[index][0],
            style: const TextStyle(color: Colors.green),
          ),
        ),
        title: Text(
          supervisors[index],
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        subtitle: Text(
          'Supervisor ${index + 1}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        contentPadding: EdgeInsets.zero,
      );
    },
  );
}

Widget _buildRecommendationForm() {
  return StatefulBuilder(
    builder: (context, setState) {
      bool isRecommended = false; // Default to Not Recommended

      return CollapsibleCard(
        title: 'Your Recommendation',
        color: Colors.orange,
        isAlwaysExpanded: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Decision',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => isRecommended = true);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.green),
                      backgroundColor:
                          isRecommended ? Colors.green.withOpacity(0.1) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Recommend',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => isRecommended = false);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.red),
                      backgroundColor:
                          !isRecommended ? Colors.red.withOpacity(0.1) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Not Recommended',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Comments',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter your comments here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Recommendation submitted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit Recommendation',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildStatusTimeline() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _buildTimelineItem(
          icon: Icons.person,
          label: 'Student\nSubmitted',
          isCompleted: true,
          isLast: false,
        ),
        _buildTimelineItem(
          icon: Icons.verified_user,
          label: 'Department\nVerified',
          isCompleted: true,
          isLast: false,
        ),
        _buildTimelineItem(
          icon: Icons.school,
          label: 'Coordinator\nApproved',
          isCompleted: true,
          isLast: false,
        ),
        _buildTimelineItem(
          icon: Icons.admin_panel_settings,
          label: 'HOD\nApproved',
          isCompleted: true,
          isLast: false,
        ),
        _buildTimelineItem(
          icon: Icons.assignment_turned_in,
          label: 'Dean\nApproved',
          isCompleted: false,
          isLast: false,
        ),
        _buildTimelineItem(
          icon: Icons.check_circle,
          label: 'Final\nConfirmation',
          isCompleted: false,
          isLast: true,
        ),
      ],
    ),
  );
}

Widget _buildTimelineItem({
  required IconData icon,
  required String label,
  required bool isCompleted,
  required bool isLast,
}) {
  return Container(
    width: 100,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    child: Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.indigo : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isCompleted ? Colors.white : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isCompleted ? Colors.indigo : Colors.grey[600],
              ),
            ),
          ],
        ),
        if (!isLast)
          Expanded(
            child: Container(
              height: 2,
              color: isCompleted ? Colors.indigo : Colors.grey[300],
            ),
          ),
      ],
    ),
  );
}

// Widget to build a status with date display
Widget _buildStatusWithDate(String status, DateTime date) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          status,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${date.day}/${date.month}/${date.year}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

// Widget to build a comment section
Widget _buildCommentSection(String comment) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      const Text(
        'Comments',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(comment),
      ),
    ],
  );
}

// Widget to build a detail row with icon and label-value pair
Widget _buildDetailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
