import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/habit.dart';
import '../models/challenge.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'habit_tracker.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE habits (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            priority INTEGER NOT NULL DEFAULT 1,
            isCompleted INTEGER NOT NULL DEFAULT 0,
            createdAt TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE challenges (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            durationDays INTEGER NOT NULL,
            currentDay INTEGER NOT NULL DEFAULT 0,
            isActive INTEGER NOT NULL DEFAULT 0,
            icon INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE weekly_progress (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dayOfWeek INTEGER NOT NULL,
            completedCount INTEGER NOT NULL DEFAULT 0,
            weekStart TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // ── Habits CRUD ──
  static Future<int> insertHabit(Habit habit) async {
    final db = await database;
    return db.insert('habits', habit.toMap()..remove('id'));
  }

  static Future<List<Habit>> getHabits() async {
    final db = await database;
    final maps = await db.query('habits', orderBy: 'priority ASC');
    return maps.map((m) => Habit.fromMap(m)).toList();
  }

  static Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  static Future<void> deleteHabit(int id) async {
    final db = await database;
    await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> resetDailyHabits() async {
    final db = await database;
    await db.update('habits', {'isCompleted': 0});
  }

  // ── Challenges CRUD ──
  static Future<int> insertChallenge(Challenge challenge) async {
    final db = await database;
    return db.insert('challenges', challenge.toMap()..remove('id'));
  }

  static Future<List<Challenge>> getChallenges() async {
    final db = await database;
    final maps = await db.query('challenges');
    return maps.map((m) => Challenge.fromMap(m)).toList();
  }

  static Future<void> updateChallenge(Challenge challenge) async {
    final db = await database;
    await db.update(
      'challenges',
      challenge.toMap(),
      where: 'id = ?',
      whereArgs: [challenge.id],
    );
  }

  // ── Weekly Progress ──
  static Future<void> saveWeeklyProgress(
    int dayOfWeek,
    int count,
    String weekStart,
  ) async {
    final db = await database;
    final existing = await db.query(
      'weekly_progress',
      where: 'dayOfWeek = ? AND weekStart = ?',
      whereArgs: [dayOfWeek, weekStart],
    );
    if (existing.isNotEmpty) {
      await db.update(
        'weekly_progress',
        {'completedCount': count},
        where: 'dayOfWeek = ? AND weekStart = ?',
        whereArgs: [dayOfWeek, weekStart],
      );
    } else {
      await db.insert('weekly_progress', {
        'dayOfWeek': dayOfWeek,
        'completedCount': count,
        'weekStart': weekStart,
      });
    }
  }

  static Future<List<Map<String, dynamic>>> getWeeklyProgress(
    String weekStart,
  ) async {
    final db = await database;
    return db.query(
      'weekly_progress',
      where: 'weekStart = ?',
      whereArgs: [weekStart],
      orderBy: 'dayOfWeek ASC',
    );
  }
}
