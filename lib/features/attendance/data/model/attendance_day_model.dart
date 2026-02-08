class AttendanceDayModel {
  final DateTime date;
  String? clockIn;
  String? clockOut;

  AttendanceDayModel({required this.date, this.clockIn, this.clockOut});
}
