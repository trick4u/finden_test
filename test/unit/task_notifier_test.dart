

import 'package:dartz/dartz.dart';
import 'package:finden_test/application/task/task_notifier.dart';
import 'package:finden_test/domain/entities/todo_task.dart';
import 'package:finden_test/domain/repositories/task_repository.dart';
import 'package:finden_test/domain/value_objects/priority.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTaskRepository extends Mock implements TaskRepository {}
void main() {
  // test('TaskNotifier creates task', () async {
  //   final mockRepo = MockTaskRepository();
  //   final task = TodoTask(
  //     id: '1',
  //     title: 'Test',
  //     description: '',
  //     dueDate: DateTime.now(),
  //     priority: Priority.medium,
  //     isCompleted: false,
  //   );
  //   when(mockRepo.createTask(any)).thenAnswer((_) async => right(unit));
  //   final notifier = TaskNotifier(mockRepo);
  //   await notifier.createTask(task);
  //   expect(notifier.state.value!.length, 1);
  //   expect(notifier.state.value!.first, task);
  // });
}