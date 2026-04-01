import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../database/db_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isDarkMode = false;

  List<Task> get tasks => _tasks;
  bool get isDarkMode => _isDarkMode;

  List<Task> get todayTasks {
    DateTime now = DateTime.now();
    return _tasks.where((task) {
      return task.dueDate.year == now.year &&
          task.dueDate.month == now.month &&
          task.dueDate.day == now.day;
    }).toList();
  }

  List<Task> get completedTasks {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  List<Task> get repeatedTasks {
    return _tasks.where((task) => task.repeat != 'none').toList();
  }

  Future<void> loadTasks() async {
    _tasks = await DBHelper().getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await DBHelper().insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await DBHelper().updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await DBHelper().deleteTask(id);
    await loadTasks();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }
}
