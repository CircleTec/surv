// lib/features/surveyor/common/widgets/surveyor_bottom_nav.dart
import 'package:flutter/material.dart';

class SurveyorBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const SurveyorBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: const Color(0xFF5EE0C5),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          label: 'Surveys',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
