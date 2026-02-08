class AttendanceModel {
  final int id;
  final DateTime date;
  final String type; // IN / OUT
  final String time;

  AttendanceModel({
    required this.id,
    required this.date,
    required this.type,
    required this.time,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      date: DateTime.parse(json['attendance_date']),
      type: json['attendance_type'],
      time: json['attendance_time'],
    );
  }
}
