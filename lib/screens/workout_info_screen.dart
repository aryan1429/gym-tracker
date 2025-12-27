import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/neon_button.dart';
import '../data/exercise_data.dart';
import 'workout_session_screen.dart';

class WorkoutInfoScreen extends StatelessWidget {
  final String workoutName;

  const WorkoutInfoScreen({
    super.key,
    required this.workoutName,
  });

  // Data from shared source
  List<Map<String, String>> get _exercises => ExerciseData.getExercises(workoutName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          workoutName,
          style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                'Exercises Overview',
                style: AppTextStyles.displayMedium.copyWith(fontSize: 24),
              ).animate().fadeIn().slideX(),
              const SizedBox(height: 4),
              Text(
                '${_exercises.length} exercises in this workout',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              ).animate().fadeIn(delay: 100.ms).slideX(),
              const SizedBox(height: 16),
              
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = _exercises[index];
                    return _ExerciseInfoCard(
                      name: exercise['name']!,
                      imageUrl: exercise['image']!,
                      target: exercise['target']!,
                      index: index,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Start Workout Button
              SizedBox(
                child: NeonButton(
                  text: 'START WORKOUT',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutSessionScreen(workoutName: workoutName),
                      ),
                    );
                  },
                  color: AppColors.primary,
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseInfoCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String target;
  final int index;

  const _ExerciseInfoCard({
    required this.name,
    required this.imageUrl,
    required this.target,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      opacity: 0.08,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Exercise GIF/Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: 40,
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Demo',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Exercise Name
            Text(
              name,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            
            // Target Muscle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                target,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).scale(begin: const Offset(0.8, 0.8));
  }
}
