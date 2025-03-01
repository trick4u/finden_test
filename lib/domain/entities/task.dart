import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/priority.dart';


part 'task.freezed.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required Priority priority,
    required bool isCompleted,
  }) = _Task;
}