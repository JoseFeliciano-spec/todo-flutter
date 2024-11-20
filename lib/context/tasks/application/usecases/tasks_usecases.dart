import 'package:todo_flutter/context/tasks/domain/entities/task.dart';
import 'package:todo_flutter/context/tasks/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<Task>> call() async {
    return await repository.getTasks();
  }
}

class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<void> call(Task task) async {
    return await repository.createTask(task);
  }
}

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<void> call(Task task) async {
    return await repository.updateTask(task);
  }
}

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteTask(id);
  }
}
