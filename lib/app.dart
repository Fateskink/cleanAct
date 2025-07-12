import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/authentication/presentation/pages/register_page.dart';
import 'features/authentication/presentation/providers/auth_provider.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/academy/presentation/pages/course_list_page.dart';
import 'features/tournament/presentation/pages/tournament_placeholder_page.dart';
import 'features/sns/presentation/pages/sns_placeholder_page.dart';

/// Main application widget
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = _createRouter(ref);

    return MaterialApp.router(
      title: 'CleanAct - Billiard Ecosystem',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }

  /// Create GoRouter configuration
  GoRouter _createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: _RouterRefreshNotifier(ref),
      redirect: (context, state) {
        final authState = ref.read(authProvider);
        final isLoggedIn = authState.user != null;
        final isLoggingIn = state.matchedLocation == '/login' ||
                           state.matchedLocation == '/register';

        // If not logged in and not on auth pages, redirect to login
        if (!isLoggedIn && !isLoggingIn) {
          return '/login';
        }

        // If logged in and on auth pages, redirect to home
        if (isLoggedIn && isLoggingIn) {
          return '/home';
        }

        return null;
      },
      routes: [
        // Authentication routes
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),

        // Main app routes
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),

        // Academy routes
        GoRoute(
          path: '/academy',
          name: 'academy',
          builder: (context, state) => const CourseListPage(),
        ),
        GoRoute(
          path: '/academy/course/:courseId',
          name: 'course-detail',
          builder: (context, state) {
            // ignore: unused_local_variable
            final courseId = state.pathParameters['courseId']!;
            // TODO: Pass courseId to CourseDetailPage when implemented
            return const Placeholder(); // CourseDetailPage will be implemented later
          },
        ),

        // Tournament routes (placeholder)
        GoRoute(
          path: '/tournament',
          name: 'tournament',
          builder: (context, state) => const TournamentPlaceholderPage(),
        ),

        // SNS routes (placeholder)
        GoRoute(
          path: '/sns',
          name: 'sns',
          builder: (context, state) => const SnsPlaceholderPage(),
        ),
      ],
    );
  }
}

/// Router refresh notifier to listen for auth state changes
class _RouterRefreshNotifier extends ChangeNotifier {
  final WidgetRef _ref;

  _RouterRefreshNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (previous, next) {
      // Notify router to refresh when auth state changes
      notifyListeners();
    });
  }
}
