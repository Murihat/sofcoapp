// modules/attendance/pages/attendance_camera_page.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app/routes/app_router.dart';
import '../controller/attendance_controller.dart';

class AttendanceCameraPage extends StatefulWidget {
  const AttendanceCameraPage({super.key});

  @override
  State<AttendanceCameraPage> createState() => _AttendanceCameraPageState();
}

class _AttendanceCameraPageState extends State<AttendanceCameraPage> {
  final AttendanceController c = Get.find();
  final String type = Get.arguments; // IN / OUT

  CameraController? _cameraController;
  bool _isLoading = true;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      Get.back();
      Get.snackbar(
        'Permission denied',
        'Camera permission is required',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitAttendance() async {
    if (_isSubmitting) return;
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      setState(() => _isSubmitting = true);
      final XFile photo = await _cameraController!.takePicture();
      await c.submitAttendance(type: type, imageFile: File(photo.path));
      Get.until((route) => route.settings.name == Routes.ATTENDANCE);
      // snackbar sukses
      // SuccessSnackbarHelper.show('Attendance recorded successfully');
    } catch (e) {
      // ErrorSnackbarHelper.show('Failed to submit attendance');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(child: CameraPreview(_cameraController!)),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Center(
                        child: Container(
                          width: 240,
                          height: 320,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(160),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                        Text(
                          type == 'IN' ? 'Clock In' : 'Clock Out',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 32,
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: type == 'IN'
                              ? Colors.green
                              : Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _isSubmitting ? null : _submitAttendance,
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                type == 'IN' ? 'CLOCK IN' : 'CLOCK OUT',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
