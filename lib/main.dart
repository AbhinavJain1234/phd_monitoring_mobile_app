import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phd_monitoring_mobile_app/providers/user_provider.dart';
import 'package:phd_monitoring_mobile_app/routes/router.dart';
import 'package:phd_monitoring_mobile_app/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize all async dependencies first
  final userProvider = UserProvider();
  bool isLoggedIn = await getLoginStatus();

  // Initialize user with the logged-in state
  await userProvider.initializeUser();

  // Run app after all async operations are complete
  runApp(
    ChangeNotifierProvider.value(
      value: userProvider,
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(initialLoggedIn: widget.isLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2400),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'PhD Monitoring System',
            theme: appTheme,
            routerConfig: _router,
            builder: (context, child) {
              if (child == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return child;
            },
          ),
    );
  }
}

Future<bool> getLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('userLoggedIn') ?? false;
}
