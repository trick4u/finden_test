// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_task_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TodoTaskDto _$TodoTaskDtoFromJson(Map<String, dynamic> json) {
  return _TodoTaskDto.fromJson(json);
}

/// @nodoc
mixin _$TodoTaskDto {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  String get description => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime get dueDate => throw _privateConstructorUsedError;
  @HiveField(4)
  String get priority => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Serializes this TodoTaskDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TodoTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodoTaskDtoCopyWith<TodoTaskDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoTaskDtoCopyWith<$Res> {
  factory $TodoTaskDtoCopyWith(
          TodoTaskDto value, $Res Function(TodoTaskDto) then) =
      _$TodoTaskDtoCopyWithImpl<$Res, TodoTaskDto>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String description,
      @HiveField(3) DateTime dueDate,
      @HiveField(4) String priority,
      @HiveField(5) bool isCompleted});
}

/// @nodoc
class _$TodoTaskDtoCopyWithImpl<$Res, $Val extends TodoTaskDto>
    implements $TodoTaskDtoCopyWith<$Res> {
  _$TodoTaskDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodoTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? dueDate = null,
    Object? priority = null,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodoTaskDtoImplCopyWith<$Res>
    implements $TodoTaskDtoCopyWith<$Res> {
  factory _$$TodoTaskDtoImplCopyWith(
          _$TodoTaskDtoImpl value, $Res Function(_$TodoTaskDtoImpl) then) =
      __$$TodoTaskDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String description,
      @HiveField(3) DateTime dueDate,
      @HiveField(4) String priority,
      @HiveField(5) bool isCompleted});
}

/// @nodoc
class __$$TodoTaskDtoImplCopyWithImpl<$Res>
    extends _$TodoTaskDtoCopyWithImpl<$Res, _$TodoTaskDtoImpl>
    implements _$$TodoTaskDtoImplCopyWith<$Res> {
  __$$TodoTaskDtoImplCopyWithImpl(
      _$TodoTaskDtoImpl _value, $Res Function(_$TodoTaskDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TodoTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? dueDate = null,
    Object? priority = null,
    Object? isCompleted = null,
  }) {
    return _then(_$TodoTaskDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$TodoTaskDtoImpl implements _TodoTaskDto {
  const _$TodoTaskDtoImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.description,
      @HiveField(3) required this.dueDate,
      @HiveField(4) required this.priority,
      @HiveField(5) required this.isCompleted});

  factory _$TodoTaskDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodoTaskDtoImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final String description;
  @override
  @HiveField(3)
  final DateTime dueDate;
  @override
  @HiveField(4)
  final String priority;
  @override
  @HiveField(5)
  final bool isCompleted;

  @override
  String toString() {
    return 'TodoTaskDto(id: $id, title: $title, description: $description, dueDate: $dueDate, priority: $priority, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodoTaskDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, description, dueDate, priority, isCompleted);

  /// Create a copy of TodoTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoTaskDtoImplCopyWith<_$TodoTaskDtoImpl> get copyWith =>
      __$$TodoTaskDtoImplCopyWithImpl<_$TodoTaskDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodoTaskDtoImplToJson(
      this,
    );
  }
}

abstract class _TodoTaskDto implements TodoTaskDto {
  const factory _TodoTaskDto(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(2) required final String description,
      @HiveField(3) required final DateTime dueDate,
      @HiveField(4) required final String priority,
      @HiveField(5) required final bool isCompleted}) = _$TodoTaskDtoImpl;

  factory _TodoTaskDto.fromJson(Map<String, dynamic> json) =
      _$TodoTaskDtoImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  String get description;
  @override
  @HiveField(3)
  DateTime get dueDate;
  @override
  @HiveField(4)
  String get priority;
  @override
  @HiveField(5)
  bool get isCompleted;

  /// Create a copy of TodoTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodoTaskDtoImplCopyWith<_$TodoTaskDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
