import '../models/habit.dart';

class HabitGenerator {
  static const Map<String, List<Map<String, dynamic>>> _categories = {
    'Wellness': [
      {'name': 'Meditate for 10 Minutes', 'priority': HabitPriority.high},
      {'name': 'Drink 8 Glasses of Water', 'priority': HabitPriority.high},
      {'name': 'Sleep by 10 PM', 'priority': HabitPriority.medium},
      {'name': 'Take a 15-Min Walk', 'priority': HabitPriority.medium},
      {'name': 'Practice Gratitude Journaling', 'priority': HabitPriority.low},
    ],
    'Fitness': [
      {'name': 'Workout for 30 Minutes', 'priority': HabitPriority.high},
      {'name': '10,000 Steps Daily', 'priority': HabitPriority.high},
      {'name': 'Stretch for 10 Minutes', 'priority': HabitPriority.medium},
      {'name': 'Eat a Healthy Meal', 'priority': HabitPriority.medium},
      {'name': 'No Junk Food Today', 'priority': HabitPriority.low},
    ],
    'Productivity': [
      {'name': 'Study for 1 Hour', 'priority': HabitPriority.high},
      {'name': 'Complete Top 3 Tasks', 'priority': HabitPriority.high},
      {'name': 'No Social Media for 2 Hours', 'priority': HabitPriority.medium},
      {'name': 'Plan Tomorrow\'s Schedule', 'priority': HabitPriority.medium},
      {'name': 'Learn Something New', 'priority': HabitPriority.low},
    ],
    'Learning': [
      {'name': 'Read a Book for 30 Minutes', 'priority': HabitPriority.high},
      {'name': 'Practice a New Skill', 'priority': HabitPriority.high},
      {'name': 'Watch an Educational Video', 'priority': HabitPriority.medium},
      {'name': 'Write 500 Words', 'priority': HabitPriority.medium},
      {'name': 'Review Notes / Flashcards', 'priority': HabitPriority.low},
    ],
  };

  static List<String> get categories => _categories.keys.toList();

  static List<Habit> generateForCategories(List<String> selectedCategories) {
    final habits = <Habit>[];
    for (final cat in selectedCategories) {
      final items = _categories[cat];
      if (items != null) {
        for (final item in items) {
          habits.add(
            Habit(
              name: item['name'] as String,
              priority: item['priority'] as HabitPriority,
            ),
          );
        }
      }
    }
    return habits;
  }

  static List<Habit> generateForCategory(String category) {
    return generateForCategories([category]);
  }
}
