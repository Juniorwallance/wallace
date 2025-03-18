// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Define a data model (e.g., for "Tasks")
class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;

  Task(
      {this.id,
      required this.title,
      required this.description,
      this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0, // Store boolean as integer
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tasks.db'); // Change database name

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    try {
      return await db.insert('tasks', task.toMap());
    } catch (e) {
      print('Error inserting task: $e');
      return -1;
    }
  }

  Future<List<Task>> fetchTasks() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('tasks');
      return List.generate(maps.length, (i) {
        return Task.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    try {
      return await db
          .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    } catch (e) {
      print('Error updating task: $e');
      return -1;
    }
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    try {
      return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting task: $e');
      return -1;
    }
  }

  Future<int> toggleTaskCompletion(int id, bool isCompleted) async {
    final db = await database;
    try {
      return await db.update('tasks', {'isCompleted': isCompleted ? 1 : 0},
          where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error toggling task completion: $e');
      return -1;
    }
  }
}
