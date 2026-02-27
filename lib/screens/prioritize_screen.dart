import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/habit.dart';
import '../providers/app_provider.dart';

class PrioritizeScreen extends StatefulWidget {
  const PrioritizeScreen({super.key});

  @override
  State<PrioritizeScreen> createState() => _PrioritizeScreenState();
}

class _PrioritizeScreenState extends State<PrioritizeScreen> {
  Color _priorityColor(HabitPriority p) {
    switch (p) {
      case HabitPriority.high:
        return AppTheme.highPriority;
      case HabitPriority.medium:
        return AppTheme.mediumPriority;
      case HabitPriority.low:
        return AppTheme.lowPriority;
    }
  }

  String _priorityLabel(HabitPriority p) {
    switch (p) {
      case HabitPriority.high:
        return 'High';
      case HabitPriority.medium:
        return 'Medium';
      case HabitPriority.low:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final habits = provider.habits;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your Priorities'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withValues(alpha: 0.08),
                    AppTheme.primaryLight.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.drag_indicator_rounded,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Drag to reorder your habits by priority',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: habits.length,
                onReorder: (oldIndex, newIndex) {
                  provider.reorderHabits(oldIndex, newIndex);
                },
                itemBuilder: (ctx, i) {
                  final habit = habits[i];
                  return Container(
                    key: ValueKey(habit.name + i.toString()),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Number
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            habit.name,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Priority badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _priorityColor(
                              habit.priority,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _priorityLabel(habit.priority),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _priorityColor(habit.priority),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.drag_handle_rounded,
                          color: AppTheme.textSecondary.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: AppTheme.primaryButton,
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/main'),
                child: const Text('Start My Journey →'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
