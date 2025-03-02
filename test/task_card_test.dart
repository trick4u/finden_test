

import 'package:finden_test/domain/entities/todo_task.dart';
import 'package:finden_test/domain/value_objects/priority.dart';
import 'package:finden_test/presentation/ui/task_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// void main() {
//   testWidgets('TaskCard renders and toggles completion', (tester) async {
//     final task = TodoTask(
//       id: '1',
//       title: 'Test',
//       description: '',
//       dueDate: DateTime.now(),
//       priority: Priority.medium,
//       isCompleted: false,
//     );

//     await tester.pumpWidget(
//       ProviderScope(
//         child: MaterialApp(
//           home: Scaffold(body: TaskCard(task: task, onTap: () {})),
//         ),
//       ),
//     );

//     expect(find.text('Test'), findsOneWidget);
//     expect(find.byType(Checkbox), findsOneWidget);

//     await tester.tap(find.byType(Checkbox));
//     await tester.pump();
//     // Note: This test doesn't verify state change since TaskCard uses Riverpod internally
//     // For full verification, mock taskNotifierProvider if needed (see below)
//   });
// }