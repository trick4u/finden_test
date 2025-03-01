


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
  late TextEditingController titleController;
  late TextEditingController descController;
  late DateTime dueDate;
  late Priority priority;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descController = TextEditingController(text: widget.task?.description ?? '');
    dueDate = widget.task?.dueDate ?? DateTime.now();
    priority = widget.task?.priority ?? Priority.medium;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'New Task' : 'Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => dueDate = picked);
              },
              child: Text('Due: ${dueDate.toString().split(' ')[0]}'),
            ),
            DropdownButton<Priority>(
              value: priority,
              items: Priority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
              onChanged: (value) => setState(() => priority = value!),
            ),
            ElevatedButton(
              onPressed: () {
                final task = TodoTask(
                  id: widget.task?.id ?? const Uuid().v4(),
                  title: titleController.text,
                  description: descController.text,
                  dueDate: dueDate,
                  priority: priority,
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