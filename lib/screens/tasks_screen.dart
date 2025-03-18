import 'package:flutter/material.dart';
import 'package:lipalocal/database/database_helper.dart' as db;
import 'package:lipalocal/database/task.dart' as t;

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final dbHelper = db.DatabaseHelper();
  late Future<List<t.Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture =
        dbHelper.fetchTasks() as Future<List<t.Task>>; // Removed the cast
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: FutureBuilder<List<t.Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? value) async {
                      if (value != null) {
                        await dbHelper.toggleTaskCompletion(task.id!, value);
                        setState(() {
                          _tasksFuture =
                              dbHelper.fetchTasks() as Future<List<t.Task>>;
                        });
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No tasks available.'));
          }
// Ensures a Widget is always returned.
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask =
              t.Task(title: 'New Task', description: 'Task description');
          await dbHelper.insertTask(newTask as db.Task);
          setState(() {
            _tasksFuture = dbHelper.fetchTasks() as Future<List<t.Task>>;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
