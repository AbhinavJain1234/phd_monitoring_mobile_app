import 'package:flutter/material.dart';
import 'package:phd_monitoring_mobile_app/constants/url.dart';
import 'package:phd_monitoring_mobile_app/functions/fetch_data.dart';
import 'package:phd_monitoring_mobile_app/model/user_role.dart';
import 'package:phd_monitoring_mobile_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var dashboardData = null;

  void initState() {
    super.initState();
    fetchDashboardData(context);
  }

  Future<void> fetchDashboardData(BuildContext context) async {
    final result = await fetchData(
      url: '$SERVER_URL/home',
      method: 'GET',
      context: context,
      showToast: false,
    );
    print(result);

    if (result['success']) {
      setState(() {
        dashboardData = result['response'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userRole = userProvider.user?.role;
    print(userProvider.user?.role.toString());

    // Determine if the role is any type of faculty
    bool isFaculty =
        userRole == UserRole.phdCoordinator ||
        userRole == UserRole.faculty ||
        userRole == UserRole.hod ||
        userRole == UserRole.dra ||
        userRole == UserRole.dordc ||
        userRole == UserRole.director;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(child: Text("DASHBOARD")),
    );
  }
}
