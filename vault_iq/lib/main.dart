import 'package:flutter/material.dart';

import 'screens/admin_dashboard.dart';

class AppRoutes {
  static const String home = '/';
}

void main() {
  runApp(const VaultIQApp());
}

class VaultIQApp extends StatefulWidget {
  const VaultIQApp({super.key});

  @override
  State<VaultIQApp> createState() => _VaultIQAppState();
}

class _VaultIQAppState extends State<VaultIQApp> {
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.light);

  void _toggleTheme() {
    _themeMode.value =
        _themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeData _buildLightTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue.shade700,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.blueGrey.shade200),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.blueGrey.shade200,
        space: 1,
      ),
      textTheme: Typography.blackMountainView,
    );
  }

  ThemeData _buildDarkTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue.shade700,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF111827),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.blueGrey.shade700),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF111827),
        foregroundColor: Colors.white,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.blueGrey.shade700,
        space: 1,
      ),
      textTheme: Typography.whiteMountainView,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'VaultIQ',
          debugShowCheckedModeBanner: false,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: mode,
          initialRoute: AppRoutes.home,
          routes: {
            AppRoutes.home: (_) => DashboardScreen(
              isDarkMode: mode == ThemeMode.dark,
              onToggleTheme: _toggleTheme,
            ),
          },
        );
      },
    );
  }
}