import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../models/challenge.dart';
import '../models/user_profile.dart';
import '../services/database_service.dart';

class AppProvider extends ChangeNotifier {
  // ── Auth state ──
  bool _isLoggedIn = false;
  UserProfile? _user;

  bool get isLoggedIn => _isLoggedIn;
  UserProfile? get user => _user;

  // ── Habits ──
  List<Habit> _habits = [];
  List<Habit> get habits => _habits;
  List<Habit> get todayHabits => _habits;
  int get completedToday => _habits.where((h) => h.isCompleted).length;

  // ── Challenges ──
  List<Challenge> _challenges = [];
  List<Challenge> get challenges => _challenges;
  Challenge? get activeChallenge {
    try {
      return _challenges.firstWhere((c) => c.isActive);
    } catch (_) {
      return null;
    }
  }

  // ── Streak ──
  int _streakDays = 0;
  int get streakDays => _streakDays;

  // ── Weekly progress ──
  List<double> _weeklyProgress = List.filled(7, 0);
  List<double> get weeklyProgress => _weeklyProgress;

  // ── Init ──
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _streakDays = prefs.getInt('streakDays') ?? 0;

    if (_isLoggedIn) {
      _user = UserProfile(
        name: prefs.getString('userName') ?? 'User',
        email: prefs.getString('userEmail') ?? '',
        streakDays: _streakDays,
      );
      await _loadHabits();
      await _loadChallenges();
      await _loadWeeklyProgress();
    }
    notifyListeners();
  }

  // ── Auth ──
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('userEmail');
    final savedPassword = prefs.getString('userPassword');

    if (savedEmail == email && savedPassword == password) {
      _isLoggedIn = true;
      prefs.setBool('isLoggedIn', true);
      _user = UserProfile(
        name: prefs.getString('userName') ?? 'User',
        email: email,
        streakDays: _streakDays,
      );
      await _loadHabits();
      await _loadChallenges();
      await _loadWeeklyProgress();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> signUp(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', name);
    prefs.setString('userEmail', email);
    prefs.setString('userPassword', password);
    prefs.setBool('isLoggedIn', true);
    prefs.setInt('streakDays', 0);

    _isLoggedIn = true;
    _user = UserProfile(name: name, email: email);
    _streakDays = 0;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    _user = null;
    _habits = [];
    _challenges = [];
    notifyListeners();
  }

  // ── Habits ──
  Future<void> _loadHabits() async {
    _habits = await DatabaseService.getHabits();
  }

  Future<void> addHabit(Habit habit) async {
    final id = await DatabaseService.insertHabit(habit);
    _habits.add(habit.copyWith(id: id));
    notifyListeners();
  }

  Future<void> addHabits(List<Habit> habits) async {
    for (final h in habits) {
      final id = await DatabaseService.insertHabit(h);
      _habits.add(h.copyWith(id: id));
    }
    notifyListeners();
  }

  Future<void> toggleHabit(int index) async {
    final habit = _habits[index];
    final updated = habit.copyWith(isCompleted: !habit.isCompleted);
    _habits[index] = updated;
    await DatabaseService.updateHabit(updated);
    await _checkStreak();
    await _updateWeeklyProgress();
    notifyListeners();
  }

  Future<void> removeHabit(int index) async {
    final habit = _habits[index];
    if (habit.id != null) {
      await DatabaseService.deleteHabit(habit.id!);
    }
    _habits.removeAt(index);
    notifyListeners();
  }

  void reorderHabits(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = _habits.removeAt(oldIndex);
    _habits.insert(newIndex, item);
    notifyListeners();
  }

  // ── Streak ──
  Future<void> _checkStreak() async {
    final allDone = _habits.isNotEmpty && _habits.every((h) => h.isCompleted);
    if (allDone) {
      _streakDays++;
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('streakDays', _streakDays);
      _user = _user?.copyWith(streakDays: _streakDays);
    }
  }

  // ── Challenges ──
  Future<void> _loadChallenges() async {
    _challenges = await DatabaseService.getChallenges();
  }

  Future<void> startChallenge(Challenge challenge) async {
    // Deactivate others
    for (var i = 0; i < _challenges.length; i++) {
      if (_challenges[i].isActive) {
        final deactivated = _challenges[i].copyWith(isActive: false);
        _challenges[i] = deactivated;
        await DatabaseService.updateChallenge(deactivated);
      }
    }

    final active = challenge.copyWith(isActive: true, currentDay: 0);
    final id = await DatabaseService.insertChallenge(active);
    _challenges.add(active.copyWith(id: id));
    notifyListeners();
  }

  Future<void> advanceChallengeDay() async {
    for (var i = 0; i < _challenges.length; i++) {
      if (_challenges[i].isActive) {
        final updated = _challenges[i].copyWith(
          currentDay: _challenges[i].currentDay + 1,
        );
        _challenges[i] = updated;
        await DatabaseService.updateChallenge(updated);
        if (updated.currentDay >= updated.durationDays) {
          _challenges[i] = updated.copyWith(isActive: false);
          await DatabaseService.updateChallenge(_challenges[i]);
        }
        break;
      }
    }
    notifyListeners();
  }

  // ── Weekly Progress ──
  Future<void> _loadWeeklyProgress() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartStr =
        '${weekStart.year}-${weekStart.month}-${weekStart.day}';
    final data = await DatabaseService.getWeeklyProgress(weekStartStr);

    _weeklyProgress = List.filled(7, 0);
    for (final row in data) {
      final day = row['dayOfWeek'] as int;
      if (day >= 0 && day < 7) {
        _weeklyProgress[day] = (row['completedCount'] as int).toDouble();
      }
    }
  }

  Future<void> _updateWeeklyProgress() async {
    final now = DateTime.now();
    final dayOfWeek = now.weekday - 1; // 0 = Monday
    final weekStart = now.subtract(Duration(days: dayOfWeek));
    final weekStartStr =
        '${weekStart.year}-${weekStart.month}-${weekStart.day}';
    final count = completedToday;

    _weeklyProgress[dayOfWeek] = count.toDouble();
    await DatabaseService.saveWeeklyProgress(dayOfWeek, count, weekStartStr);
    notifyListeners();
  }
}
