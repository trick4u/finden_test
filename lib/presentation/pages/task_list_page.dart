import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/todo_task.dart';
import '../../domain/value_objects/priority.dart';
import '../ui/task_card.dart';
import 'package:rxdart/rxdart.dart';

import 'task_detail_page.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  final TextEditingController _searchController = TextEditingController();
  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>();
  List<TodoTask> _filteredTasks = [];
  Priority? _filterPriority;
  bool? _filterCompleted;

  @override
  void initState() {
    super.initState();
    _searchSubject.debounceTime(const Duration(milliseconds: 300)).listen((query) {
      _updateFilteredTasks(query: query);
    });
    _searchController.addListener(() => _searchSubject.add(_searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchSubject.close();
    super.dispose();
  }

  void _updateFilteredTasks({String? query, List<TodoTask>? tasks}) {
    final taskState = ref.read(taskNotifierProvider);
    taskState.when(
      loading: () => _filteredTasks = [],
      error: (_, __) => _filteredTasks = [],
      data: (allTasks) {
        _filteredTasks = tasks ?? allTasks;
        if (query != null && query.isNotEmpty) {
          _filteredTasks = _filteredTasks
              .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
        if (_filterPriority != null) {
          _filteredTasks = _filteredTasks.where((task) => task.priority == _filterPriority).toList();
        }
        if (_filterCompleted != null) {
          _filteredTasks = _filteredTasks.where((task) => task.isCompleted == _filterCompleted).toList();
        }
        _filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        setState(() {});
      },
    );
  }

  Future<void> _refreshTasks() async {
    await ref.read(taskNotifierProvider.notifier).loadTasks();
    _updateFilteredTasks(); 
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskNotifierProvider);
    final taskNotifier = ref.read(taskNotifierProvider.notifier);
    final themeMode = ref.watch(themeProvider);

    // Update filtered tasks when taskState changes
    taskState.whenData((tasks) => _updateFilteredTasks(tasks: tasks));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: taskNotifier.history.isEmpty ? null : taskNotifier.undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: taskNotifier.redoStack.isEmpty ? null : taskNotifier.redo,
          ),
          IconButton(
            icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).state =
                  themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: taskState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (tasks) => RefreshIndicator(
          onRefresh: _refreshTasks,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(labelText: 'Search Tasks', border: OutlineInputBorder()),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<Priority?>(
                    value: _filterPriority,
                    hint: const Text('Priority'),
                    items: [null, ...Priority.values]
                        .map((p) => DropdownMenuItem(value: p, child: Text(p?.name ?? 'All')))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _filterPriority = value;
                        _updateFilteredTasks();
                      });
                    },
                  ),
                  DropdownButton<bool?>(
                    value: _filterCompleted,
                    hint: const Text('Status'),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All')),
                      DropdownMenuItem(value: false, child: Text('Pending')),
                      DropdownMenuItem(value: true, child: Text('Completed')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filterCompleted = value;
                        _updateFilteredTasks();
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = _filteredTasks[index];
                    return TaskCard(
                      task: task,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailPage(task: task))),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskDetailPage()));
          _updateFilteredTasks(); // Refresh after adding task
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}