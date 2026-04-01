import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 2, // Incremented version
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE tasks ADD COLUMN isUrgent INTEGER DEFAULT 0');
        }
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        dueDate TEXT,
        isCompleted INTEGER,
        repeat TEXT,
        isUrgent INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE subtasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskId INTEGER,
        title TEXT,
        isCompleted INTEGER,
        FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    Database db = await database;
    int id = await db.insert('tasks', task.toMap());
    for (var subTask in task.subTasks) {
      subTask.taskId = id;
      await db.insert('subtasks', subTask.toMap());
    }
    return id;
  }

  Future<List<Task>> getTasks() async {
    Database db = await database;
    List<Map<String, dynamic>> taskMaps = await db.query('tasks');
    List<Task> tasks = [];
    for (var map in taskMaps) {
      Task task = Task.fromMap(map);
      List<Map<String, dynamic>> subTaskMaps = await db.query(
        'subtasks',
        where: 'taskId = ?',
        whereArgs: [task.id],
      );
      task.subTasks = subTaskMaps.map((sm) => SubTask.fromMap(sm)).toList();
      tasks.add(task);
    }
    return tasks;
  }

  Future<int> updateTask(Task task) async {
    Database db = await database;
    await db.delete('subtasks', where: 'taskId = ?', whereArgs: [task.id]);
    for (var subTask in task.subTasks) {
      subTask.taskId = task.id!;
      await db.insert('subtasks', subTask.toMap());
    }
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    await db.delete('subtasks', where: 'taskId = ?', whereArgs: [id]);
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
