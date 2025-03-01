





import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/todo_task.dart';
import '../domain/value_objects/priority.dart';
import '../infrasturcture/repositories/task_repository_impl.dart';
import 'task/task_notifier.dart';

final taskRepositoryProvider = Provider<TaskRepositoryImpl>((ref) => TaskRepositoryImpl());

final taskNotifierProvider = StateNotifierProvider<TaskNotifier, AsyncValue<List<TodoTask>>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

class FilterState {
  final String searchQuery;
  final Priority? priority;
  final bool? isCompleted;

  FilterState({
    this.searchQuery = '',
    this.priority,
    this.isCompleted,
  });

  FilterState copyWith({
    String? searchQuery,
    Priority? priority,
    bool? isCompleted,
  }) {
    return FilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState());

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updatePriority(Priority? priority) {
    state = state.copyWith(priority: priority);
  }

  void updateIsCompleted(bool? isCompleted) {
    state = state.copyWith(isCompleted: isCompleted);
  }
}