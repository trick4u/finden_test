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

class TaskNotifier extends StateNotifier<AsyncValue<List<TodoTask>>> {
  final TaskRepository repository;
  final List<TaskAction> history = [];
  final List<TaskAction> redoStack = [];

  TaskNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    final result = await repository.getTasks();
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      AsyncValue.data,
    );
  }

  Future<void> createTask(TodoTask task) async {
    final result = await repository.createTask(task);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = AsyncValue.data([...state.value ?? [], task]);
        history.add(TaskAction(TaskActionType.create, task));
        redoStack.clear();
      },
    );
  }

  Future<void> updateTask(TodoTask task) async {
    final oldTask = (state.value ?? []).firstWhere((t) => t.id == task.id);
    final result = await repository.updateTask(task);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = AsyncValue.data((state.value ?? []).map((t) => t.id == task.id ? task : t).toList());
        history.add(TaskAction(TaskActionType.update, oldTask));
        redoStack.clear();
      },
    );
  }

  Future<void> deleteTask(String id) async {
    final task = (state.value ?? []).firstWhere((t) => t.id == id);
    final result = await repository.deleteTask(id);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = AsyncValue.data((state.value ?? []).where((t) => t.id != id).toList());
        history.add(TaskAction(TaskActionType.delete, task));
        redoStack.clear();
      },
    );
  }

  void undo() {
    if (history.isEmpty) return;
    final lastAction = history.last;
    history.removeLast();

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
    redoStack.add(lastAction);
  }

  void redo() {
    if (redoStack.isEmpty) return;
    final nextAction = redoStack.last;
    redoStack.removeLast();

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
    history.add(nextAction);
  }
}