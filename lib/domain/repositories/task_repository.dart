
import 'package:dartz/dartz.dart';

import '../entities/todo_task.dart';
import '../failure/failure.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TodoTask>>> getTasks();
  Future<Either<Failure, Unit>> createTask(TodoTask task);
  Future<Either<Failure, Unit>> updateTask(TodoTask task);
  Future<Either<Failure, Unit>> deleteTask(String id);
}