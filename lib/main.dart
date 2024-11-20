import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:todo_flutter/context/auth/infrastructure/service/auth_service.dart';
import 'package:todo_flutter/context/tasks/infrastructure/service/task_service.dart';
import 'router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => http.Client()),
        ChangeNotifierProvider(
            create: (context) => AuthService(context.read<http.Client>())),
        ChangeNotifierProvider(
            create: (context) => TaskService(context.read<http.Client>())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TodoApp | Siesa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
