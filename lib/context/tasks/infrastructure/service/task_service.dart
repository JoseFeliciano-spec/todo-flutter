import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_flutter/context/tasks/domain/entities/task.dart';
import 'package:todo_flutter/context/tasks/domain/repositories/task_repository.dart';

class TaskService implements TaskRepository {
  final String baseUrl = 'http://35.231.57.95:8096/v1/tasks';
  final http.Client client;

  TaskService(this.client);

  @override
  Future<List<Task>> getTasks() async {
    final response = await client.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  @override
  Future<void> createTask(Task task) async {
    await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
  }

  @override
  Future<void> updateTask(Task task) async {
    await client.put(
      Uri.parse('$baseUrl/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    await client.delete(Uri.parse('$baseUrl/$id'));
  }
}
