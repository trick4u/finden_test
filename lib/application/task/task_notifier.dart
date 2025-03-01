import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finden_test/domain/entities/todo_task.dart';

import 'package:finden_test/domain/repositories/task_repository.dart';

import '../../domain/failure/failure.dart';

enum TaskActionType { create, update, delete }

class TaskAction {
  final TaskActionType type;
  final TodoTask task;

  TaskAction(this.type, this.task);
}

class TaskState {
  final List<TodoTask> tasks;
  final bool isLoading;
  final dartz.Option<Failure> failure;
  final List<TaskAction> history;
  final List<TaskAction> redoStack;

  TaskState({
    required this.tasks,
    required this.isLoading,
    required this.failure,
    required this.history,
    required this.redoStack,
  });

  TaskState copyWith({
    List<TodoTask>? tasks,
    bool? isLoading,
    dartz.Option<Failure>? failure,
    List<TaskAction>? history,
    List<TaskAction>? redoStack,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
      history: history ?? this.history,
      redoStack: redoStack ?? this.redoStack,
    );
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository repository;

  TaskNotifier(this.repository)
      : super(TaskState(
          tasks: [],
          isLoading: false,
          failure: dartz.none(),
          history: [],
          redoStack: [],
        ));

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
      (_) {
        state = state.copyWith(
          tasks: [...state.tasks, task],
          history: [...state.history, TaskAction(TaskActionType.create, task)],
          redoStack: [],
        );
      },
    );
  }

  Future<void> updateTask(TodoTask task) async {
    final oldTask = state.tasks.firstWhere((t) => t.id == task.id);
    final result = await repository.updateTask(task);
    result.fold(
      (failure) => state = state.copyWith(failure: dartz.some(failure)),
      (_) {
        state = state.copyWith(
          tasks: state.tasks.map((t) => t.id == task.id ? task : t).toList(),
          history: [...state.history, TaskAction(TaskActionType.update, oldTask)],
          redoStack: [],
        );
      },
    );
  }

  Future<void> deleteTask(String id) async {
    final task = state.tasks.firstWhere((t) => t.id == id);
    final result = await repository.deleteTask(id);
    result.fold(
      (failure) => state = state.copyWith(failure: dartz.some(failure)),
      (_) {
        state = state.copyWith(
          tasks: state.tasks.where((t) => t.id != id).toList(),
          history: [...state.history, TaskAction(TaskActionType.delete, task)],
          redoStack: [],
        );
      },
    );
  }

  void undo() {
    if (state.history.isEmpty) return;
    final lastAction = state.history.last;
    state = state.copyWith(history: state.history.sublist(0, state.history.length - 1));

    switch (lastAction.type) {
      case TaskActionType.create:
        deleteTask(lastAction.task.id);
        break;
      case TaskActionType.update:
        updateTask(lastAction.task);
        break;
      case TaskActionType.delete:
        createTask(lastAction.task);
        break;
    }
    state = state.copyWith(redoStack: [...state.redoStack, lastAction]);
  }

  void redo() {
    if (state.redoStack.isEmpty) return;
    final nextAction = state.redoStack.last;
    state = state.copyWith(redoStack: state.redoStack.sublist(0, state.redoStack.length - 1));

    switch (nextAction.type) {
      case TaskActionType.create:
        createTask(nextAction.task);
        break;
      case TaskActionType.update:
        updateTask(nextAction.task);
        break;
      case TaskActionType.delete:
        deleteTask(nextAction.task.id);
        break;
    }
    state = state.copyWith(history: [...state.history, nextAction]);
  }
}