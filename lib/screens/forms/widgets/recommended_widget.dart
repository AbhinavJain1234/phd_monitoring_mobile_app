import 'package:flutter/material.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/collapsible_card.dart';

class RecommendedWidget extends StatelessWidget {
  final String title;
  final int approval;
  final String comment;
  const RecommendedWidget({
    super.key,
    required this.title,
    required this.approval,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return CollapsibleCard(
      title: 'PhD Coordinator Review',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildStatusWithDate(
            'Status: ${approval == 1 ? "Recommended" : 'Not Recommended'}',
          ),
          buildCommentSection(comment ?? 'N/A'),
        ],
      ),
    );
  }
}

Widget buildStatusWithDate(String status) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Text(status, style: const TextStyle(fontWeight: FontWeight.w500)),
  );
}

// Widget to build a comment section
Widget buildCommentSection(String comment) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      const Text(
        'Comments',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
