





import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../infrasturcture/repositories/task_repository_impl.dart';
import 'task/task_notifier.dart';

final taskRepositoryProvider = Provider<TaskRepositoryImpl>((ref) => TaskRepositoryImpl());

final taskNotifierProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);