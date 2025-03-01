


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/todo_task.dart';
import '../../domain/value_objects/priority.dart';
import 'package:uuid/uuid.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  final TodoTask? task;
  const TaskDetailPage({this.task, super.key});

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _dueDate;
  late Priority _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _priority = widget.task?.priority ?? Priority.medium;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate),
      );
      if (pickedTime != null) {
        setState(() {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'New Task' : 'Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextButton(
              onPressed: () => _selectDateTime(context),
              child: Text('Due: ${_dueDate.toString().substring(0, 16)}'), // Show date and time
            ),
            DropdownButton<Priority>(
              value: _priority,
              items: Priority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
              onChanged: (value) => setState(() => _priority = value!),
            ),
            ElevatedButton(
              onPressed: () {
                final task = TodoTask(
                  id: widget.task?.id ?? const Uuid().v4(),
                  title: _titleController.text,
                  description: _descController.text,
                  dueDate: _dueDate,
                  priority: _priority,
                  isCompleted: widget.task?.isCompleted ?? false,
                );
                final notifier = ref.read(taskNotifierProvider.notifier);
                widget.task == null ? notifier.createTask(task) : notifier.updateTask(task);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}