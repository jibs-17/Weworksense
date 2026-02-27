import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ChoosePathScreen extends StatelessWidget {
  const ChoosePathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'Choose Your Path',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'How would you like to get started?',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // Manual Card
              _PathCard(
                icon: Icons.edit_note_rounded,
                title: 'Create Habits\nManually',
                subtitle: 'Define your own habits and priorities',
                gradient: const [AppTheme.primary, AppTheme.primaryLight],
                onTap: () => Navigator.pushNamed(context, '/manual-habits'),
              ),
              const SizedBox(height: 20),

              // Auto Card
              _PathCard(
                icon: Icons.auto_awesome_rounded,
                title: 'Generate Habits\nAutomatically',
                subtitle: 'Let AI suggest habits for your goals',
                gradient: const [AppTheme.accentOrange, Color(0xFFF6AD55)],
                onTap: () => Navigator.pushNamed(context, '/auto-habits'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PathCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _PathCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_PathCard> createState() => _PathCardState();
}

class _PathCardState extends State<_PathCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.cardRadius,
            boxShadow: AppTheme.cardShadow,
            border: Border.all(color: AppTheme.divider, width: 1),
          ),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: widget.gradient),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
