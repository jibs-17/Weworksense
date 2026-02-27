import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/challenge.dart';
import '../providers/app_provider.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  IconData _challengeIcon(IconType type) {
    switch (type) {
      case IconType.fitness:
        return Icons.fitness_center_rounded;
      case IconType.detox:
        return Icons.spa_rounded;
      case IconType.discipline:
        return Icons.psychology_rounded;
      case IconType.learning:
        return Icons.menu_book_rounded;
      case IconType.wellness:
        return Icons.favorite_rounded;
    }
  }

  Color _challengeColor(IconType type) {
    switch (type) {
      case IconType.fitness:
        return AppTheme.highPriority;
      case IconType.detox:
        return AppTheme.success;
      case IconType.discipline:
        return AppTheme.primary;
      case IconType.learning:
        return AppTheme.accentOrange;
      case IconType.wellness:
        return const Color(0xFF9F7AEA);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final activeChallenge = provider.activeChallenge;

    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Active Challenge Progress
          if (activeChallenge != null) ...[
            _ActiveChallengeCard(
              challenge: activeChallenge,
              icon: _challengeIcon(activeChallenge.icon),
              color: _challengeColor(activeChallenge.icon),
            ),
            const SizedBox(height: 24),
          ],

          Text(
            'Available Challenges',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          ...defaultChallenges.map((challenge) {
            final isActive = activeChallenge?.title == challenge.title;
            return _ChallengeCard(
              challenge: challenge,
              icon: _challengeIcon(challenge.icon),
              color: _challengeColor(challenge.icon),
              isActive: isActive,
              onStart: () {
                if (!isActive) {
                  provider.startChallenge(challenge);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('🔥 ${challenge.title} started!'),
                      backgroundColor: _challengeColor(challenge.icon),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
            );
          }),
        ],
      ),
    );
  }
}

class _ActiveChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final IconData icon;
  final Color color;

  const _ActiveChallengeCard({
    required this.challenge,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppTheme.cardRadius,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  challenge.title,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Level ${challenge.level}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: challenge.progress,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              color: Colors.white,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${challenge.currentDay} / ${challenge.durationDays} days completed',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatefulWidget {
  final Challenge challenge;
  final IconData icon;
  final Color color;
  final bool isActive;
  final VoidCallback onStart;

  const _ChallengeCard({
    required this.challenge,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.onStart,
  });

  @override
  State<_ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<_ChallengeCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) => setState(() => _hovered = false),
      onTapCancel: () => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.cardRadius,
            boxShadow: AppTheme.cardShadow,
            border: widget.isActive
                ? Border.all(color: widget.color, width: 2)
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.challenge.title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.challenge.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isActive
                        ? Colors.grey[300]
                        : widget.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    elevation: 0,
                  ),
                  onPressed: widget.isActive ? null : widget.onStart,
                  child: Text(
                    widget.isActive ? 'Active' : 'Start',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
