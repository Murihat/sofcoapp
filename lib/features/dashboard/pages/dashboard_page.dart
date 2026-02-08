import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final c = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: c.logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              c.user.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(c.user.email),
          ),
        ),
      ),
    );
  }
}
