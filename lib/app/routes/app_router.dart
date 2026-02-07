import 'package:go_router/go_router.dart';
import 'package:sofcotest/features/attendance/pages/attendance.page.dart';
import 'package:sofcotest/features/dashboard/pages/dashboard.page.dart';
import 'package:sofcotest/features/login/pages/login.page.dart';
import 'package:sofcotest/features/splash/pages/splash.page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) {
          return const DashboardPage();
        },
      ),
      GoRoute(
        path: '/attendance',
        builder: (context, state) {
          return const AttendancePage();
        },
      ),
    ],
  );
}
