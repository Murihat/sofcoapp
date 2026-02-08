import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  /// INSERT clock in / out
  Future<void> insertAttendance({
    required int userId,
    required String type, // IN / OUT
  }) async {
    final now = DateTime.now();

    await _client.from('sofco_attendance').insert({
      'user_id': userId,
      'attendance_type': type,
      'attendance_date': now.toIso8601String().split('T').first,
      'attendance_time': now.toIso8601String().split('T')[1].substring(0, 8),
    });
  }

  /// GET history
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
