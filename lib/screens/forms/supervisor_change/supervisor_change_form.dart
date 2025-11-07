import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phd_monitoring_mobile_app/constants/url.dart';
import 'package:phd_monitoring_mobile_app/functions/fetch_data.dart';
import 'package:phd_monitoring_mobile_app/functions/format_date_time.dart';
import 'package:phd_monitoring_mobile_app/functions/opendocument.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/build_data_list.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/build_detail_row.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/build_faculty_list.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/collapsible_card.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/form_time_line_widget.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/give_recommendation_widget.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/recommended_widget.dart';
import 'package:phd_monitoring_mobile_app/theme/app_colors.dart';

//Manage form not yet assigned
class SupervisorChangeForm extends StatefulWidget {
  const SupervisorChangeForm({
    super.key,
    required this.formId,
    required this.formType,
  });

  final String formId;
  final String formType;

  @override
  State<SupervisorChangeForm> createState() => _SupervisorChangeFormState();
}

class _SupervisorChangeFormState extends State<SupervisorChangeForm> {
  List<Widget> widgets = [];
  Map<String, dynamic> data = {};
  bool _isLoading = true;
  String _errorMessage = '';

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
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDetailRow(
                Icons.assignment_ind,
                'Roll Number',
                data['roll_no'].toString(),
              ),
              buildDetailRow(Icons.person, 'Name', data['name']),
              buildDetailRow(
                Icons.calendar_today,
                'Date of Admission',
                formatDateTime(data['date_of_registration']),
              ),
              buildDetailRow(Icons.email, 'Email', data['email'].toString()),
              buildDetailRow(
                  Icons.phone, 'Mobile Number', data['phone'].toString()),
              buildDetailRow(Icons.check_circle, 'IRB Completed',
                  data['irb_submitted'] == 1 ? 'Yes' : 'No'),
              buildDetailRow(
                Icons.menu_book,
                'Title of PhD Thesis',
                data['phd_title'].toString(),
              ),
              const Text(
                'Supervisors',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              buildFacultList(
                data['current_supervisors']
                    .map((element) => element['name'])
                    .toList()
                    .cast<String>(),
              ),
              buildDetailRow(
                Icons.calendar_today,
                'Date of Allocation of Supervisor',
                formatDateTime(data['date_of_allocation']),
              ),
              buildDetailRow(Icons.comment, 'Reason for Supervisor Change',
                  data['reason']),
              const Text(
                'Supervisors to be changed',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              buildFacultList(
                data['to_change']
                    .map((element) => element['name'])
                    .toList()
                    .cast<String>(),
              ),
              const Text(
                'Student Prefrences',
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
      //Title Hardcoded
      case 'phd_coordinator':
        return CollapsibleCard(
            title: "PhD Coordinator Review",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Supervisors Allocated By PhDCoordinator',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                buildFacultList(
                  data['new_supervisors']
                      .map((element) => element['name'])
                      .toList()
                      .cast<String>(),
                ),
              ],
            ));

      case 'hod':
        return RecommendedWidget(
            title: "HOD Review",
            approval: data['approvals'][role],
            comment: data['comments'][role]);
      case 'dordc':
        return RecommendedWidget(
            title: "DoRDC Review",
            approval: data['approvals'][role],
            comment: data['comments'][role]);
      case 'dra':
        return RecommendedWidget(
            title: "DRA Review",
            approval: data['approvals'][role],
            comment: data['comments'][role]);
      default:
        return const Center(child: Text('Invalid role'));
    }
  }

  Widget buildCurrentRoleWidgetsFor(String role) {
    switch (role) {
      case 'student':
        return CollapsibleCard(
          title: "Student Review",
          content: Center(child: Text("Fill the form from the website")),
        );
      case 'phd_coordinator':
        return CollapsibleCard(
          title: "PhD Coordinator Review",
          content: Center(child: Text("Fill the form from the website")),
        );
      case 'hod':
      case 'dordc':
      case 'dra':
        return GiveRecommendationWidget(
          postition: role,
          formType: widget.formType,
          formId: widget.formId,
          onSubmit: _fetchFormData,
        );
      default:
        return const Center(child: Text('Invalid role in current'));
    }
  }

  void widgetbuilder() {
    widgets.clear();
    widgets.add(
      FormTimeLineWidget(
        steps: data['steps'],
        currentStep: data['current_step'],
        history: data['history'],
      ),
    );
    // Iterate through the steps until data["role"] is reached
    for (var position in data['steps']) {
      print("Position is $position");
      if (position != data["role"]) {
        print("Before");
        widgets.add(buildRoleWidgetsFor(position));
      } else {
        if (position == data['stage'] ||
            position == 'faculty' && data['stage'] == 'supervisor') {
          print("Current Stage");
          widgets.add(buildCurrentRoleWidgetsFor(position));
        } else {
          print("Before 2");
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
        title: const Text("Supervisor Change Form"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchFormData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widgets,
                      ),
                    ),
                  ),
                ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
