import 'package:flutter/material.dart';

import '../../../../core/auth/views/login_view.dart';
import '../../admin_main_view.dart';

class AdminAppBar extends StatelessWidget {
  final String title;
  final String userName;

  const AdminAppBar({
    Key? key,
    required this.title,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hi, $userName',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 8),
            PopupMenuButton<void>(
              offset: const Offset(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF5EE0C5),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: const [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 12),
                      Text('Edit Profile'),
                    ],
                  ),
                  onTap: () {
                    // Navigate to settings page after menu closes
                    Future.delayed(
                      const Duration(seconds: 0),
                          () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AdminMainView(initialIndex: 3), // Settings tab
                        ),
                      ),
                    );
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: const [
                      Icon(Icons.swap_horiz, size: 20),
                      SizedBox(width: 12),
                      Text('Switch to Surveyor'),
                    ],
                  ),
                  onTap: () {
                    // TODO: Implement switch to surveyor view
                  },
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      SizedBox(width: 12),
                      Text('Logout', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () {
                    // Navigate to login page after menu closes
                    Future.delayed(
                      const Duration(seconds: 0),
                          () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}