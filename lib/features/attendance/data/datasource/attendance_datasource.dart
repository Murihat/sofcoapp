import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> uploadPhoto(File file, int userId) async {
    final fileName =
        'attendance_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage.from('attendance_photos').upload(fileName, file);
    return _client.storage.from('attendance_photos').getPublicUrl(fileName);
  }

  Future<List<Map<String, dynamic>>> getTodayAttendance(int userId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final response = await _client
        .from('sofco_attendance')
        .select()
        .eq('user_id', userId)
        .eq('attendance_date', today)
        .order('attendance_time');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<bool> hasAttendanceToday({
    required int userId,
    required String type,
  }) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final result = await _client
        .from('sofco_attendance')
        .select('id')
        .eq('user_id', userId)
        .eq('attendance_type', type)
        .eq('attendance_date', today)
        .maybeSingle();

    return result != null;
  }

  Future<void> insertAttendance({
    required int userId,
    required String type,
    required String photoUrl,
  }) async {
    final now = DateTime.now();

    await _client.from('sofco_attendance').insert({
      'user_id': userId,
      'attendance_type': type,
      'attendance_date': now.toIso8601String().split('T').first,
      'attendance_time': now.toIso8601String().split('T')[1].substring(0, 8),
      'photo_url': photoUrl,
    });
  }

  Future<List<Map<String, dynamic>>> getHistory(int userId) async {
    final response = await _client
        .from('sofco_attendance')
        .select()
        .eq('user_id', userId)
        .order('attendance_date', ascending: false)
        .order('attendance_time', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
