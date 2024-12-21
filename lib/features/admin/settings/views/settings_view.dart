// lib/features/admin/settings/views/settings_view.dart
import 'package:flutter/cupertino.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings Content'),
          // Add your settings content here
        ],
      ),
    );
  }
}