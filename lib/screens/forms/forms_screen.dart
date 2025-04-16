import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phd_monitoring_mobile_app/configs/form_config.dart';
import 'package:phd_monitoring_mobile_app/constants/url.dart';
import 'package:phd_monitoring_mobile_app/functions/fetch_data.dart';
import 'package:phd_monitoring_mobile_app/model/user_role.dart';
import 'package:phd_monitoring_mobile_app/providers/user_provider.dart';
import 'package:phd_monitoring_mobile_app/theme/app_colors.dart';
import 'package:provider/provider.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  List<Map<String, dynamic>> forms = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchForms();
    });
  }

  Future<void> fetchStudentForms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await fetchData(
        url: '$SERVER_URL/forms',
        context: context,
      );

      setState(() {
        if (response['success']) {
          forms = List<Map<String, dynamic>>.from(
            response['response']
                .map((form) => {'form_type': form['form_type']})
                .toList(),
          );
        } else {
          _errorMessage = 'Error fetching student forms';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  void fetchForms() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    if (user?.role == UserRole.student) {
      fetchStudentForms();
    } else {
      setState(() {
        forms = [
          {'form_type': 'supervisor-allocation'},
          {'form_type': 'irb-constitution'},
          {'form_type': 'irb-submission'},
          {'form_type': 'synopsis-submission'},
          {'form_type': 'list-of-examiners'},
          {'form_type': 'thesis-submission'},
          {'form_type': 'supervisor-change'},
          {'form_type': 'semester-off'},
          {'form_type': 'status-change'},
          {'form_type': 'irb-extension'},
          {'form_type': 'thesis-extension'},
        ];
      });
    }
    print(forms);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user found. Please login again.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text("PhD Forms"),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : forms.isEmpty
              ? const Expanded(child: Center(child: Text('No forms available')))
              : ListView.builder(
                itemCount: forms.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return buildFormListTile(forms[index], context, user.role);
                },
              ),
    );
  }

  Widget buildFormListTile(
    Map<String, dynamic> form,
    BuildContext context,
    UserRole userRole,
  ) {
    final formId = form['form_type'].toString();
    final config = formConfigs[formId]!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        onTap: () {
          context.push('/forms/${form['form_type']}');
        },
        leading: CircleAvatar(
          backgroundColor: config.color.withOpacity(0.2),
          child: Icon(config.icon, color: config.color),
        ),
        title: Text(
          config.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(config.description),
            const SizedBox(height: 4),
            if (userRole == UserRole.student) ...[] else ...[],
          ],
        ),
      ),
    );
  }
}