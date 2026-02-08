import 'package:get/get.dart';
import '../../features/attendance/binding/attendance_binding.dart';
import '../../features/attendance/pages/attendance_page.dart';
import '../../features/auth/binding/auth_binding.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/dashboard/binding/dashboard_binding.dart';
import '../../features/dashboard/pages/dashboard_page.dart';
import '../../features/splash/binding/splash_binding.dart';
import '../../features/splash/pages/splash_page.dart';

class Routes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const DASHBOARD = '/dashboard';
  static const ATTENDANCE = '/attendance';
}

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(name: Routes.REGISTER, page: () => RegisterPage()),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.ATTENDANCE,
      page: () => AttendancePage(),
      binding: AttendanceBinding(),
    ),
  ];
}
