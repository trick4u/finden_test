// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
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
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore firestore;
  final Box<TodoTaskDto> taskBox;
  final String userId;

TaskRepositoryImpl()
      : firestore = FirebaseFirestore.instance,
        taskBox = Hive.box<TodoTaskDto>('tasks'),
        userId = FirebaseAuth.instance.currentUser!.uid {
    if (userId == null) throw Exception('User not authenticated');
  }
Future<void> _scheduleNotification(TodoTask task) async {
  tz.initializeTimeZones();
  final tz.Location localTimeZone = tz.getLocation('Asia/Kolkata');
  final scheduledTime = tz.TZDateTime.from(task.dueDate, localTimeZone);

  print("🕒 Corrected scheduled time: $scheduledTime (Current time: ${tz.TZDateTime.now(localTimeZone)})");

  if (await _needsExactAlarmPermission()) {
    print("⚠️ Need to request exact alarm permission before scheduling.");
    _requestExactAlarmPermission(); // Only open settings if needed
    return; // Stop execution here until the user grants permission
  }

  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id.hashCode,
      'Task Reminder',
      'Don\'t forget: ${task.title}!',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_v2',
          'Task Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
    print("✅ Notification scheduled successfully!");
  } catch (e) {
    print("❌ Failed to schedule notification: $e");
  }
}

Future<void> _requestExactAlarmPermission() async {
  if (Platform.isAndroid && await _needsExactAlarmPermission()) {
    print("⚠️ Exact alarm permission is missing, opening settings...");
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  } else {
    print("✅ Exact alarm permission already granted, no need to open settings.");
  }
}

// 🔥 Check if we need exact alarm permission (only for Android 12+)
Future<bool> _needsExactAlarmPermission() async {
  if (Platform.isAndroid) {
    int sdkInt = int.parse(Platform.version.split('.')[0]);
    return sdkInt >= 31; // Android 12+ (API 31+) needs this permission
  }
  return false;
}
Future<void> _syncWithFirestore() async {
    try {
      final localTasks = taskBox.values.toList();
      final snapshot = await firestore.collection('users').doc(userId).collection('tasks').get();
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
          await firestore.collection('users').doc(userId).collection('tasks').doc(localTask.id).set(localTask.toJson());
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
      await firestore.collection('users').doc(userId).collection('tasks').doc(dto.id).set(dto.toJson());
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
      await firestore.collection('users').doc(userId).collection('tasks').doc(dto.id).update(dto.toJson());
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
      await firestore.collection('users').doc(userId).collection('tasks').doc(id).delete();
      await flutterLocalNotificationsPlugin.cancel(id.hashCode);
      return right(unit);
    } catch (e) {
      await taskBox.delete(id);
      await flutterLocalNotificationsPlugin.cancel(id.hashCode);
      return right(unit);
    }
  }
}