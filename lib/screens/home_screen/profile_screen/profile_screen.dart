//optimized but pp and button
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phd_monitoring_mobile_app/model/user.dart';
import 'package:phd_monitoring_mobile_app/providers/user_provider.dart';
import 'package:phd_monitoring_mobile_app/theme/app_colors.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false; // Properly defined loading state

  Future<void> _handleLogout(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.logout();
      if (context.mounted) {
        context.go('/login');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final String imageUrl =
        'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 50.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body:
          user == null
              ? const Center(child: Text('No user data available'))
              : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      CircleAvatar(
                        radius: 120.r,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        backgroundImage:
                            imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                        child:
                            (imageUrl.isEmpty)
                                ? Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 80.sp,
                                )
                                : null,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: GoogleFonts.poppins(
                          fontSize: 50.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.role.toString().split('.').last,
                        style: GoogleFonts.poppins(
                          fontSize: 35.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      buildInfoCard(user),
                      // SizedBox(height: 20.h),
                      // buildStatsCard(),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.h),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                _isLoading
                                    ? null
                                    : () => _handleLogout(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shadowColor: AppColors.primary.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child:
                                _isLoading
                                    ? SizedBox(
                                      height: 40.h,
                                      width: 40.w,
                                      child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      "Logout",
                                      style: GoogleFonts.poppins(
                                        fontSize: 40.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 50.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 35.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

Widget buildInfoCard(User user) {
  return Card(
    margin: EdgeInsets.symmetric(horizontal: 40.h),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // buildInfoRow(Icons.email, user.email),
          // const Divider(),
          // buildInfoRow(Icons.phone, user.phone),
          // const Divider(),
          // buildInfoRow(Icons.work, 'Joined in 2015'), // Example static data
        ],
      ),
    ),
  );
}

// Widget buildInfoRow(IconData icon, String text) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8),
//     child: Row(
//       children: [
//         Icon(icon, color: AppColors.primary),
//         const SizedBox(width: 16),
//         Expanded(child: Text(text)),
//       ],
//     ),
//   );
// }

// Widget buildStatsCard() {
//   return Card(
//     margin: EdgeInsets.symmetric(horizontal: 40.h),
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Statistics',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               buildStatItem('Publications', '23'),
//               buildStatItem('Students', '156'),
//               buildStatItem('Courses', '5'),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget buildStatItem(String label, String value) {
//   return Column(
//     children: [
//       Text(
//         value,
//         style: const TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: AppColors.primary,
//         ),
//       ),
//       Text(label, style: TextStyle(color: Colors.grey[600])),
//     ],
//   );
// }
