


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dartz/dartz.dart';



import '../../domain/entities/todo_task.dart';
import '../../domain/failure/failure.dart';
import '../../domain/repositories/task_repository.dart';
import '../dtos/todo_task_dto.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore firestore;

  TaskRepositoryImpl() : firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<TodoTask>>> getTasks() async {
    try {
      final snapshot = await firestore.collection('tasks').get();
      final tasks = snapshot.docs.map((doc) => TodoTaskDto.fromJson(doc.data()).toDomain()).toList();
      return right(tasks);
    } catch (e) {
      return left(const Failure.serverError());
    }
  }

  @override
  Future<Either<Failure, Unit>> createTask(TodoTask task) async {
    try {
      final dto = TodoTaskDto.fromDomain(task);
      await firestore.collection('tasks').doc(dto.id).set(dto.toJson());
      return right(unit);
    } catch (e) {
      return left(const Failure.serverError());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTask(TodoTask task) async {
    try {
      final dto = TodoTaskDto.fromDomain(task);
      await firestore.collection('tasks').doc(dto.id).update(dto.toJson());
      return right(unit);
    } catch (e) {
      return left(const Failure.serverError());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String id) async {
    try {
      await firestore.collection('tasks').doc(id).delete();
      return right(unit);
    } catch (e) {
      return left(const Failure.serverError());
    }
  }
}