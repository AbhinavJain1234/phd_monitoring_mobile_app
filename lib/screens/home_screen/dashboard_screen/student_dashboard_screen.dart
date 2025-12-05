import 'package:flutter/material.dart';
import 'package:phd_monitoring_mobile_app/theme/app_colors.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key, required this.dashboardData});
  final Map<String, dynamic> dashboardData;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calculate dynamic sizes
    final cardPadding = screenWidth * 0.04; // 4% of screen width
    final progressSize = screenWidth * 0.25; // 25% of screen width
    final welcomeFontSize = screenWidth * 0.06; // 6% of screen width
    final regularFontSize = screenWidth * 0.04; // 4% of screen width
    final strokeWidth = screenWidth * 0.015; // 1.5% of screen width

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: EdgeInsets.all(cardPadding),
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome, ${dashboardData['data']['name'] ?? 'Student'}",
                            style: TextStyle(
                              fontSize: welcomeFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            "PhD Title: ${dashboardData['data']['phd_title'] ?? 'N/A'}",
                            style: TextStyle(
                              fontSize: regularFontSize,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "You have ${dashboardData['pendingForms'] ?? 0} pending forms.",
                            style: TextStyle(
                              fontSize: regularFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: progressSize,
                      width: progressSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            semanticsLabel: 'Overall Progress',
                            value: (dashboardData['data']['overall_progress']
                                    as int) /
                                100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                            backgroundColor: Colors.grey[300],
                            strokeWidth: strokeWidth,
                            semanticsValue: dashboardData['data']
                                    ['overall_progress']
                                .toString(),
                          ),
                          Text(
                            '${dashboardData['data']['overall_progress']}%',
                            style: TextStyle(
                              fontSize: regularFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Text(
          "DASHBOARD",
          style: TextStyle(
            fontSize: welcomeFontSize,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
