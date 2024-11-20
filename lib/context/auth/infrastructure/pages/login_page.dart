import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/context/auth/infrastructure/service/auth_service.dart';

// Página de inicio de sesión
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool isLogin = true; // Alternar entre inicio de sesión y registro
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool isPasswordVisible = false;

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    // Configuración de animación
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward(); // Inicia la animación al cargar la página
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void toggleLoginRegister() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeInAnimation, // Aplica la animación de opacidad
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Bienvenido a FeliTasks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  isLogin
                      ? "Inicia sesión para gestionar tus tareas"
                      : "Regístrate para empezar a gestionar tus tareas",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: toggleLoginRegister,
                      child: Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          color: isLogin ? Colors.white : Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: toggleLoginRegister,
                      child: Text(
                        "Registrarse",
                        style: TextStyle(
                          color: isLogin ? Colors.grey : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.email, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                if (!isLogin)
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nombre completo",
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.person, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                if (!isLogin) const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: togglePasswordVisibility,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final name = nameController.text.trim();

                    try {
                      if (isLogin) {
                        // Login

                        await authService.login(email, password);
                        /* await authService.getCurrentUser(); */
                        // ignore: use_build_context_synchronously
                        context.replace("/home");

                        setState(() {});

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('¡Inicio de sesión exitoso!')),
                        );
                      } else {
                        await authService.register(email, password, name);
                        /* await authService.getCurrentUser(); */
                        // ignore: use_build_context_synchronously
                        toggleLoginRegister();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('¡Registro exitoso!')),
                        );

                        if (mounted) {
                          // Después de registrar, navegar a la página principal
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },
                  child: Text(
                    isLogin ? "Iniciar sesión" : "Registrarse",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
