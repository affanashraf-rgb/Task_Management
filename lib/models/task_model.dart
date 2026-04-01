class Task {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  String repeat; // 'none', 'daily', 'weekly'
  bool isUrgent;
  List<SubTask> subTasks;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.repeat = 'none',
    this.isUrgent = false,
    this.subTasks = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'repeat': repeat,
      'isUrgent': isUrgent ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      repeat: map['repeat'],
      isUrgent: map['isUrgent'] == 1,
    );
  }

  double get progress {
    if (subTasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    int completedSubTasks = subTasks.where((st) => st.isCompleted).length;
    return completedSubTasks / subTasks.length;
  }
}

class SubTask {
  int? id;
  int taskId;
  String title;
  bool isCompleted;

  SubTask({
    this.id,
    required this.taskId,
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory SubTask.fromMap(Map<String, dynamic> map) {
    return SubTask(
      id: map['id'],
      taskId: map['taskId'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
