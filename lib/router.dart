import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/context/auth/infrastructure/pages/login_page.dart';
import 'package:todo_flutter/context/auth/infrastructure/service/auth_service.dart';
import 'package:todo_flutter/context/tasks/infrastructure/pages/home.dart';
import 'package:todo_flutter/context/welcome/infrastructure/pages/welcome_page.dart';

final router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomePage(),
    ),
  ],
  redirect: (context, state) async {
    final authService = context.read<AuthService>();
    final token = await authService.getToken();
    final String currentUrl = state.uri.toString();

    if (token == null && currentUrl != '/login' && currentUrl != '/welcome') {
      return '/login';
    }

    if (token != null && (currentUrl == '/welcome' || currentUrl == '/login')) {
      return '/home';
    }

    return null;
  },
);
