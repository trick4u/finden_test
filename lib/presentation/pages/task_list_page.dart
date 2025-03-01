import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/todo_task.dart';
import '../../domain/value_objects/priority.dart';
import '../ui/task_card.dart';
import 'package:rxdart/rxdart.dart';

import 'task_detail_page.dart';

class TaskListPage extends ConsumerWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskNotifierProvider);
    final filterState = ref.watch(filterProvider);
    final taskNotifier = ref.read(taskNotifierProvider.notifier);
    final filterNotifier = ref.read(filterProvider.notifier);

    // Apply filtering
    final filteredTasks = taskState.when(
      data: (tasks) {
        var filtered = tasks;

        if (filterState.searchQuery.isNotEmpty) {
          filtered = filtered
              .where((task) => task.title.toLowerCase().contains(filterState.searchQuery.toLowerCase()))
              .toList();
        }

        if (filterState.priority != null) {
          filtered = filtered.where((task) => task.priority == filterState.priority).toList();
        }

        if (filterState.isCompleted != null) {
          filtered = filtered.where((task) => task.isCompleted == filterState.isCompleted).toList();
        }

        return filtered..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      },
      loading: () => [],
      error: (_, __) => [],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: taskNotifier.history.isEmpty ? null : taskNotifier.undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: taskNotifier.redoStack.isEmpty ? null : taskNotifier.redo,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterNotifier.updateSearchQuery,
              decoration: const InputDecoration(labelText: 'Search Tasks', border: OutlineInputBorder()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<Priority?>(
                value: filterState.priority,
                hint: const Text('Priority'),
                items: [null, ...Priority.values]
                    .map((p) => DropdownMenuItem(value: p, child: Text(p?.name ?? 'All')))
                    .toList(),
                onChanged: filterNotifier.updatePriority,
              ),
              DropdownButton<bool?>(
                value: filterState.isCompleted,
                hint: const Text('Status'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: false, child: Text('Pending')),
                  DropdownMenuItem(value: true, child: Text('Completed')),
                ],
                onChanged: filterNotifier.updateIsCompleted,
              ),
            ],
          ),
          Expanded(
            child: taskState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (_) => ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskDetailPage())),
        child: const Icon(Icons.add),
      ),
    );
  }
}