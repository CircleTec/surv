// lib/features/surveyor/settings/views/surveyor_settings_view.dart
import 'package:flutter/material.dart';

class SurveyorSettingsView extends StatefulWidget {
  const SurveyorSettingsView({Key? key}) : super(key: key);

  @override
  State<SurveyorSettingsView> createState() => _SurveyorSettingsViewState();
}

class _SurveyorSettingsViewState extends State<SurveyorSettingsView> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'James Franco',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@jamesfranco',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Settings List
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSettingsItem(
                  'User Name',
                  'jamesfranco',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  'Your Email',
                  'james@gmail.com',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  'Reset Password',
                  '',
                  showArrow: true,
                  onTap: () {},
                ),
                _buildSettingsItem(
                  'Notifications',
                  '',
                  trailing: Switch(
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        notificationsEnabled = value;
                      });
                    },
                    activeColor: const Color(0xFF5EE0C5),
                  ),
                ),
                _buildSettingsItem(
                  'Subscription information',
                  '',
                  showArrow: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
          // Done Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5EE0C5),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'DONE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
      String title,
      String value, {
        Widget? trailing,
        bool showArrow = false,
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (value.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                (showArrow
                    ? Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                )
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}