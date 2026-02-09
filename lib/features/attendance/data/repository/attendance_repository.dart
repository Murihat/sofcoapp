import 'dart:io';
import '../datasource/attendance_datasource.dart';

class AttendanceRepository {
  final AttendanceDatasource datasource;

  AttendanceRepository(this.datasource);

  Future<List<Map<String, dynamic>>> getTodayAttendance(int userId) {
    return datasource.getTodayAttendance(userId);
  }

  Future<List<Map<String, dynamic>>> getHistory(int userId) {
    return datasource.getHistory(userId);
  }

  Future<bool> hasAttendanceToday({required int userId, required String type}) {
    return datasource.hasAttendanceToday(userId: userId, type: type);
  }

  Future<String> uploadPhoto(File file, int userId) {
    return datasource.uploadPhoto(file, userId);
  }

  Future<void> insertAttendance({
    required int userId,
    required String type,
    required String photoUrl,
  }) {
    return datasource.insertAttendance(
      userId: userId,
      type: type,
      photoUrl: photoUrl,
    );
  }
}
