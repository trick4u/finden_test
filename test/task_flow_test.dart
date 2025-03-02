

import 'package:dartz/dartz.dart';
import 'package:finden_test/domain/entities/todo_task.dart';
import 'package:finden_test/domain/failure/failure.dart';
import 'package:finden_test/domain/repositories/task_repository.dart';
import 'package:finden_test/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

// void main() {
//   testWidgets('Create → Edit → Delete flow', (tester) async {
//     final mockRepo = MockTaskRepository();

//     // 🔥 FIX: Explicitly define return type
//     when(() => mockRepo.createTask(any()))
//         .thenAnswer((_) async => right<Failure, Unit>(unit));

//     final taskNotifier = MockTaskNotifier();

//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [taskNotifierProvider.overrideWith((ref) => taskNotifier)],
//         child: const MaterialApp(home: MyApp()),
//       ),
//     );
//     await tester.pumpAndSettle();
//   });
// }