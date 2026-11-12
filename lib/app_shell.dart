import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_dimens.dart';
import 'features/checkin/presentation/checkin_screen.dart';
import 'features/exercises/presentation/browse_screen.dart';
import 'features/servers/presentation/server_connection_screen.dart';
import 'features/tracking/presentation/history_screen.dart';

/// Bottom-nav shell tying the three main tabs together. This is the one
/// place composing full-screen features into the app's overall navigation;
/// each tab's actual UI lives in its own feature folder.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  List<Widget> get _screens => const [
    ServerConnectionScreen(),
    CheckInScreen(),
    BrowseScreen(),
    HistoryScreen(),
  ];

  static const _items = [
    (icon: Icons.cloud_outlined, selectedIcon: Icons.cloud, label: 'Servers'),
    (
      icon: Icons.self_improvement_outlined,
      selectedIcon: Icons.self_improvement,
      label: 'Check In',
    ),
    (icon: Icons.spa_outlined, selectedIcon: Icons.spa, label: 'Browse'),
    (
      icon: Icons.timeline_outlined,
      selectedIcon: Icons.timeline,
      label: 'History',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: _FloatingNavBar(
          selectedIndex: _index,
          items: _items,
          onSelected: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<({IconData icon, IconData selectedIcon, String label})> items;
  final ValueChanged<int> onSelected;

  const _FloatingNavBar({
    required this.selectedIndex,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (i) {
            final item = items[i];
            final selected = i == selectedIndex;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                onTap: () => onSelected(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      selected ? item.selectedIcon : item.icon,
                      size: 22,
                      color:
                          selected
                              ? AppColors.primaryStrong
                              : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            selected
                                ? AppColors.primaryStrong
                                : AppColors.textSecondary,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
