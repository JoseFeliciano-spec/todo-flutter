import 'package:todo_flutter/context/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Future<Task> createTask(Task task);
  Future<void> deleteTask(String id);
  Future<List<Task>> fetchTasks();
  Future<Task> updateTask(Task task);
}
