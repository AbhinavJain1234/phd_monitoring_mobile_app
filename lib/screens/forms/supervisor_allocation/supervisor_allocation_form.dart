import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phd_monitoring_mobile_app/constants/url.dart';
import 'package:phd_monitoring_mobile_app/functions/fetch_data.dart';
import 'package:phd_monitoring_mobile_app/functions/format_date_time.dart';
import 'package:phd_monitoring_mobile_app/model/user_role.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/collapsible_card.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/form_time_line_widget.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/recommended_widget.dart';
import 'package:phd_monitoring_mobile_app/theme/app_colors.dart';

class SupervisorAllocationForm extends StatefulWidget {
  const SupervisorAllocationForm({
    super.key,
    required this.formId,
    required this.formType,
  });

  final String formId;
  final String formType;

  @override
  State<SupervisorAllocationForm> createState() =>
      _SupervisorAllocationFormState();
}

class _SupervisorAllocationFormState extends State<SupervisorAllocationForm> {
  List<Widget> widgets = [];
  Map<String, dynamic> data = {};
  bool _isLoading = true;
  String _errorMessage = '';

  // Map UserRole to string roles used in hierarchy
  String _mapUserRoleToString(UserRole? role) {
    switch (role) {
      case UserRole.student:
        return 'student';
      case UserRole.phdCoordinator:
        return 'phd_coordinator';
      case UserRole.hod:
        return 'hod';
      default:
        return 'student'; // Default fallback
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFormData();
  }

  Future<void> _fetchFormData() async {
    try {
      final response = await fetchData(
        url: '$SERVER_URL/forms/${widget.formType}/${widget.formId}',
        context: context,
      );
      response['response'].forEach((key, value) {
        print('$key: $value');
      });

      if (response['success']) {
        setState(() {
          data = response['response'] ?? {};
          _isLoading = false;
          widgetbuilder();
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to fetch form data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  Widget buildRoleWidgetsFor(String role) {
    switch (role) {
      case 'student':
        return CollapsibleCard(
          title: "Student Review",
          color: Colors.black,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                Icons.assignment_ind,
                'Roll Number',
                data['roll_no'].toString(),
              ),
              _buildDetailRow(Icons.person, 'Name', data['name']),
              _buildDetailRow(
                Icons.calendar_today,
                'Admission Date',
                formatDateTime(data['date_of_registration']),
              ),
              _buildDetailRow(Icons.email, 'Email', data['email']),
              _buildDetailRow(Icons.phone, 'Mobile', data['phone'].toString()),
              const SizedBox(height: 16),
              const Text(
                'Research Areas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildChipsList(data['broad_area_of_research'].cast<String>()),
              const SizedBox(height: 16),
              const Text(
                'Tentative Supervisors',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              buildFacultList(
                data['prefrences']
                    .map((element) => element['name'])
                    .toList()
                    .cast<String>(),
              ),
            ],
          ),
        );

      case 'phd_coordinator':
        return RecommendedWidget(
          title: 'PhD Coordinator Review',
          approval: data['approvals'][role],
          comment: data['comments'][role] ?? 'N/A',
        );
      case 'hod':
        return RecommendedWidget(
          title: 'HOD Review',
          approval: data['approvals'][role],
          comment: data['comments'][role] ?? 'N/A',
        );
      default:
        return const Center(child: Text('Invalid role'));
    }
  }

  void widgetbuilder() {
    widgets.clear();
    widgets.add(
      FormTimeLineWidget(
        steps: data['steps'],
        currentStep: data['current_step'],
      ),
    );
    // Iterate through the steps until data["role"] is reached
    for (var position in data['steps']) {
      if (position != data["role"]) {
        widgets.add(buildRoleWidgetsFor(position));
      } else {
        if (position == data['stage']) {
          widgets.add(
            buildCurrentStageWidgets(position, widget.formType, widget.formId),
          );
        } else {
          widgets.add(buildRoleWidgetsFor(position));
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supervisor Allocation Form"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widgets,
                  ),
                ),
              ),
    );
  }
}

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
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

Widget _buildChipsList(List<String> items) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children:
        items.map((item) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Chip(
              label: Text(item, overflow: TextOverflow.ellipsis),
              backgroundColor: const Color.fromARGB(
                255,
                0,
                0,
                0,
              ).withOpacity(0.1),
            ),
          );
        }).toList(),
  );
}

Widget buildFacultList(List<String> faculty) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: faculty.length,
    itemBuilder: (context, index) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.1),
          child: Text(
            faculty[index][0],
            style: const TextStyle(color: Colors.black),
          ),
        ),
        title: Text(
          faculty[index],
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        contentPadding: EdgeInsets.zero,
      );
    },
  );
}

Widget buildCurrentStageWidgets(
  String postition,
  String formType,
  String formId,
) {
  TextEditingController commentController =
      TextEditingController(); // Initialize the controller
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              controller: commentController,
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
                onPressed: () async {
                  final response = await fetchData(
                    url: '$SERVER_URL/forms/$formType/$formId',
                    method: 'POST',
                    body: {
                      'approval': isRecommended,
                      'rejection': !isRecommended,
                      'comments': commentController.text,
                      'rejected': !isRecommended,
                    },
                    context: context,
                  );

                  if (response['success']) {
                    // handle success, e.g. show a toast or navigate
                    print('Allocation updated successfully.');
                  } else {
                    // handle error
                    print(
                      'Failed to update allocation: ${response['response']}',
                    );
                  }
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
