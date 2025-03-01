import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../domain/entities/todo_task.dart';
import '../../domain/failure/failure.dart';
import '../../domain/repositories/task_repository.dart';

class TaskState {
  final List<TodoTask> tasks;
  final bool isLoading;
  final dartz.Option<Failure> failure;

  TaskState({
    required this.tasks,
    required this.isLoading,
    required this.failure,
  });

  TaskState copyWith({
    List<TodoTask>? tasks,
    bool? isLoading,
    dartz.Option<Failure>? failure,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository repository;

  TaskNotifier(this.repository)
      : super(TaskState(tasks: [], isLoading: false, failure: dartz.none())); // Fixed 'none'

  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true);
    final result = await repository.getTasks();
    state = result.fold(
      (failure) => state.copyWith(isLoading: false, failure: dartz.some(failure)),
      (tasks) => state.copyWith(tasks: tasks, isLoading: false, failure: dartz.none()),
    );
  }

  Future<void> createTask(TodoTask task) async {
    final result = await repository.createTask(task);
    result.fold(
      (failure) => state = state.copyWith(failure: dartz.some(failure)),
      (_) => loadTasks(),
    );
  }

  Future<void> updateTask(TodoTask task) async {
    final result = await repository.updateTask(task);
    result.fold(
      (failure) => state = state.copyWith(failure: dartz.some(failure)),
      (_) => loadTasks(),
    );
  }

  Future<void> deleteTask(String id) async {
    final result = await repository.deleteTask(id);
    result.fold(
      (failure) => state = state.copyWith(failure: dartz.some(failure)),
      (_) => loadTasks(),
    );
  }
}