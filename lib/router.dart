import 'package:go_router/go_router.dart';
import 'package:todo_flutter/context/welcome/infrastructure/pages/welcome_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
  ],
  initialLocation: '/welcome', // Página inicial
);
