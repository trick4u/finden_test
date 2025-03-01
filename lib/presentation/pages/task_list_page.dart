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
    final taskNotifier = ref.read(taskNotifierProvider.notifier);
    final themeMode = ref.watch(themeProvider);

    final TextEditingController searchController = TextEditingController();
    final BehaviorSubject<String> searchSubject = BehaviorSubject<String>();
    List<TodoTask> filteredTasks = taskState.tasks;

    searchSubject.debounceTime(const Duration(milliseconds: 300)).listen((query) {
      filteredTasks = taskState.tasks;
      if (query.isNotEmpty) {
        filteredTasks = filteredTasks.where((task) => task.title.toLowerCase().contains(query.toLowerCase())).toList();
      }
      (context as Element).markNeedsBuild();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: taskState.history.isEmpty ? null : taskNotifier.undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: taskState.redoStack.isEmpty ? null : taskNotifier.redo,
          ),
          IconButton(
            icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).state =
                  themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: 'Search Tasks', border: OutlineInputBorder()),
              onChanged: (value) => searchSubject.add(value),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              Priority? filterPriority;
              bool? filterCompleted;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<Priority?>(
                    value: filterPriority,
                    hint: const Text('Priority'),
                    items: [null, ...Priority.values]
                        .map((p) => DropdownMenuItem(value: p, child: Text(p?.name ?? 'All')))
                        .toList(),
                    onChanged: (value) {
                      filterPriority = value;
                      filteredTasks = taskState.tasks;
                      if (filterPriority != null) {
                        filteredTasks = filteredTasks.where((task) => task.priority == filterPriority).toList();
                      }
                      if (filterCompleted != null) {
                        filteredTasks = filteredTasks.where((task) => task.isCompleted == filterCompleted).toList();
                      }
                      filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  DropdownButton<bool?>(
                    value: filterCompleted,
                    hint: const Text('Status'),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All')),
                      DropdownMenuItem(value: false, child: Text('Pending')),
                      DropdownMenuItem(value: true, child: Text('Completed')),
                    ],
                    onChanged: (value) {
                      filterCompleted = value;
                      filteredTasks = taskState.tasks;
                      if (filterPriority != null) {
                        filteredTasks = filteredTasks.where((task) => task.priority == filterPriority).toList();
                      }
                      if (filterCompleted != null) {
                        filteredTasks = filteredTasks.where((task) => task.isCompleted == filterCompleted).toList();
                      }
                      filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ],
              );
            },
          ),
          Expanded(
            child: taskState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return TaskCard(
                        task: task,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailPage(task: task))),
                      );
                    },
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