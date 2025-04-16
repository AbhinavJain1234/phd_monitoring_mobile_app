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
class IRBContitutionForm extends StatefulWidget {
  const IRBContitutionForm({
    super.key,
    required this.formId,
    required this.formType,
  });

  final String formId;
  final String formType;

  @override
  State<IRBContitutionForm> createState() => _IRBContitutionFormState();
}

class _IRBContitutionFormState extends State<IRBContitutionForm> {
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
                Icons.calendar_month,
                'Date',
                data['date'].toString().toString() ?? "hi",
              ),
              buildDetailRow(
                Icons.assignment_ind,
                'Roll Number',
                data['roll_no'].toString(),
              ),
              buildDetailRow(Icons.person, 'Name', data['name']),
              buildDetailRow(Icons.person, 'Gender', data['gender'].toString()),
              buildDetailRow(
                Icons.calendar_today,
                'Admission Date',
                formatDateTime(data['date_of_registration']),
              ),
              buildDetailRow(Icons.home_work, 'Department', data['department']),
              const Text(
                'Chairman, Board of Studies of the Concerned Department',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              buildFacultList([data['chairman']['name']]),
              const Text(
                'Supervisors',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // buildFacultList(data['supervisors']),
              buildDetailRow(Icons.grade, 'CGPA', data['cgpa'].toString()),
              buildDetailRow(
                Icons.location_on,
                'Address of Correspondence',
                data['address'].toString(),
              ),
              buildDetailRow(
                Icons.menu_book,
                'Title of PhD',
                data['phd_title'].toString(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Objectives',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              buildDataList(data['objectives'].cast<String>()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (data.containsKey('irb_pdf') && data['irb_pdf'] != null) {
                    await downloadAndOpenPdf(data['irb_pdf'], context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PDF path not available')),
                    );
                  }
                },
                child: const Text('View IRB PDF'),
              ),
            ],
          ),
        );
      case 'faculty':
        return CollapsibleCard(
          title: "Supervisor Review",
          content: Column(
            children: [
              const Text(
                'Objectives',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              buildFacultList(
                data['nominee_cognates']
                    .map((element) => element['name'])
                    .toList()
                    .cast<String>(),
              ),
            ],
          ),
        );
      case 'phd_coordinator':
        return CollapsibleCard(
          title: "PhD Coordinator Review",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Supervisors',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              buildFacultList(
                data['supervisors']
                    .map((element) => element['name'])
                    .toList()
                    .cast<String>(),
              ),
            ],
          ),
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
      ),
    );
    // Iterate through the steps until data["role"] is reached
    for (var position in data['steps']) {
      print("!=-----------1------");
      if (position != data["role"]) {
        widgets.add(buildRoleWidgetsFor(position));
      } else {
        if (position == data['stage'] ||
            position == 'faculty' && data['stage'] == 'supervisor') {
          print("!=--------2---------");
          widgets.add(buildCurrentRoleWidgetsFor(position));
        } else {
          print("!=-------3---------");
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
        title: const Text("Constitute of IRB Form"),
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
