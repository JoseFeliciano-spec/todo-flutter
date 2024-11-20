import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenida')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido a la App'),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Iniciar Sesión'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/register'),
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
