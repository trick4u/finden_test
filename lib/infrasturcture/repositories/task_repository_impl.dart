


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';


import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/todo_task.dart';
import '../../domain/failure/failure.dart';
import '../../domain/repositories/task_repository.dart';
import '../../main.dart';
import '../dtos/todo_task_dto.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore firestore;
  final Box<TodoTaskDto> taskBox;

  TaskRepositoryImpl()
      : firestore = FirebaseFirestore.instance,
        taskBox = Hive.box<TodoTaskDto>('tasks');

  Future<void> _scheduleNotification(TodoTask task) async {
    if (task.dueDate.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id.hashCode,
        'Task Due: ${task.title}',
        'Due on ${task.dueDate.toString()}',
        tz.TZDateTime.from(task.dueDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_channel',
            'Task Reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

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
      final tasks = taskBox.values.map((dto) => dto.toDomain()).toList();
      for (var task in tasks) {
        await _scheduleNotification(task);
      }
      return right(tasks);
    } catch (e) {
      if (taskBox.isNotEmpty) return right(taskBox.values.map((dto) => dto.toDomain()).toList());
      return left(const Failure.serverError());
    }
  }

  @override
  Future<Either<Failure, Unit>> createTask(TodoTask task) async {
    try {
      final dto = TodoTaskDto.fromDomain(task);
      await taskBox.put(dto.id, dto);
      await firestore.collection('tasks').doc(dto.id).set(dto.toJson());
      await _scheduleNotification(task);
      return right(unit);
    } catch (e) {
      final dto = TodoTaskDto.fromDomain(task);
      await taskBox.put(dto.id, dto);
      await _scheduleNotification(task);
      return right(unit);
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTask(TodoTask task) async {
    try {
      final dto = TodoTaskDto.fromDomain(task);
      await taskBox.put(dto.id, dto);
      await firestore.collection('tasks').doc(dto.id).update(dto.toJson());
      await flutterLocalNotificationsPlugin.cancel(task.id.hashCode);
      await _scheduleNotification(task);
      return right(unit);
    } catch (e) {
      final dto = TodoTaskDto.fromDomain(task);
      await taskBox.put(dto.id, dto);
      await flutterLocalNotificationsPlugin.cancel(task.id.hashCode);
      await _scheduleNotification(task);
      return right(unit);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String id) async {
    try {
      await taskBox.delete(id);
      await firestore.collection('tasks').doc(id).delete();
      await flutterLocalNotificationsPlugin.cancel(id.hashCode);
      return right(unit);
    } catch (e) {
      await taskBox.delete(id);
      await flutterLocalNotificationsPlugin.cancel(id.hashCode);
      return right(unit);
    }
  }
}