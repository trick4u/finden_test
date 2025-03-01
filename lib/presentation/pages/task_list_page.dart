import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../ui/task_card.dart';


class TaskListPage extends ConsumerWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: taskState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: taskState.tasks.length,
              itemBuilder: (context, index) {
                final task = taskState.tasks[index];
                return TaskCard(
                  task: task,
                  onTap: () {},
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}