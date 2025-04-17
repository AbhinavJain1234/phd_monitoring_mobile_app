import 'package:flutter/material.dart';

class FormConfig {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const FormConfig({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

final Map<String, FormConfig> formConfigs = {
  'supervisor-allocation': const FormConfig(
    title: 'Supervisor Allocation',
    description: 'Request for allocation of PhD supervisor',
    icon: Icons.person_add,
    color: Colors.blue,
  ),
  'supervisor-change': const FormConfig(
    title: 'Supervisor Change',
    description: 'Request to change current PhD supervisor',
    icon: Icons.swap_horiz,
    color: Colors.purple,
  ),
  'semester-off': const FormConfig(
    title: 'Semester Off',
    description: 'Apply for semester break/leave',
    icon: Icons.calendar_today,
    color: Colors.teal,
  ),
  'status-change': const FormConfig(
    title: 'Status Change',
    description: 'Request to change student status',
    icon: Icons.compare_arrows,
    color: Colors.green,
  ),
  'irb-constitution': const FormConfig(
    title: 'IRB Constitution',
    description: 'Formation of Institutional Review Board',
    icon: Icons.groups,
    color: Colors.brown,
  ),
  'irb-submission': const FormConfig(
    title: 'IRB Revision',
    description: 'Submit research proposal to IRB',
    icon: Icons.upload_file,
    color: Colors.orange,
  ),
  'irb-extension': const FormConfig(
    title: 'IRB Extension',
    description: 'Request extension for IRB approval',
    icon: Icons.extension,
    color: Colors.amber,
  ),
  'thesis-submission': const FormConfig(
    title: 'Thesis Submission',
    description: 'Submit PhD thesis for evaluation',
    icon: Icons.book,
    color: Colors.indigo,
  ),
  'thesis-extension': const FormConfig(
    title: 'Thesis Extension',
    description: 'Request extension for thesis submission',
    icon: Icons.more_time,
    color: Colors.red,
  ),
  'list-of-examiners': const FormConfig(
    title: 'List of Examiners',
    description: 'Submit list of thesis examiners',
    icon: Icons.people_outline,
    color: Colors.deepPurple,
  ),
  'synopsis-submission': const FormConfig(
    title: 'Synopsis Submission',
    description: 'Submit research synopsis for review',
    icon: Icons.description,
    color: Colors.cyan,
  ),
};
