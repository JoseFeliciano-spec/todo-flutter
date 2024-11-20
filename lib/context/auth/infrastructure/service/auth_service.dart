import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/context/auth/domain/entities/auth.dart';
import 'package:todo_flutter/context/auth/domain/repositories/auth_repositories.dart';

class AuthService extends ChangeNotifier implements AuthRepository {
  final String baseUrl = 'https://todo-backend-nest-jjq1.onrender.com/v1/user';
  final http.Client client;

  AuthService(this.client);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  Future<String> register(String email, String password, String name) async {
    try {
      debugPrint('Iniciando registro con email: $email');

      final response = await client.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      debugPrint('Código de estado: ${response.statusCode}');
      debugPrint('Respuesta del servidor: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        final token = responseData['data']['access_token'];

        if (token == null) {
          throw Exception('Token no encontrado en la respuesta');
        }

        debugPrint('Se creó el usuario correctamente');
        notifyListeners();
        return token;
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Error desconocido';
        debugPrint('Error en registro: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error inesperado en registro: $e');
      rethrow;
    }
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      debugPrint('Iniciando login con email: $email');

      final response = await client.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      debugPrint('Código de estado login: ${response.statusCode}');
      debugPrint('Respuesta login: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        final token = responseData['data']['access_token'];

        if (token == null) {
          throw Exception('Token no encontrado en la respuesta');
        }

        // Guardar el token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        debugPrint('Token guardado exitosamente');

        notifyListeners();
        return token;
      } else {
        final errorMessage =
            responseData['message'] ?? 'Error de autenticación';
        debugPrint('Error en login: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error inesperado en login: $e');
      rethrow;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token no encontrado');
      }
      debugPrint(
          'Obteniendo usuario actual con token: ${token.substring(0, 10)}...');

      final response = await client.get(
        Uri.parse('$baseUrl/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint('Código de estado getCurrentUser: ${response.statusCode}');
      debugPrint('Respuesta getCurrentUser: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('${response.statusCode}');
        final jsonData = json.decode(response.body)['data'];
        final user = User.fromJson(jsonData);
        debugPrint('Usuario actual obtenido: ${user.toString()}');
        return user;
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Error al obtener usuario';
        debugPrint('Error en getCurrentUser: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error inesperado en getCurrentUser: $e');
      rethrow;
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      debugPrint('Token recuperado: ${token?.substring(0, 10)}...');
      return token;
    } catch (e) {
      debugPrint('Error al recuperar token: $e');
      return null;
    }
  }

  Future<void> removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      debugPrint('Token eliminado exitosamente');
      notifyListeners();
    } catch (e) {
      debugPrint('Error al eliminar token: $e');
      rethrow;
    }
  }
}
