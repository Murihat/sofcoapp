import 'package:get/get.dart';
import '../data/datasource/attendance_datasource.dart';
import '../controller/attendance_controller.dart';
import '../data/repository/attendance_repository.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AttendanceController>(() => AttendanceController());
    Get.lazyPut(() => AttendanceDatasource());
    Get.lazyPut(() => AttendanceRepository(Get.find()));
    Get.lazyPut(() => AttendanceController(Get.find()));
  }
}
