import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

class WorkoutPlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final IconData icon;
  final bool isSuggested;
  final VoidCallback onTap;
  final int index;

  const WorkoutPlanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.icon,
    this.isSuggested = false,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSuggested ? AppColors.neonShadow(AppColors.primary) : [],
        ),
        child: GlassContainer(
          borderRadius: BorderRadius.circular(24),
          opacity: 0.06,
          blur: 20,
          gradientBorder: isSuggested
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.6),
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.0),
                    AppColors.primary.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.3, 0.7, 1.0],
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Hero(
                  tag: 'workout-icon-$title',
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: isSuggested
                          ? const LinearGradient(
                              colors: [AppColors.primary, Color(0xFF00CFA5)])
                          : LinearGradient(
                              colors: [
                                AppColors.surfaceLight,
                                AppColors.surfaceLight.withOpacity(0.8)
                              ],
                            ),
                      shape: BoxShape.circle,
                      boxShadow: isSuggested
                          ? [
                              BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2)
                            ]
                          : null,
                    ),
                    child: Icon(
                      icon,
                      color: isSuggested ? Colors.black : AppColors.textPrimary,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.headlineLarge.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        duration,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }
}
