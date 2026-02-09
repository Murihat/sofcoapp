// modules/attendance/attendance_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../app/routes/app_router.dart';
import '../controller/attendance_controller.dart';
import '../data/model/attendance_model.dart';

class AttendancePage extends StatelessWidget {
  AttendancePage({super.key});

  final AttendanceController c = Get.find<AttendanceController>();

  Stream<DateTime> _clockStream() =>
      Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              /// HEADER
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Attendance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              StreamBuilder<DateTime>(
                stream: _clockStream(),
                builder: (_, snapshot) {
                  final now = snapshot.data ?? DateTime.now();

                  final time =
                      '${now.hour.toString().padLeft(2, '0')}:'
                      '${now.minute.toString().padLeft(2, '0')}:'
                      '${now.second.toString().padLeft(2, '0')}';

                  final date =
                      '${now.day.toString().padLeft(2, '0')}-'
                      '${now.month.toString().padLeft(2, '0')}-'
                      '${now.year}';

                  return Column(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(
                            Routes.ATTENDANCE_CAMERA,
                            arguments: 'IN',
                          );
                        },
                        child: const Text(
                          'CLOCK IN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(
                            Routes.ATTENDANCE_CAMERA,
                            arguments: 'OUT',
                          );
                        },
                        child: const Text(
                          'CLOCK OUT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Attendance History',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Obx(() {
                          if (c.isLoadingToday.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (c.todayAttendance.isEmpty) {
                            return const Center(child: Text("No Data"));
                          }

                          return ListView.separated(
                            itemCount: c.todayAttendance.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (_, i) {
                              final item = c.history[i];

                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () =>
                                    _showAttendanceDetail(context, item),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      item.type == 'IN'
                                          ? Icons.login
                                          : Icons.logout,
                                      color: item.type == 'IN'
                                          ? Colors.green
                                          : Colors.redAccent,
                                    ),
                                    title: Text(
                                      '${item.date.day}-${item.date.month}-${item.date.year}',
                                    ),
                                    subtitle: Text(
                                      '${item.type} at ${item.time}',
                                    ),
                                    trailing: const Icon(Icons.chevron_right),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAttendanceDetail(BuildContext context, AttendanceModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                Row(
                  children: [
                    Icon(
                      item.type == 'IN' ? Icons.login : Icons.logout,
                      color: item.type == 'IN'
                          ? Colors.green
                          : Colors.redAccent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.type == 'IN'
                          ? 'Clock In Detail'
                          : 'Clock Out Detail',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DetailRow(
                  label: 'Date',
                  value:
                      '${item.date.day}-${item.date.month}-${item.date.year}',
                ),
                _DetailRow(label: 'Time', value: item.time),
                _DetailRow(
                  label: 'Type',
                  value: item.type,
                  valueColor: item.type == 'IN'
                      ? Colors.green
                      : Colors.redAccent,
                ),
                const SizedBox(height: 16),
                if (item.photoUrl != null) ...[
                  const Text(
                    'Photo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.photoUrl!,
                      width: 280,
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

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
            width: 80,
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
