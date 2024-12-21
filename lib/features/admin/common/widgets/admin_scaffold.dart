// lib/features/admin/common/widgets/admin_scaffold.dart
import 'package:flutter/material.dart';
import 'admin_app_bar.dart';
import 'admin_bottom_nav.dart';

class AdminScaffold extends StatelessWidget {
  final String title;
  final String userName;
  final Widget body;
  final int currentIndex;
  final Function(int) onNavigationChanged;

  const AdminScaffold({
    Key? key,
    required this.title,
    required this.userName,
    required this.body,
    required this.currentIndex,
    required this.onNavigationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AdminAppBar(
                title: title,
                userName: userName,
              ),
            ),
            Expanded(
              child: body,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminBottomNav(
        currentIndex: currentIndex,
        onTap: onNavigationChanged,
      ),
    );
  }
}