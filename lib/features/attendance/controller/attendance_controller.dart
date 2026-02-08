import 'dart:io';
import 'package:get/get.dart';
import '../../../app/auth/data/model/user_model.dart';
import '../data/model/attendance_day_model.dart';
import '../../../app/helper/error_snackbar_helper.dart';
import '../../../app/helper/image_compress_helper.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/storage/app_storage.dart';
import '../data/model/attendance_model.dart';
import '../data/repository/attendance_repository.dart';

class AttendanceController extends GetxController {
  // final AttendanceDatasource _ds = AttendanceDatasource();
  final AttendanceRepository _repo;
  AttendanceController(this._repo);

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
    final data = await _repo.getHistory(user.id);
    history.value = data.map((e) => AttendanceModel.fromJson(e)).toList();
    buildMonthlyAttendance(DateTime.now());
  }

  Future<void> submitAttendance({
    required String type,
    required File imageFile,
  }) async {
    try {
      final alreadyExists = await _repo.hasAttendanceToday(
        userId: user.id,
        type: type,
      );

      if (alreadyExists) {
        ErrorSnackbarHelper.show(
          type == 'IN'
              ? 'You have already clocked in today'
              : 'You have already clocked out today',
        );
        return;
      }

      final compressed = await ImageCompressHelper.compress(imageFile);
      final photoUrl = await _repo.uploadPhoto(compressed, user.id);

      await _repo.insertAttendance(
        userId: user.id,
        type: type,
        photoUrl: photoUrl,
      );

      loadHistory();
    } catch (e) {
      ErrorSnackbarHelper.show('Failed to submit attendance');
    }
  }

  void buildMonthlyAttendance(DateTime month) {
    monthlyAttendance.clear();

    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    for (int i = 1; i <= lastDay; i++) {
      monthlyAttendance.add(
        AttendanceDayModel(date: DateTime(month.year, month.month, i)),
      );
    }

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
    monthlyAttendance.refresh();
  }
}
