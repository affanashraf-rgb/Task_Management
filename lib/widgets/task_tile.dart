import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../screens/add_task_screen.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final bool isDone = task.isCompleted;
    final bool isUrgent = task.isUrgent;
    
    Color leftBorderColor = isDone ? Colors.grey : (isUrgent ? Colors.red : const Color(0xFF2962FF));
    Color timeBgColor = isDone ? Colors.grey[200]! : (isUrgent ? const Color(0xFFFFEBEE) : const Color(0xFFE8EAF6));
    Color timeTextColor = isDone ? Colors.grey : (isUrgent ? Colors.red : const Color(0xFF3F51B5));

    int totalSubtasks = task.subTasks.length;
    int completedSubtasks = task.subTasks.where((s) => s.isCompleted).length;

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen(task: task))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Colored Left Border
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: leftBorderColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Custom Checkbox (Circular)
                          GestureDetector(
                            onTap: () => context.read<TaskProvider>().toggleTaskCompletion(task),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDone ? Colors.grey : Colors.blueGrey[200]!,
                                  width: 2,
                                ),
                                color: isDone ? Colors.grey : Colors.transparent,
                              ),
                              child: isDone ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Title
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDone ? Colors.grey : const Color(0xFF263238),
                                decoration: isDone ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                          // Time Chip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: timeBgColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isDone ? "Done" : DateFormat('hh:mm\na').format(task.dueDate),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: timeTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Description
                      Padding(
                        padding: const EdgeInsets.only(left: 36.0),
                        child: Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blueGrey[400],
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Subtasks and Urgent Tag
                      Padding(
                        padding: const EdgeInsets.only(left: 36.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (totalSubtasks > 0)
                              Row(
                                children: [
                                  Icon(Icons.check_circle, size: 14, color: Colors.green[400]),
                                  const SizedBox(width: 4),
                                  Icon(Icons.radio_button_unchecked, size: 14, color: Colors.blueGrey[200]),
                                  const SizedBox(width: 8),
                                  Text(
                                    "SUBTASKS: $completedSubtasks/$totalSubtasks",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey[300],
                                    ),
                                  ),
                                ],
                              )
                            else
                              const SizedBox(),
                            if (isUrgent && !isDone)
                              const Text(
                                "URGENT",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  letterSpacing: 1.1,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
