// lib/features/surveyor/main/views/surveyor_main_view.dart
import 'package:flutter/material.dart';
import '../../survey_response/views/surveyor_surveys_view.dart';
import '../../settings/views/surveyor_settings_view.dart';
import '../../common/widgets/surveyor_scaffold.dart';

class SurveyorMainView extends StatefulWidget {
  const SurveyorMainView({Key? key}) : super(key: key);

  @override
  State<SurveyorMainView> createState() => _SurveyorMainViewState();
}

class _SurveyorMainViewState extends State<SurveyorMainView> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SurveyorSurveysView(),
    SurveyorSettingsView(),
  ];

  final List<String> _titles = const [
    'Surveys',
    'Settings',
  ];

  void _onNavigationChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SurveyorScaffold(
      title: _titles[_currentIndex],
      userName: 'Nathan',
      currentIndex: _currentIndex,
      onNavigationChanged: _onNavigationChanged,
      body: _screens[_currentIndex],
    );
  }
}