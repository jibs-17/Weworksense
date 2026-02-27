class UserProfile {
  final String name;
  final String email;
  final int streakDays;
  final DateTime? lastCompletionDate;

  UserProfile({
    required this.name,
    required this.email,
    this.streakDays = 0,
    this.lastCompletionDate,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    int? streakDays,
    DateTime? lastCompletionDate,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      streakDays: streakDays ?? this.streakDays,
      lastCompletionDate: lastCompletionDate ?? this.lastCompletionDate,
    );
  }
}
