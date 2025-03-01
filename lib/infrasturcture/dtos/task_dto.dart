import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:finden_test/domain/entities/task.dart';
import 'package:finden_test/domain/value_objects/priority.dart';

part 'task_dto.freezed.dart';
part 'task_dto.g.dart'; // Add this for json_serializable

@HiveType(typeId: 0)
@freezed
class TaskDto with _$TaskDto {
  @JsonSerializable(explicitToJson: true)
  const factory TaskDto({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required String description,
    @HiveField(3) required DateTime dueDate,
    @HiveField(4) required String priority,
    @HiveField(5) required bool isCompleted,
  }) = _TaskDto;

  factory TaskDto.fromJson(Map<String, dynamic> json) => _$TaskDtoFromJson(json);

  factory TaskDto.fromDomain(Task task) => TaskDto(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority.name,
        isCompleted: task.isCompleted,
      );
}

extension TaskDtoX on TaskDto {
  Task toDomain() => Task(
        id: id,
        title: title,
        description: description,
        dueDate: dueDate,
        priority: Priority.values.firstWhere((e) => e.name == priority),
        isCompleted: isCompleted,
      );
}