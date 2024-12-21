// lib/features/surveyor/common/widgets/surveyor_scaffold.dart
import 'package:flutter/material.dart';
import 'surveyor_app_bar.dart';
import 'surveyor_bottom_nav.dart';

class SurveyorScaffold extends StatelessWidget {
  final String title;
  final String userName;
  final Widget body;
  final int currentIndex;
  final Function(int) onNavigationChanged;

  const SurveyorScaffold({
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
              child: SurveyorAppBar(
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
      bottomNavigationBar: SurveyorBottomNav(
        currentIndex: currentIndex,
        onTap: onNavigationChanged,
      ),
    );
  }
}