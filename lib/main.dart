import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/choose_path_screen.dart';
import 'screens/manual_habit_screen.dart';
import 'screens/auto_habit_screen.dart';
import 'screens/prioritize_screen.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = AppProvider();
  await provider.init();
  runApp(HabitTrackerApp(provider: provider));
}

class HabitTrackerApp extends StatelessWidget {
  final AppProvider provider;
  const HabitTrackerApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        title: 'Weworksense — Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        initialRoute: provider.isLoggedIn ? '/main' : '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/signup': (_) => const SignupScreen(),
          '/choose-path': (_) => const ChoosePathScreen(),
          '/manual-habits': (_) => const ManualHabitScreen(),
          '/auto-habits': (_) => const AutoHabitScreen(),
          '/prioritize': (_) => const PrioritizeScreen(),
          '/main': (_) => const MainShell(),
        },
      ),
    );
  }
}
