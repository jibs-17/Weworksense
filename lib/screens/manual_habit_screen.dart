import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/habit.dart';
import '../providers/app_provider.dart';

class ManualHabitScreen extends StatefulWidget {
  const ManualHabitScreen({super.key});

  @override
  State<ManualHabitScreen> createState() => _ManualHabitScreenState();
}

class _ManualHabitScreenState extends State<ManualHabitScreen> {
  final _nameController = TextEditingController();
  HabitPriority _selectedPriority = HabitPriority.medium;
  final List<Habit> _pendingHabits = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addHabit() {
    if (_nameController.text.trim().isEmpty) return;
    setState(() {
      _pendingHabits.add(
        Habit(name: _nameController.text.trim(), priority: _selectedPriority),
      );
      _nameController.clear();
      _selectedPriority = HabitPriority.medium;
    });
  }

  void _removeHabit(int index) {
    setState(() => _pendingHabits.removeAt(index));
  }

  Future<void> _saveAndProceed() async {
    if (_pendingHabits.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Add at least one habit'),
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
    await provider.addHabits(_pendingHabits);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Habits'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input area
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppTheme.cardRadius,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a New Habit',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _nameController,
                    decoration: AppTheme.inputDecoration(
                      'Habit name',
                      icon: Icons.check_circle_outline,
                    ),
                    onSubmitted: (_) => _addHabit(),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Priority',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: HabitPriority.values.map((p) {
                      final selected = p == _selectedPriority;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedPriority = p),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? _priorityColor(p).withValues(alpha: 0.15)
                                  : const Color(0xFFF0F4F8),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selected
                                    ? _priorityColor(p)
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _priorityLabel(p),
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? _priorityColor(p)
                                      : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: AppTheme.primaryButton.copyWith(
                        minimumSize: const WidgetStatePropertyAll(
                          Size(double.infinity, 44),
                        ),
                      ),
                      onPressed: _addHabit,
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Add Habit'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Habit list
            if (_pendingHabits.isNotEmpty)
              Text(
                'Your Habits (${_pendingHabits.length})',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: _pendingHabits.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.playlist_add,
                            size: 56,
                            color: AppTheme.textSecondary.withValues(
                              alpha: 0.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No habits yet.\nAdd your first habit above!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _pendingHabits.length,
                      itemBuilder: (ctx, i) {
                        final habit = _pendingHabits[i];
                        return Container(
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      habit.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      _priorityLabel(habit.priority),
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: _priorityColor(habit.priority),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                color: AppTheme.textSecondary,
                                onPressed: () => _removeHabit(i),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Continue Button
            if (_pendingHabits.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: AppTheme.primaryButton,
                    onPressed: _saveAndProceed,
                    child: const Text('Continue →'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
