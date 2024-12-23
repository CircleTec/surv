// lib/features/admin/admin_main_view.dart
import 'package:flutter/material.dart';
import 'common/widgets/admin_scaffold.dart';
import 'dashboard/views/dashboard_view.dart';
import 'survey_management/views/survey_management_view.dart';
import 'surveyor_management/views/surveyor_management_view.dart';
import 'settings/views/settings_view.dart';

class AdminMainView extends StatefulWidget {
  final int initialIndex;

  const AdminMainView({
    Key? key,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<AdminMainView> createState() => _AdminMainViewState();
}

class _AdminMainViewState extends State<AdminMainView> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    DashboardView(),
    SurveyManagementView(),
    SurveyorManagementView(),
    SettingsView(),
  ];

  final List<String> _titles = const [
    'Dashboard',
    'Survey Management',
    'Surveyor Management',
    'Settings',
  ];

  void _onNavigationChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: _titles[_currentIndex],
      currentIndex: _currentIndex,
      onNavigationChanged: _onNavigationChanged,
      body: _screens[_currentIndex],
    );
  }
}