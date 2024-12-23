// lib/features/admin/common/widgets/admin_app_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/auth/controllers/auth_controller.dart';
import '../../../../core/auth/views/login_view.dart';
import '../../admin_main_view.dart';
import '../../../surveyor/main/views/surveyor_main_view.dart';

class AdminAppBar extends StatelessWidget {
  final String title;

  const AdminAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

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
            Obx(() {
              final user = authController.userModel.value;
              return Text(
                'Hi, ${user?.fullName ?? "Admin"}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              );
            }),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              offset: const Offset(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() {
                final user = authController.userModel.value;
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300], // Default background
                  ),
                  child: user?.profileImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      user!.profileImage!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar(user.fullName);
                      },
                    ),
                  )
                      : _buildDefaultAvatar(user?.fullName ?? 'A'),
                );
              }),
              onSelected: (String value) async {
                switch (value) {
                  case 'edit_profile':
                    Get.offAllNamed('/admin', arguments: {'initialIndex': 3}); // Settings tab
                    break;
                  case 'switch_surveyor':
                    Get.offAllNamed('/surveyor');
                    break;
                  case 'logout':
                    await authController.signOut();
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'edit_profile',
                  child: Row(
                    children: const [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 12),
                      Text('Edit Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'switch_surveyor',
                  child: Row(
                    children: [
                      Icon(Icons.swap_horiz, size: 20),
                      SizedBox(width: 12),
                      Text('Switch to Surveyor'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      SizedBox(width: 12),
                      Text('Logout', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'A',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}