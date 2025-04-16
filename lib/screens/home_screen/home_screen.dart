//optimized
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phd_monitoring_mobile_app/constants/url.dart';
import 'package:phd_monitoring_mobile_app/functions/fetch_data.dart';
import 'package:phd_monitoring_mobile_app/screens/home_screen/app_drawer/app_drawer.dart';
import 'package:phd_monitoring_mobile_app/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.child, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _updateIndexBasedOnLocation(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    setState(() {
      _currentIndex = location == '/notifications' ? 1 : 0;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateIndexBasedOnLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    return GoRouterState.of(context).uri.path == '/notifications'
        ? _buildScaffold(currentIndex: 1)
        : _buildScaffold(currentIndex: 0);
  }

  String selectedRole = 'supervisor';

  Scaffold _buildScaffold({required int currentIndex}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(currentIndex == 0 ? 'Dashboard' : 'Notifications'),
        actions: [
          // You can move this to your state if using StatefulWidget
          Tooltip(
            message: 'Switch Role',
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onSelected: (value) async {
                setState(() {
                  selectedRole = value;
                });

                final response = await fetchData(
                  url: '$SERVER_URL/switch-role',
                  method: 'POST',
                  body: {'role': value},
                  context: context,
                );

                if (response['success']) {
                  print('Role switched to $value');
                } else {
                  print('Failed to switch role: ${response['response']}');
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'faculty',
                      child: Text('Supervisor'),
                    ),
                    const PopupMenuItem(
                      value: 'phd_coordinator',
                      child: Text('PhD Coordinator'),
                    ),
                    const PopupMenuItem(value: 'hod', child: Text('HOD')),
                    const PopupMenuItem(
                      value: 'doctoral',
                      child: Text('Doctoral Committee'),
                    ),
                  ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              widget.onLogout();
              context.go('/login');
            },
          ),
        ],
      ),
      drawer: AppDrawer(onLogout: widget.onLogout),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            context.go('/');
          } else {
            context.go('/notifications');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
