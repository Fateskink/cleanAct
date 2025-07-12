import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../authentication/presentation/providers/auth_provider.dart';

/// Home page with navigation to different modules
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CleanAct'),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context, ref),
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.sports_tennis,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to CleanAct',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your complete billiard ecosystem',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Module navigation cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _ModuleCard(
                    title: 'Academy',
                    subtitle: 'Learn billiard skills',
                    icon: Icons.school,
                    color: Colors.blue,
                    onTap: () => context.go('/academy'),
                  ),
                  _ModuleCard(
                    title: 'Tournament',
                    subtitle: 'Compete with others',
                    icon: Icons.emoji_events,
                    color: Colors.orange,
                    onTap: () => context.go('/tournament'),
                  ),
                  _ModuleCard(
                    title: 'Social',
                    subtitle: 'Connect with players',
                    icon: Icons.people,
                    color: Colors.purple,
                    onTap: () => context.go('/sns'),
                  ),
                  _ModuleCard(
                    title: 'Profile',
                    subtitle: 'Manage your account',
                    icon: Icons.person,
                    color: Colors.green,
                    onTap: () {
                      // TODO: Navigate to profile
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performLogout(context, ref);
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  /// Perform logout operation
  Future<void> _performLogout(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading indicator
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Call logout from auth provider
      await ref.read(authProvider.notifier).logout();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Navigate to login page
        context.go('/login');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng xuất thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi đăng xuất: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
