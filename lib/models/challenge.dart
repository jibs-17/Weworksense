class Challenge {
  final int? id;
  final String title;
  final String description;
  final int durationDays;
  final int currentDay;
  final bool isActive;
  final IconType icon;

  Challenge({
    this.id,
    required this.title,
    this.description = '',
    required this.durationDays,
    this.currentDay = 0,
    this.isActive = false,
    this.icon = IconType.fitness,
  });

  Challenge copyWith({
    int? id,
    String? title,
    String? description,
    int? durationDays,
    int? currentDay,
    bool? isActive,
    IconType? icon,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      durationDays: durationDays ?? this.durationDays,
      currentDay: currentDay ?? this.currentDay,
      isActive: isActive ?? this.isActive,
      icon: icon ?? this.icon,
    );
  }

  double get progress => durationDays > 0 ? currentDay / durationDays : 0;
  int get level => (currentDay / 7).floor() + 1;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationDays': durationDays,
      'currentDay': currentDay,
      'isActive': isActive ? 1 : 0,
      'icon': icon.index,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      durationDays: map['durationDays'] as int,
      currentDay: map['currentDay'] as int,
      isActive: (map['isActive'] as int) == 1,
      icon: IconType.values[map['icon'] as int],
    );
  }
}

enum IconType { fitness, detox, discipline, learning, wellness }

// Pre-built challenges
List<Challenge> defaultChallenges = [
  Challenge(
    title: '7-Day Detox Challenge',
    description: 'Reset your body and mind with a week-long detox',
    durationDays: 7,
    icon: IconType.detox,
  ),
  Challenge(
    title: '21-Day Discipline Reset',
    description: 'Build iron-clad discipline in 21 days',
    durationDays: 21,
    icon: IconType.discipline,
  ),
  Challenge(
    title: '30-Day Fitness Boost',
    description: 'Transform your fitness with daily workouts',
    durationDays: 30,
    icon: IconType.fitness,
  ),
];
