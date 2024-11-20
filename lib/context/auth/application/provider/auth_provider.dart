import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter/context/tasks/domain/entities/task.dart';

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier();
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier() : super([]);

  void addTask(Task task) {
    state = [...state, task];
  }

  void updateTask(Task task) {
    state = state.map((t) => t.id == task.id ? task : t).toList();
  }

  void deleteTask(String id) {
    state = state.where((t) => t.id != id).toList();
  }
}
