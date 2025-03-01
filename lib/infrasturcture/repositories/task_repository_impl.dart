


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';



import '../../domain/entities/todo_task.dart';
import '../../domain/failure/failure.dart';
import '../../domain/repositories/task_repository.dart';
import '../dtos/todo_task_dto.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore firestore;
  final Box<TodoTaskDto> taskBox;
  
  // never forget to add the constructor
  //never done anything like this before
  TaskRepositoryImpl() : firestore = FirebaseFirestore.instance, taskBox = Hive.box<TodoTaskDto>('tasks');

  Future<void> _syncWithFirestore() async {
    try {
      final localTasks = taskBox.values.toList();
      final snapshot = await firestore.collection('tasks').get();
      final remoteTasks = snapshot.docs.map((doc) => TodoTaskDto.fromJson(doc.data())).toList();

      for (var remoteTask in remoteTasks) {
        if (!taskBox.containsKey(remoteTask.id)) {
          await taskBox.put(remoteTask.id, remoteTask);
        } else {
          final localTask = taskBox.get(remoteTask.id);
          if (localTask!.dueDate != remoteTask.dueDate) {
            await taskBox.put(remoteTask.id, remoteTask);
          }
        }
      }

      for (var localTask in localTasks) {
        if (!remoteTasks.any((rt) => rt.id == localTask.id)) {
          await firestore.collection('tasks').doc(localTask.id).set(localTask.toJson());
        }
      }
    } catch (e) {}
  }

  @override
  Future<Either<Failure, List<TodoTask>>> getTasks() async {
    try {
      await _syncWithFirestore();
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
      await taskBox.put(dto.id, dto);
      await firestore.collection('tasks').doc(dto.id).set(dto.toJson());
      return right(unit);
    } catch (e) {
      final dto = TodoTaskDto.fromDomain(task);
        await taskBox.put(dto.id, dto);
      return left(const Failure.serverError());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTask(TodoTask task) async {
    try {
      final dto = TodoTaskDto.fromDomain(task);
      await taskBox.put(dto.id, dto);
      await firestore.collection('tasks').doc(dto.id).update(dto.toJson());
      return right(unit);
    } catch (e) {
      final dto = TodoTaskDto.fromDomain(task);
      await taskBox.put(dto.id, dto);
      return left(const Failure.serverError());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String id) async {
    try {
      await taskBox.delete(id);
      await firestore.collection('tasks').doc(id).delete();
      return right(unit);
    } catch (e) {
      await taskBox.delete(id);
      return left(const Failure.serverError());
    }
  }
}