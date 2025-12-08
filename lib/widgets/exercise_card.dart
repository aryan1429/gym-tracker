import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

class ExerciseCard extends StatelessWidget {
  final String exerciseName;
  final String setsReps;
  final String notes;
  final String imageUrl; // Placeholder for now

  const ExerciseCard({
    super.key,
    required this.exerciseName,
    required this.setsReps,
    required this.notes,
    this.imageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: double.infinity,
      opacity: 0.05,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(Icons.fitness_center, size: 64, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              exerciseName,
              style: AppTextStyles.displayMedium.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              setsReps,
              style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      notes,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
