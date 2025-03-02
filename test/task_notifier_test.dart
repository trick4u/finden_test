import 'package:dartz/dartz.dart';
import 'package:finden_test/application/task/task_notifier.dart';
import 'package:finden_test/domain/entities/todo_task.dart';
import 'package:finden_test/domain/repositories/task_repository.dart';
import 'package:finden_test/domain/value_objects/priority.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'task_flow_test.dart';


void main() {
  late MockTaskRepository mockRepo;
  late TaskNotifier notifier;

  setUp(() {
    mockRepo = MockTaskRepository();
    notifier = TaskNotifier(mockRepo);
  });

  test('TaskNotifier creates task', () async {
    final task = TodoTask(
      id: '1',
      title: 'Test',
      description: '',
      dueDate: DateTime.now(),
      priority: Priority.medium,
      isCompleted: false,
    );
    when(mockRepo.createTask(task)).thenAnswer((_) async => right(unit));

    await notifier.createTask(task);

    expect(notifier.state.value!.length, 1);
    expect(notifier.state.value!.first, task);
    verify(mockRepo.createTask(task)).called(1);
  });
}