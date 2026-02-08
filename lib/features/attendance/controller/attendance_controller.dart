import 'dart:io';
import 'package:get/get.dart';
import 'package:sofcotest/app/auth/data/model/user_model.dart';
import 'package:sofcotest/features/attendance/data/model/attendance_day_model.dart';
import '../../../app/helper/image_compress_helper.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/storage/app_storage.dart';
import '../data/datasource/attendance_datasource.dart';
import '../data/model/attendance_model.dart';

class AttendanceController extends GetxController {
  final AttendanceDatasource _ds = AttendanceDatasource();
  late final UserModel user;

  RxList<AttendanceModel> history = <AttendanceModel>[].obs;
  RxList<AttendanceDayModel> monthlyAttendance = <AttendanceDayModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final userMap = AppStorage.getUser;
    if (userMap == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }
    user = UserModel.fromJson(userMap);
    loadHistory();
  }

  Future<void> loadHistory() async {
    final data = await _ds.getHistory(user.id);
    history.value = data.map((e) => AttendanceModel.fromJson(e)).toList();
    // ⬅️ WAJIB
    buildMonthlyAttendance(DateTime.now());
  }

  Future<void> submitAttendance({
    required String type,
    required File imageFile,
  }) async {
    final compressed = await ImageCompressHelper.compress(imageFile);

    final photoUrl = await _ds.uploadPhoto(compressed, user.id);

    await _ds.insertAttendance(userId: user.id, type: type, photoUrl: photoUrl);

    loadHistory();
  }

  void buildMonthlyAttendance(DateTime month) {
    monthlyAttendance.clear();

    final lastDay = DateTime(month.year, month.month + 1, 0).day;

    // generate 1 bulan
    for (int i = 1; i <= lastDay; i++) {
      monthlyAttendance.add(
        AttendanceDayModel(date: DateTime(month.year, month.month, i)),
      );
    }

    // isi dari history
    for (final item in history) {
      final index = monthlyAttendance.indexWhere(
        (d) =>
            d.date.year == item.date.year &&
            d.date.month == item.date.month &&
            d.date.day == item.date.day,
      );

      if (index == -1) continue;

      if (item.type == 'IN') {
        monthlyAttendance[index].clockIn = item.time;
      } else if (item.type == 'OUT') {
        monthlyAttendance[index].clockOut = item.time;
      }
    }

    // 🔥 WAJIB agar Obx refresh
    monthlyAttendance.refresh();
  }
}
