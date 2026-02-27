enum HabitPriority { high, medium, low }

class Habit {
  final int? id;
  final String name;
  final HabitPriority priority;
  final bool isCompleted;
  final DateTime createdAt;

  Habit({
    this.id,
    required this.name,
    this.priority = HabitPriority.medium,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Habit copyWith({
    int? id,
    String? name,
    HabitPriority? priority,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'priority': priority.index,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int?,
      name: map['name'] as String,
      priority: HabitPriority.values[map['priority'] as int],
      isCompleted: (map['isCompleted'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
