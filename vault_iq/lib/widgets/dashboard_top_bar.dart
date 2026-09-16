import 'package:flutter/material.dart';

class DashboardTopBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardTopBar({
    super.key,
    required this.title,
    required this.onNotificationTap,
    required this.userName,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final String title;
  final VoidCallback onNotificationTap;
  final String userName;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onToggleTheme,
          icon: Icon(
            isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
          tooltip: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
        ),
        IconButton(
          onPressed: onNotificationTap,
          icon: const Icon(Icons.notifications_outlined),
          tooltip: 'Notifications',
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: colorScheme.primary,
            child: Text(
              userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'K',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
