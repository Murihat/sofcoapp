import 'dart:io';

import 'package:get/get.dart';
import 'package:sofcotest/app/auth/data/model/user_model.dart';
import '../../../app/helper/error_snackbar_helper.dart';
import '../../../app/helper/image_compress_helper.dart';
import '../../../app/helper/success_snackbar_helper.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/storage/app_storage.dart';
import '../data/datasource/attendance_datasource.dart';
import '../data/model/attendance_model.dart';

class AttendanceController extends GetxController {
  final AttendanceDatasource _ds = AttendanceDatasource();
  late final UserModel user;

  RxList<AttendanceModel> history = <AttendanceModel>[].obs;

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
}
