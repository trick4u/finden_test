// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_task_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoTaskDtoAdapter extends TypeAdapter<TodoTaskDto> {
  @override
  final int typeId = 0;

  @override
  TodoTaskDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoTaskDto(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      dueDate: fields[3] as DateTime,
      priority: fields[4] as String,
      isCompleted: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TodoTaskDto obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoTaskDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoTaskDtoImpl _$$TodoTaskDtoImplFromJson(Map<String, dynamic> json) =>
    _$TodoTaskDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: json['priority'] as String,
      isCompleted: json['isCompleted'] as bool,
    );

Map<String, dynamic> _$$TodoTaskDtoImplToJson(_$TodoTaskDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate.toIso8601String(),
      'priority': instance.priority,
      'isCompleted': instance.isCompleted,
    };
