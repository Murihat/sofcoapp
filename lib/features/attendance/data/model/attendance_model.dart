class AttendanceModel {
  final int id;
  final DateTime date;
  final String type; // IN / OUT
  final String time;
  final String? photoUrl; // ✅ TAMBAHAN

  AttendanceModel({
    required this.id,
    required this.date,
    required this.type,
    required this.time,
    this.photoUrl,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      date: DateTime.parse(json['attendance_date']),
      type: json['attendance_type'],
      time: json['attendance_time'],
      photoUrl: json['photo_url'], // ✅ AMBIL DARI DB
    );
  }
}
