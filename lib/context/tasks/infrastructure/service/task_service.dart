import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/context/tasks/domain/entities/task.dart';
import 'package:todo_flutter/context/tasks/domain/repositories/task_repository.dart';

class TaskService extends ChangeNotifier implements TaskRepository {
  final String baseUrl = 'https://todo-backend-nest-jjq1.onrender.com/v1/tasks';
  final http.Client client;

  TaskService(this.client);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  Future<Task> createTask(Task task) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token no encontrado');
      }

      debugPrint('Creando tarea: ${task.title}');

      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(task.toJson()),
      );

      debugPrint('Código de estado createTask: ${response.statusCode}');
      debugPrint('Respuesta createTask: ${response.body}');

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body)['data'];
        final createdTask = Task.fromJson(jsonData);
        debugPrint('Tarea creada exitosamente: ${createdTask.toString()}');
        return createdTask;
      } else {
        final errorMessage = json.decode(response.body)['message'] ??
            'Error desconocido al crear tarea';
        debugPrint('Error en createTask: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error inesperado en createTask: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token no encontrado');
      }

      debugPrint('Eliminando tarea con id: $id');

      final response = await client.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Código de estado deleteTask: ${response.statusCode}');
      debugPrint('Respuesta deleteTask: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Tarea eliminada correctamente');
        notifyListeners();
      } else {
        final errorMessage = json.decode(response.body)['message'] ??
            'Error al eliminar la tarea';
        debugPrint('Error en deleteTask: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error inesperado en deleteTask: $e');
      rethrow;
    }
  }

  @override
  Future<List<Task>> fetchTasks() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token no encontrado');
      }

      debugPrint('Obteniendo todas las tareas');

      final response = await client.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Código de estado fetchTasks: ${response.statusCode}');
      debugPrint('Respuesta fetchTasks: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];
        final tasks = jsonData.map((task) => Task.fromJson(task)).toList();
        debugPrint('Tareas recuperadas correctamente');
        return tasks;
      } else {
        final errorMessage = json.decode(response.body)['message'] ??
            'Error al obtener las tareas';
        debugPrint('Error en fetchTasks: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error inesperado en fetchTasks: $e');
      rethrow;
    }
  }

  @override
  Future<Task> updateTask(Task task) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token no encontrado');
      }

      debugPrint('Actualizando tarea: ${task.id}');

      final response = await client.put(
        Uri.parse('$baseUrl/${task.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(task.toJson()),
      );

      debugPrint('Código de estado updateTask: ${response.statusCode}');
      debugPrint('Respuesta updateTask: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        final updatedTask = Task.fromJson(jsonData);
        debugPrint(
            'Tarea actualizada correctamente: ${updatedTask.toString()}');
        notifyListeners();
        return updatedTask;
      } else {
        final errorMessage = json.decode(response.body)['message'] ??
            'Error al actualizar la tarea';
        debugPrint('Error en updateTask: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error inesperado en updateTask: $e');
      rethrow;
    }
  }
}
