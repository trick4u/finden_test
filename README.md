# Task Management App

A Flutter-based task management app built with **Domain-Driven Design (DDD)** and **Riverpod** for state management, featuring online/offline support, user authentication.

# What it does

This app allows users to:
- Create, edit, and delete tasks with title, description, due date, priority, and completion status.
- Filter and sort tasks by priority, status, or due date.
- Persist tasks online with Firestore and offline with Hive, syncing gracefully.
- Authenticate via email/password with an auto-sign-in flow.
- Undo/redo task actions and toggle between dark/light themes.
- Search tasks with debouncing for a smooth experience.

## Architecture

The project follows **Domain-Driven Design (DDD)** with four layers, integrated with Riverpod for state management.

### Domain Layer
- **Entities**: `TodoTask` (`lib/domain/entities/todo_task.dart`) defines the task structure (`id`, `title`, `description`, `dueDate`, `priority`, `isCompleted`) using Freezed for immutability.
- **Value Objects**: `Priority` (`lib/domain/value_objects/priority.dart`) as an enum (`low`, `medium`, `high`).
- **Repository Interfaces**: `TaskRepository` (`lib/domain/repositories/task_repository.dart`) and `AuthRepository` (`lib/domain/repositories/auth_repository.dart`) define task and auth contracts.
- **Failures**: `Failure` (`lib/domain/failures/failure.dart`) handles errors (e.g., `serverError`, `authError`) with Freezed.

### Application Layer
- **State Management**: 
  - `TaskNotifier` (`lib/application/task/task_notifier.dart`) manages tasks with `AsyncValue<List<TodoTask>>`, supporting create/edit/delete/undo/redo.
  - `AuthNotifier` (`lib/application/auth/auth_notifier.dart`) manages auth state with `AuthState`.
- **Providers**: `lib/application/providers.dart` defines `taskNotifierProvider`, `authProvider`, `themeProvider`, and repository providers, scoped appropriately (persistent state, no `autoDispose`).

### Infrastructure Layer
- **Repositories**: 
  - `TaskRepositoryImpl` (`lib/infrastructure/repositories/task_repository_impl.dart`) uses Firestore (`users/$uid/tasks`) and Hive for online/offline task persistence, plus local notifications.
  - `AuthRepositoryImpl` (`lib/infrastructure/repositories/auth_repository_impl.dart`) handles Firebase Auth email/password login.
- **Data Sources**: Firestore (`cloud_firestore`), Hive (`hive_flutter`).
- **DTOs**: `TodoTaskDto` (`lib/infrastructure/dtos/todo_task_dto.dart`) maps tasks to Firestore/Hive.

### Presentation Layer
- **Pages**: 
  - `TaskListPage` (`lib/presentation/pages/task_list_page.dart`) lists tasks with filters, search, and responsive layout.
  - `TaskDetailPage` (`lib/presentation/pages/task_detail_page.dart`) edits tasks.
  - `LoginPage` (`lib/presentation/pages/login_page.dart`) handles authentication.
- **UI Kit**: `TaskCard` (`lib/presentation/ui_kit/task_card.dart`) for reusable task rendering.
- **Main**: `lib/main.dart` initializes Firebase, Hive, notifications, and routes based on auth state.

## Setup Instructions

1. Clone the Repository
   https://github.com/trick4u/finden_test.git
2. Switch from main branch to 2ndMarch2025Finden

## Run tests
1. flutter test test/filter_notifier_test.dart 
2. flutter test test/task_notifier_test.dart
3. flutter test integration_test/task_flow_test.dart
