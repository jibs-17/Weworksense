# 🔥 Weworksense — Habit Tracker

A beautiful, feature-rich Flutter app that helps users build sustainable habits through manual creation, AI-powered auto-planning, challenges, and streak tracking.

> Built for the AMD Hackathon 2026

-

## ✨ Features

> Feature > Description >
> 🔑 Auth System > Local login & sign-up with secure password storage >
> ✏️ Manual Habits > Create custom habits with High / Medium / Low priority >
> 🤖 Auto-Planning > Select goal categories and get a curated habit plan instantly >
> 🎯 Priority Reordering > Drag-to-reorder habits by importance with color-coded badges >
> 🔥 Streak Counter > Automatically tracks consecutive days of 100% completion >
> 🏆 Challenges > 7 / 21 / 30-day pre-built challenges with progress bars & leveling >
> 📊 Weekly Charts > Visual bar charts showing daily completion trends >
> 💾 Offline Persistence > SQLite + SharedPreferences — works fully offline >

-

## 📱 Screens

1. Login — Email & password authentication with animated branding
2. Sign Up — Create a new account
3. Choose Your Path — Manual vs. auto-generated habit creation
4. Manual Habits — Add habits with name + priority selector
5. Auto-Generate — Pick categories (Wellness, Fitness, Productivity, Learning)
6. Prioritize — Drag-to-reorder with numbered list & priority badges
7. Dashboard — Welcome greeting, streak fire widget, challenge progress, today's tasks, weekly chart
8. Streaks — Habit checklist with animated checkboxes, streak counter, progress chart
9. Challenges — Browse & start challenges, track active challenge progress

-

## 🏗️ Architecture

```
lib/
├── main.dart                    # App entry point & routing
├── theme/
│   └── app_theme.dart           # Colors, typography, button styles
├── models/
│   ├── habit.dart               # Habit model with priority enum
│   ├── challenge.dart           # Challenge model with progress tracking
│   └── user_profile.dart        # User profile model
├── services/
│   ├── database_service.dart    # SQLite CRUD operations
│   └── habit_generator.dart     # Auto-planning habit suggestions
├── providers/
│   └── app_provider.dart        # Central state management (ChangeNotifier)
└── screens/
    ├── login_screen.dart
    ├── signup_screen.dart
    ├── choose_path_screen.dart
    ├── manual_habit_screen.dart
    ├── auto_habit_screen.dart
    ├── prioritize_screen.dart
    ├── dashboard_screen.dart
    ├── streak_screen.dart
    ├── challenge_screen.dart
    └── main_shell.dart          # Bottom navigation shell
```

-

## 🛠️ Tech Stack

> Technology > Purpose >
>>->
> Flutter > Cross-platform UI framework >
> Provider > State management >
> sqflite > Local SQLite database >
> SharedPreferences > Lightweight key-value storage >
> fl_chart > Bar charts for weekly progress >
> Google Fonts > Poppins & Inter typography >

-



## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

-

<p align="center">
  Made with ❤️ using Flutter
</p>
