// modules/attendance/pages/attendance_history_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/attendance_controller.dart';
import '../data/model/attendance_day_model.dart';

class AttendanceHistoryPage extends StatelessWidget {
  AttendanceHistoryPage({super.key});

  final AttendanceController c = Get.find();

  final days = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final startWeekday = firstDay.weekday - 1;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Attendance History'),
        backgroundColor: Color(0xFF0F2027),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),

              /// DAY HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 7,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                  ),
                  itemBuilder: (_, i) => Center(
                    child: Text(
                      days[i],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: i >= 5 ? Colors.redAccent : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// CALENDAR CARD
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Obx(
                    () => GridView.builder(
                      itemCount: startWeekday + c.monthlyAttendance.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                      itemBuilder: (_, index) {
                        if (index < startWeekday) {
                          return const SizedBox();
                        }

                        final dayIndex = index - startWeekday;
                        final dayData = c.monthlyAttendance[dayIndex];
                        final date = dayData.date;

                        final isWeekend =
                            date.weekday == 6 || date.weekday == 7;

                        final hasData =
                            dayData.clockIn != null || dayData.clockOut != null;

                        return GestureDetector(
                          onTap: hasData
                              ? () => _showAttendanceDetail(context, dayData)
                              : null,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isWeekend
                                  ? Colors.grey.shade300
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: hasData
                                      ? Colors.blueAccent.withOpacity(0.25)
                                      : Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(
                                color: hasData
                                    ? Colors.blueAccent
                                    : Colors.grey.shade300,
                                width: hasData ? 1.4 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// DATE
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isWeekend
                                        ? Colors.redAccent
                                        : Colors.black,
                                  ),
                                ),

                                const Spacer(),

                                /// DOT INDICATORS
                                Row(
                                  children: [
                                    if (dayData.clockIn != null)
                                      const _Dot(color: Colors.green),
                                    if (dayData.clockOut != null)
                                      const _Dot(color: Colors.redAccent),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// DETAIL MODAL
  void _showAttendanceDetail(BuildContext context, AttendanceDayModel day) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Attendance Detail',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Date',
                  value: '${day.date.day}-${day.date.month}-${day.date.year}',
                ),
                if (day.clockIn != null)
                  _DetailRow(
                    label: 'Clock In',
                    value: day.clockIn!,
                    valueColor: Colors.green,
                  ),
                if (day.clockOut != null)
                  _DetailRow(
                    label: 'Clock Out',
                    value: day.clockOut!,
                    valueColor: Colors.redAccent,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// DOT
class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// DETAIL ROW
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
