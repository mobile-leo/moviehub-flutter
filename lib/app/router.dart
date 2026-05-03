import 'package:go_router/go_router.dart';
import '../features/detail/detail_screen.dart';
import '../features/home/home_screen.dart';
import '../features/search/search_screen.dart';
import '../features/shell/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/detail/:id/:mediaType',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final mediaType = state.pathParameters['mediaType']!;
        return DetailScreen(movieId: id, mediaType: mediaType);
      },
    ),
  ],
);
