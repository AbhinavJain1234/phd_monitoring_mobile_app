import 'package:flutter/material.dart';
// Constants
const List<String> _monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

const Map<String, Map<String, dynamic>> _stepMeta = {
  "student": {"label": "Student", "icon": Icons.person},
  "faculty": {"label": "Faculty", "icon": Icons.people},
  "phd_coordinator": {"label": "Coordinator", "icon": Icons.school},
  "hod": {"label": "HOD", "icon": Icons.admin_panel_settings},
  "dordc": {"label": "DORDC", "icon": Icons.approval},
  "dra": {"label": "DRA", "icon": Icons.verified_user},
  "director": {"label": "Director", "icon": Icons.account_circle},
  "doctoral_committee": {"label": "Committee", "icon": Icons.groups},
  "external": {"label": "External", "icon": Icons.public},
  "complete": {"label": "Final\nSubmitted", "icon": Icons.check_circle},
};

class FormTimeLineWidget extends StatelessWidget {
  final List<dynamic> steps;
  final int currentStep;
  final List<dynamic> history;

  const FormTimeLineWidget({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildStatusTimeline(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Application Progress',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => _showHistoryDialog(context),
          child: Text(
            "View history >",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  void _showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildHistoryDialog(context),
    );
  }

  Widget _buildHistoryDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        "Form Status History",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "History",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 16),
              _buildHistoryTimeline(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }

  Widget _buildHistoryTimeline() {
    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("No history available"),
      );
    }

    return Column(
      children: List.generate(history.length, (index) {
        final item = history[index];
        final isLast = index == history.length - 1;

        return _buildHistoryItem(
          item: item,
          isLast: isLast,
        );
      }),
    );
  }

  Widget _buildHistoryItem(
      {required Map<String, dynamic> item, required bool isLast}) {
    final action = item['action'] ?? '';
    final timestamp = item['timestamp'] ?? '';
    final user = item['user'] ?? '';
    final formattedTime = _formatTimestamp(timestamp);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHistoryDot(isLast),
            const SizedBox(width: 16),
            Expanded(
              child: _buildHistoryContent(formattedTime, action, user),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryDot(bool isLast) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.indigo,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
        ),
        if (!isLast)
          Container(
            width: 2,
            height: 60,
            color: Colors.grey[300],
          ),
      ],
    );
  }

  Widget _buildHistoryContent(String time, String action, String user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          action,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        if (user.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "by $user",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  String _formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(timestamp);
      final month = _monthNames[dateTime.month - 1];
      final day = dateTime.day;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      final displayHour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;

      return '$month $day, $displayHour:$minute $period';
    } catch (e) {
      return timestamp;
    }
  }

  Widget _buildStatusTimeline() {
    // Use the steps directly in the order they are provided
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(steps.length, (index) {
          final key = steps[index];
          final meta = _stepMeta[key] ?? {};
          final isCompleted = index <= currentStep;
          final isLast = index == steps.length - 1;
          final displayLabel = _getDisplayLabel(key, index);

          return _buildTimelineItem(
            icon: meta['icon'] as IconData?,
            label: displayLabel,
            isCompleted: isCompleted,
            isLast: isLast,
          );
        }),
      ),
    );
  }

  String _getDisplayLabel(String key, int index) {
    final meta = _stepMeta[key];
    if (index == 0) {
      return "${meta?['label']}\nInitiated";
    } else if (key == "complete") {
      return "Form\nSubmitted";
    } else {
      return "${meta?['label']}\nApproved";
    }
  }

  Widget _buildTimelineItem({
    required IconData? icon,
    required String label,
    required bool isCompleted,
    required bool isLast,
  }) {
    final activeColor = Colors.indigo;
    final inactiveColor = Colors.grey[300];

    return IntrinsicHeight(
      child: Row(
        children: [
          _buildTimelineNode(
              icon, label, isCompleted, activeColor, inactiveColor),
          if (!isLast)
            _buildTimelineLine(isCompleted, activeColor, inactiveColor),
        ],
      ),
    );
  }

  Widget _buildTimelineNode(
    IconData? icon,
    String label,
    bool isCompleted,
    Color activeColor,
    Color? inactiveColor,
  ) {
    return SizedBox(
      width: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCompleted ? activeColor : inactiveColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.help_outline,
                color: isCompleted ? Colors.white : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isCompleted ? activeColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineLine(
    bool isCompleted,
    Color activeColor,
    Color? inactiveColor,
  ) {
    return SizedBox(
      width: 40,
      child: Center(
        child: Container(
          height: 2,
          color: isCompleted ? activeColor : inactiveColor,
        ),
      ),
    );
  }
}
