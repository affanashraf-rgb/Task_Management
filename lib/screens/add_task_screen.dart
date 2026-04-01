import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../services/notification_service.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  const AddTaskScreen({super.key, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _selectedDate;
  late String _repeat;
  late bool _isUrgent;
  late List<SubTask> _subTasks;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _selectedDate = widget.task?.dueDate ?? DateTime.now();
    _repeat = widget.task?.repeat ?? 'none';
    _isUrgent = widget.task?.isUrgent ?? false;
    _subTasks = widget.task?.subTasks != null 
        ? List.from(widget.task!.subTasks.map((st) => SubTask(id: st.id, taskId: st.taskId, title: st.title, isCompleted: st.isCompleted))) 
        : [];
  }

  void _addSubTask() {
    setState(() {
      _subTasks.add(SubTask(taskId: widget.task?.id ?? 0, title: ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task', style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Task Title',
                  border: InputBorder.none,
                ),
                onSaved: (val) => _title = val!,
                validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _description,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add description...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSaved: (val) => _description = val!,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("DUE DATE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(DateFormat('MMM d, yyyy').format(_selectedDate)),
                          trailing: const Icon(Icons.calendar_today_outlined, size: 20),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setState(() => _selectedDate = DateTime(picked.year, picked.month, picked.day, _selectedDate.hour, _selectedDate.minute));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("TIME", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(DateFormat('hh:mm a').format(_selectedDate)),
                          trailing: const Icon(Icons.access_time, size: 20),
                          onTap: () async {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_selectedDate),
                            );
                            if (time != null) {
                              setState(() {
                                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, time.hour, time.minute);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Urgent Task", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Mark this task as high priority"),
                value: _isUrgent,
                activeColor: Colors.red,
                onChanged: (val) => setState(() => _isUrgent = val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _repeat,
                decoration: const InputDecoration(labelText: 'Repeat Interval', border: OutlineInputBorder()),
                items: ['none', 'daily', 'weekly'].map((val) => DropdownMenuItem(value: val, child: Text(val.toUpperCase()))).toList(),
                onChanged: (val) => setState(() => _repeat = val!),
              ),
              const SizedBox(height: 32),
              const Text('SUBTASKS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              ..._subTasks.asMap().entries.map((entry) {
                int idx = entry.key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _subTasks[idx].isCompleted,
                        onChanged: (val) => setState(() => _subTasks[idx].isCompleted = val!),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: _subTasks[idx].title,
                          decoration: const InputDecoration(hintText: 'Enter subtask...'),
                          onChanged: (val) => _subTasks[idx].title = val,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red, size: 20),
                        onPressed: () => setState(() => _subTasks.removeAt(idx)),
                      )
                    ],
                  ),
                );
              }).toList(),
              TextButton.icon(
                onPressed: _addSubTask,
                icon: const Icon(Icons.add),
                label: const Text('Add Subtask'),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2962FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final task = Task(
                        id: widget.task?.id,
                        title: _title,
                        description: _description,
                        dueDate: _selectedDate,
                        repeat: _repeat,
                        isUrgent: _isUrgent,
                        subTasks: _subTasks,
                        isCompleted: widget.task?.isCompleted ?? false,
                      );
                      
                      if (widget.task == null) {
                        await context.read<TaskProvider>().addTask(task);
                      } else {
                        await context.read<TaskProvider>().updateTask(task);
                      }

                      if (!task.isCompleted && task.dueDate.isAfter(DateTime.now())) {
                        NotificationService().scheduleNotification(
                          task.id ?? DateTime.now().millisecondsSinceEpoch % 100000, 
                          task.title, 
                          task.description, 
                          task.dueDate
                        );
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.task == null ? 'Create Task' : 'Update Task', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
