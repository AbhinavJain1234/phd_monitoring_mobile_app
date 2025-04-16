import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phd_monitoring_mobile_app/model/user_role.dart';
import 'package:phd_monitoring_mobile_app/providers/user_provider.dart';
import 'package:phd_monitoring_mobile_app/theme/app_colors.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const AppDrawer({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    // final String imageUrl = user.imageUrl;
    const String imageUrl =
        'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg';

    if (user == null) {
      return const Drawer(
        child: Center(child: Text('No user found. Please login again.')),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  backgroundImage:
                      imageUrl.isNotEmpty ? const NetworkImage(imageUrl) : null,
                  child:
                      (imageUrl.isEmpty)
                          ? const Icon(Icons.person, color: AppColors.primary)
                          : null,
                ),
                const SizedBox(height: 8),
                Text(
                  '${user.role.toString().split('.').last[0].toUpperCase()}${user.role.toString().split('.').last.substring(1)}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  user.email,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pop();
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.of(context).pop();
              context.go('/notifications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Forms'),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/forms');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Publications'),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/publications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Progress Monitoring'),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/progress-monitoring');
            },
          ),
          // Only show Student List for non-student roles
          if (user.role != UserRole.student)
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Student List'),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/student-list');
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              onLogout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
