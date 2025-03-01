

import 'package:finden_test/domain/entities/todo_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';

class TaskCard extends ConsumerWidget {
  final TodoTask task;
  final VoidCallback onTap;

  const TaskCard({required this.task, required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
      },
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        child: ListTile(
          title: Text(task.title),
          subtitle: Text(task.dueDate.toString()),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              if (value != null) {
                ref.read(taskNotifierProvider.notifier).updateTask(task.copyWith(isCompleted: value));
              }
            },
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}