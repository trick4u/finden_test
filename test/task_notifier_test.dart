import 'package:finden_test/domain/entities/todo_task.dart';
import 'package:finden_test/domain/failure/failure.dart';
import 'package:finden_test/domain/repositories/auth_repository.dart';
import 'package:finden_test/domain/repositories/task_repository.dart';
import 'package:finden_test/domain/value_objects/priority.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';


import 'task_notifier_test.mocks.dart';


@GenerateNiceMocks([MockSpec<AuthRepository>(), MockSpec<TaskRepository>()])
void main() {
  test('sample test', () {
    expect(1 + 1, 2);
  });

  group('AuthRepository Tests', () {
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    test('signInWithEmail returns right(unit) on success', () async {
      // Arrange
      when(mockAuthRepository.signInWithEmail('test@example.com', 'password'))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await mockAuthRepository.signInWithEmail(
          'test@example.com', 'password');

      // Assert
      expect(result, equals(const Right<Failure, Unit>(unit)));
      verify(mockAuthRepository.signInWithEmail('test@example.com', 'password'))
          .called(1);
    });

    test('signInWithEmail returns left(Failure) on error', () async {
      // Arrange
      when(mockAuthRepository.signInWithEmail('test@example.com', 'password'))
          .thenAnswer((_) async => const Left(Failure.authError()));

      // Act
      final result = await mockAuthRepository.signInWithEmail(
          'test@example.com', 'password');

      // Assert
      expect(result, equals(const Left<Failure, Unit>(Failure.authError())));
      verify(mockAuthRepository.signInWithEmail('test@example.com', 'password'))
          .called(1);
    });

    test('signUpWithEmail returns right(unit) on success', () async {
      // Arrange
      when(mockAuthRepository.signUpWithEmail('new@example.com', 'password'))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await mockAuthRepository.signUpWithEmail(
          'new@example.com', 'password');

      // Assert
      expect(result, equals(const Right<Failure, Unit>(unit)));
      verify(mockAuthRepository.signUpWithEmail('new@example.com', 'password'))
          .called(1);
    });

    test('signUpWithEmail returns left(Failure) on error', () async {
      // Arrange
      when(mockAuthRepository.signUpWithEmail('new@example.com', 'password'))
          .thenAnswer((_) async => const Left(Failure.serverError()));

      // Act
      final result = await mockAuthRepository.signUpWithEmail(
          'new@example.com', 'password');

      // Assert
      expect(result, equals(const Left<Failure, Unit>(Failure.serverError())));
      verify(mockAuthRepository.signUpWithEmail('new@example.com', 'password'))
          .called(1);
    });

    test('signOut calls repository method', () async {
      // Arrange
      when(mockAuthRepository.signOut()).thenAnswer((_) async => {});

      // Act
      await mockAuthRepository.signOut();

      // Assert
      verify(mockAuthRepository.signOut()).called(1);
    });

    test('getCurrentUserId returns user ID when logged in', () {
      // Arrange
      when(mockAuthRepository.getCurrentUserId()).thenReturn('user123');

      // Act
      final result = mockAuthRepository.getCurrentUserId();

      // Assert
      expect(result, equals('user123'));
      verify(mockAuthRepository.getCurrentUserId()).called(1);
    });

    test('getCurrentUserId returns null when not logged in', () {
      // Arrange
      when(mockAuthRepository.getCurrentUserId()).thenReturn(null);

      // Act
      final result = mockAuthRepository.getCurrentUserId();

      // Assert
      expect(result, isNull);
      verify(mockAuthRepository.getCurrentUserId()).called(1);
    });
  });

  group('TaskRepository Tests', () {
    late MockTaskRepository mockTaskRepository;
    late TodoTask sampleTask;
    late List<TodoTask> sampleTasks;

    setUp(() {
      mockTaskRepository = MockTaskRepository();
      
      sampleTask = TodoTask(
        id: 'task1',
        title: 'Test Task',
        description: 'Test Description',
        dueDate: DateTime(2025, 3, 15),
        priority: Priority.high,
        isCompleted: false,
      );
      
      sampleTasks = [
        sampleTask,
        TodoTask(
          id: 'task2',
          title: 'Another Task',
          description: 'Another Description',
          dueDate: DateTime(2025, 3, 20),
          priority: Priority.medium,
          isCompleted: true,
        ),
      ];
    });

    test('getTasks returns list of tasks on success', () async {
      // Arrange
      when(mockTaskRepository.getTasks())
          .thenAnswer((_) async => Right(sampleTasks));

      // Act
      final result = await mockTaskRepository.getTasks();

      // Assert
      expect(result, equals(Right<Failure, List<TodoTask>>(sampleTasks)));
      verify(mockTaskRepository.getTasks()).called(1);
    });

    test('getTasks returns failure on error', () async {
      // Arrange
      when(mockTaskRepository.getTasks())
          .thenAnswer((_) async => const Left(Failure.serverError()));

      // Act
      final result = await mockTaskRepository.getTasks();

      // Assert
      expect(result, equals(const Left<Failure, List<TodoTask>>(Failure.serverError())));
      verify(mockTaskRepository.getTasks()).called(1);
    });

    test('createTask returns right(unit) on success', () async {
      // Arrange
      when(mockTaskRepository.createTask(sampleTask))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await mockTaskRepository.createTask(sampleTask);

      // Assert
      expect(result, equals(const Right<Failure, Unit>(unit)));
      verify(mockTaskRepository.createTask(sampleTask)).called(1);
    });

    test('createTask returns left(Failure) on error', () async {
      // Arrange
      when(mockTaskRepository.createTask(sampleTask))
          .thenAnswer((_) async => const Left(Failure.serverError()));

      // Act
      final result = await mockTaskRepository.createTask(sampleTask);

      // Assert
      expect(result, equals(const Left<Failure, Unit>(Failure.serverError())));
      verify(mockTaskRepository.createTask(sampleTask)).called(1);
    });

    test('updateTask returns right(unit) on success', () async {
      // Arrange
      final updatedTask = TodoTask(
        id: 'task1',
        title: 'Updated Task',
        description: 'Updated Description',
        dueDate: DateTime(2025, 3, 15),
        priority: Priority.low,
        isCompleted: true,
      );
      
      when(mockTaskRepository.updateTask(updatedTask))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await mockTaskRepository.updateTask(updatedTask);

      // Assert
      expect(result, equals(const Right<Failure, Unit>(unit)));
      verify(mockTaskRepository.updateTask(updatedTask)).called(1);
    });

    test('updateTask returns left(Failure) on error', () async {
      // Arrange
      when(mockTaskRepository.updateTask(sampleTask))
          .thenAnswer((_) async => const Left(Failure.syncConflict()));

      // Act
      final result = await mockTaskRepository.updateTask(sampleTask);

      // Assert
      expect(result, equals(const Left<Failure, Unit>(Failure.syncConflict())));
      verify(mockTaskRepository.updateTask(sampleTask)).called(1);
    });

    test('deleteTask returns right(unit) on success', () async {
      // Arrange
      when(mockTaskRepository.deleteTask('task1'))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await mockTaskRepository.deleteTask('task1');

      // Assert
      expect(result, equals(const Right<Failure, Unit>(unit)));
      verify(mockTaskRepository.deleteTask('task1')).called(1);
    });

    test('deleteTask returns left(Failure) on error', () async {
      // Arrange
      when(mockTaskRepository.deleteTask('task1'))
          .thenAnswer((_) async => const Left(Failure.cacheError()));

      // Act
      final result = await mockTaskRepository.deleteTask('task1');

      // Assert
      expect(result, equals(const Left<Failure, Unit>(Failure.cacheError())));
      verify(mockTaskRepository.deleteTask('task1')).called(1);
    });
  });
}