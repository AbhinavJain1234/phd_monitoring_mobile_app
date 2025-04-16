//optimized
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phd_monitoring_mobile_app/constants/url.dart';
import 'package:phd_monitoring_mobile_app/functions/fetch_data.dart';
import 'package:phd_monitoring_mobile_app/model/user_role.dart';
import 'package:phd_monitoring_mobile_app/theme/app_colors.dart';
import 'package:phd_monitoring_mobile_app/widgets/student_data_table.dart';

class FormSubmissionListScreen extends StatefulWidget {
  final String formType;
  final String formName;
  final UserRole role;

  const FormSubmissionListScreen({
    super.key,
    required this.formType,
    required this.formName,
    required this.role,
  });

  @override
  State<FormSubmissionListScreen> createState() =>
      _FormSubmissionListScreenState();
}

class _FormSubmissionListScreenState extends State<FormSubmissionListScreen> {
  Map<String, dynamic> _submissions = {};
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchFormSubmissions();
  }

  Future<void> _fetchFormSubmissions() async {
    try {
      final response = await fetchData(
        url: '$SERVER_URL/forms/${widget.formType}',
        context: context,
      );
      print(response);
      if (response['success']) {
        setState(() {
          _submissions = response['response'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to fetch submissions';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formName),
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
              ? Center(child: Text(_errorMessage))
              : _submissions.isEmpty ||
                  _submissions['data'] == null ||
                  _submissions['data'].isEmpty
              ? const Center(child: Text('No submissions found'))
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StudentDataTable(
                        tableData: {'success': true, 'response': _submissions},
                        onTap: (int id) {
                          // Handle row tap
                          context.push('/forms/${widget.formType}/$id');
                        },
                        onSelectionChanged: (selectedItems) {
                          // Handle selected items
                          print('Selected ${selectedItems.length} items');
                        },
                        role: widget.role,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
