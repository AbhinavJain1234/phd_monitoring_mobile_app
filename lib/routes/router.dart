import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phd_monitoring_mobile_app/providers/user_provider.dart';
import 'package:phd_monitoring_mobile_app/screens/home_screen/dashboard_screen/dashboard_screen.dart';
import 'package:phd_monitoring_mobile_app/screens/home_screen/home_screen.dart';
import 'package:phd_monitoring_mobile_app/screens/home_screen/notification_screen/motification_screen.dart';
import 'package:phd_monitoring_mobile_app/screens/login_screen/login_screen.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

GoRouter createRouter({bool initialLoggedIn = false}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialLoggedIn ? '/' : '/login',
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      // Get the user provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Check if app is initializing
      if (!userProvider.isInitialized) {
        return null; // Don't redirect while initializing
      }

      final isLoggedIn = userProvider.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      // If not logged in, only allow access to login page
      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      // If logged in and trying to access login page, redirect to home
      if (isLoggingIn) {
        return '/';
      }

      // Allow access to all other pages when logged in
      return null;
    },
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error}'))),
    routes: [
      // Login Route
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),

      // Shell Route for HomeScreen with Nested Routes
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder:
            (context, state, child) => HomeScreen(
              child: child,
              onLogout: () async {
                final userProvider = Provider.of<UserProvider>(
                  context,
                  listen: false,
                );
                await userProvider.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationScreen(),
          ),
        ],
      ),
      //     // Profile Route
      //     GoRoute(
      //       path: '/profile',
      //       parentNavigatorKey: _rootNavigatorKey,
      //       builder: (context, state) => const ProfileScreen(),
      //     ),

      //     GoRoute(
      //       path: '/forms',
      //       parentNavigatorKey: _rootNavigatorKey,
      //       builder: (context, state) => const FormsScreen(),
      //       routes: [
      //         // Direct form type route (existing flow)
      //         GoRoute(
      //           path: ':formType',
      //           builder: (context, state) {
      //             final formType = state.pathParameters['formType']!;
      //             final config = formConfigs[formType];

      //             final userProvider = Provider.of<UserProvider>(
      //               context,
      //               listen: false,
      //             );
      //             final userRole = userProvider.user?.role ?? UserRole.student;

      //             return FormSubmissionListScreen(
      //               formType: formType,
      //               formName: config?.title ?? 'Form',
      //               role: userRole,
      //             );
      //           },
      //           routes: [
      //             GoRoute(
      //               path: ':formId',
      //               builder: (context, state) {
      //                 final formType = state.pathParameters['formType']!;
      //                 final formId = state.pathParameters['formId']!;
      //                 return _buildFormScreen(formType, formId);
      //               },
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),

      //     GoRoute(
      //       path: '/publications',
      //       parentNavigatorKey: _rootNavigatorKey,
      //       builder: (context, state) => const PublicationPage(),
      //     ),
      //     GoRoute(
      //       path: '/progress-monitoring',
      //       parentNavigatorKey: _rootNavigatorKey,
      //       builder: (context, state) => const ProgressMonitoringPage(),
      //     ),

      //     GoRoute(
      //       path: '/student-list',
      //       parentNavigatorKey: _rootNavigatorKey,
      //       builder: (context, state) => const StudentListViewPage(),
      //       routes: [
      //         GoRoute(
      //           path: ':rollNo/forms',
      //           builder: (context, state) {
      //             final rollNo = state.pathParameters['rollNo']!;
      //             final extra = state.extra as Map<String, dynamic>?;
      //             return StudentFormListViewPage(
      //               studentRollNo: rollNo,
      //               studentName: extra?['studentName'] as String? ?? '',
      //             );
      //           },
      //         ),
    ],
    // ),
  );
}

// Widget _buildFormScreen(String formType, String formId) {
//   switch (formType) {
//     case 'supervisor-allocation':
//       return SupervisorAllocationForm(
//         formId: formId,
//         formType: formType,
//       );
//     // Add other form cases here
//     default:
//       return Scaffold(
//         body: Center(
//           child: Text('Form not found: $formType'),
//         ),
//       );
//   }
// }
