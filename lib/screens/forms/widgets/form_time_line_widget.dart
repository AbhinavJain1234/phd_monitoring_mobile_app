import 'package:flutter/material.dart';

class FormTimeLineWidget extends StatelessWidget {
  final List<dynamic> steps; // actual steps that occurred
  final int currentStep;

  const FormTimeLineWidget({
    super.key,
    required this.steps,
    required this.currentStep,
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
          Row(
            children: [
              const Text(
                'Application Progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "History",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        content: const Text(
                          "This is the history of the form submission process.",
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  "View history >",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatusTimeline(steps, currentStep),
        ],
      ),
    );
  }
}

// Full fixed order of possible roles
final List<String> fullStepOrder = [
  "student",
  "faculty",
  "phd_coordinator",
  "hod",
  "dordc",
  "dra",
  "director",
  "doctoral_committee",
  "external",
  "complete",
];

// Map for display labels and icons
final Map<String, Map<String, dynamic>> stepMeta = {
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
Widget _buildStatusTimeline(List<dynamic> steps, int currentStep) {
  final visibleSteps =
      fullStepOrder.where((key) => steps.contains(key)).toList();

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(visibleSteps.length, (index) {
        final key = visibleSteps[index];
        final meta = stepMeta[key];

        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;
        final isLast = index == visibleSteps.length - 1;

        // Label override for first and last
        final displayLabel =
            index == 0
                ? "${meta?['label']}\nInitiated"
                : (key == "complete"
                    ? "Form\nSubmitted"
                    : "${meta?['label']} \nApproved");

        return _buildTimelineItem(
          icon: meta?['icon'],
          label: displayLabel,
          isCompleted: isCompleted || isCurrent,
          isLast: isLast,
        );
      }),
    ),
  );
}

Widget _buildTimelineItem({
  required IconData? icon,
  required String label,
  required bool isCompleted,
  required bool isLast,
}) {
  return IntrinsicHeight(
    child: Row(
      children: [
        Column(
          children: [
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.indigo : Colors.grey[300],
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
                      color: isCompleted ? Colors.indigo : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Container(
              height: 2,
              color: isCompleted ? Colors.indigo : Colors.grey[300],
            ),
          ),
      ],
    ),
  );
}
