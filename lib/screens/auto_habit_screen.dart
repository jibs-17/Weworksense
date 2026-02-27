import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/habit.dart';
import '../providers/app_provider.dart';
import '../services/habit_generator.dart';

class AutoHabitScreen extends StatefulWidget {
  const AutoHabitScreen({super.key});

  @override
  State<AutoHabitScreen> createState() => _AutoHabitScreenState();
}

class _AutoHabitScreenState extends State<AutoHabitScreen> {
  final Set<String> _selectedCategories = {};
  List<Habit> _generatedHabits = [];
  bool _generated = false;

  static const _categoryIcons = {
    'Wellness': Icons.spa_rounded,
    'Fitness': Icons.fitness_center_rounded,
    'Productivity': Icons.rocket_launch_rounded,
    'Learning': Icons.menu_book_rounded,
  };

  static const _categoryColors = {
    'Wellness': Color(0xFF38A169),
    'Fitness': Color(0xFFE53E3E),
    'Productivity': Color(0xFF2B6CB0),
    'Learning': Color(0xFFED8936),
  };

  void _generate() {
    if (_selectedCategories.isEmpty) return;
    setState(() {
      _generatedHabits = HabitGenerator.generateForCategories(
        _selectedCategories.toList(),
      );
      _generated = true;
    });
  }

  void _toggleHabit(int index) {
    setState(() {
      final h = _generatedHabits[index];
      _generatedHabits[index] = h.copyWith(isCompleted: !h.isCompleted);
    });
  }

  Future<void> _saveAndProceed() async {
    // Save only selected (isCompleted == false means "kept", we use it as toggle)
    final kept = _generatedHabits
        .where((h) => !h.isCompleted)
        .map((h) => h.copyWith(isCompleted: false))
        .toList();
    if (kept.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Keep at least one habit'),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    final provider = context.read<AppProvider>();
    await provider.addHabits(kept);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/prioritize');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto-Generate Habits'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _generated ? _buildGeneratedList() : _buildCategoryPicker(),
      ),
    );
  }

  Widget _buildCategoryPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Goals',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pick one or more categories — we\'ll create a personalized habit plan!',
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 28),

        ...HabitGenerator.categories.map((cat) {
          final selected = _selectedCategories.contains(cat);
          final color = _categoryColors[cat] ?? AppTheme.primary;
          return GestureDetector(
            onTap: () {
              setState(() {
                if (selected) {
                  _selectedCategories.remove(cat);
                } else {
                  _selectedCategories.add(cat);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: selected ? color.withValues(alpha: 0.08) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? color : AppTheme.divider,
                  width: selected ? 2 : 1,
                ),
                boxShadow: selected ? [] : AppTheme.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_categoryIcons[cat], color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      cat,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: selected
                        ? Icon(
                            Icons.check_circle_rounded,
                            key: const ValueKey(true),
                            color: color,
                            size: 26,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            key: const ValueKey(false),
                            color: AppTheme.textSecondary.withValues(
                              alpha: 0.4,
                            ),
                            size: 26,
                          ),
                  ),
                ],
              ),
            ),
          );
        }),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: AppTheme.primaryButton,
            onPressed: _selectedCategories.isEmpty ? null : _generate,
            icon: const Icon(Icons.auto_awesome, size: 20),
            label: const Text('Generate Habits'),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildGeneratedList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Generated Plan',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap to remove habits you don\'t want',
          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _generatedHabits.length,
            itemBuilder: (ctx, i) {
              final habit = _generatedHabits[i];
              final removed = habit.isCompleted; // reusing field as "removed"
              return AnimatedOpacity(
                opacity: removed ? 0.4 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                      Container(
                        width: 8,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _priorityColor(habit.priority),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          habit.name,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            decoration: removed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          removed
                              ? Icons.undo_rounded
                              : Icons.remove_circle_outline,
                          size: 20,
                        ),
                        color: removed
                            ? AppTheme.success
                            : AppTheme.textSecondary,
                        onPressed: () => _toggleHabit(i),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: AppTheme.outlinedButton.copyWith(
                    minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                  ),
                  onPressed: () => setState(() {
                    _generated = false;
                    _generatedHabits = [];
                  }),
                  child: const Text('Re-pick'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: AppTheme.primaryButton,
                  onPressed: _saveAndProceed,
                  child: const Text('Continue →'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
