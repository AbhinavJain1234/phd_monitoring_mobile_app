import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phd_monitoring_mobile_app/constants/url.dart';
import 'package:phd_monitoring_mobile_app/functions/fetch_data.dart';
import 'package:phd_monitoring_mobile_app/functions/format_date_time.dart';
import 'package:phd_monitoring_mobile_app/functions/opendocument.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/build_data_list.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/build_detail_row.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/collapsible_card.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/form_time_line_widget.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/give_recommendation_widget.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/recommended_widget.dart';
import 'package:phd_monitoring_mobile_app/theme/app_colors.dart';

//Manage form not yet assigned
class IRBRevisionForm extends StatefulWidget {
  const IRBRevisionForm({
    super.key,
    required this.formId,
    required this.formType,
  });

  final String formId;
  final String formType;

  @override
  State<IRBRevisionForm> createState() => _IRBRevisionFormState();
}

class _IRBRevisionFormState extends State<IRBRevisionForm> {
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
              buildDetailRow(Icons.home_work, 'Department', data['department']),
              buildDetailRow(Icons.grade, 'CGPA', data['cgpa'].toString()),
              buildDetailRow(Icons.email, 'Email', data['email'].toString()),
              buildDetailRow(
                Icons.menu_book,
                'Previous Proposed Title of PhD Thesis',
                data['phd_title'].toString(),
              ),
              buildDetailRow(
                Icons.menu_book,
                'Revised Title of Phd Thesis',
                data['revised_phd_title'].toString(),
              ),
              const Text(
                'Revised PhD Objectives',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              buildDataList(data['revised_phd_objectives'].cast<String>()),
              ElevatedButton(
                onPressed: () async {
                  if (data.containsKey('revised_irb_pdf') &&
                      data['revised_irb_pdf'] != null) {
                    await downloadAndOpenPdf(data['revised_irb_pdf'], context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PDF path not available')),
                    );
                  }
                },
                child: const Text('View Revised IRB PDF File'),
              ),
              buildDetailRow(
                Icons.calendar_today,
                'Date of Admission',
                formatDateTime(data['date_of_irb']),
              ),
            ],
          ),
        );
      //Title Hardcoded
      case 'faculty':
        return RecommendedWidget(
            title: "Supervisor Review",
            approval: data['approvals']['supervisor'],
            comment: data['comments']['supervisor']);
      case 'external':
        return RecommendedWidget(
            title: "External Member Review",
            approval: data['approvals'][role],
            comment: data['comments'][role]);
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
      case 'faculty':
        return CollapsibleCard(
          title: "Supervisor Review",
          content: Center(child: Text("Fill the form from the website")),
        );
      case 'phd_coordinator':
        return CollapsibleCard(
          title: "PhD Coordinator Review",
          content: Center(child: Text("Fill the form from the website")),
        );
      case 'hod':
      case 'dordc':
        return GiveRecommendationWidget(
          postition: role,
          formType: widget.formType,
          formId: widget.formId,
          onSubmit: _fetchFormData,
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
        title: const Text("IRB Revision Form"),
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
