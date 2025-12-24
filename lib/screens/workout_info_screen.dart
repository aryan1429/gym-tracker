import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';

class WorkoutInfoScreen extends StatelessWidget {
  final String workoutName;

  const WorkoutInfoScreen({
    super.key,
    required this.workoutName,
  });

  // Exercise data with GIF URLs from JEFIT/similar resources
  List<Map<String, String>> get _exercises {
    if (workoutName == 'Pull Day') {
      return [
        {
          'name': 'Stretches (Lats & Back)',
          'image': 'https://media.tenor.com/images/e15f9c63b3cc61f0d95e2bbfe9e9e31a/tenor.gif',
          'target': 'Mobility',
        },
        {
          'name': 'Pull Ups',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Pull-up.gif',
          'target': 'Back, Biceps',
        },
        {
          'name': 'Neutral Grip Lat Pulldown',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Close-Grip-Lat-Pulldown.gif',
          'target': 'Lats',
        },
        {
          'name': 'Barbell Rows',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Bent-Over-Row.gif',
          'target': 'Back',
        },
        {
          'name': 'Single Arm Cable Rows',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/One-Arm-Cable-Row.gif',
          'target': 'Back',
        },
        {
          'name': 'Chest Supported T-Bar Rows',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Lever-T-bar-Row.gif',
          'target': 'Upper Back',
        },
        {
          'name': 'Lat Pullover',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Cable-Pullover.gif',
          'target': 'Lats',
        },
        {
          'name': 'Incline DB Curls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Incline-Dumbbell-Curl.gif',
          'target': 'Biceps',
        },
        {
          'name': 'Cable Hammer Curls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Cable-Hammer-Curl.gif',
          'target': 'Biceps, Forearms',
        },
        {
          'name': 'Kelso Shrugs',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Dumbbell-Shrug.gif',
          'target': 'Traps',
        },
        {
          'name': 'Lower Back Extension',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Back-Extension.gif',
          'target': 'Lower Back',
        },
        {
          'name': 'Forearm Curls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Wrist-Curl.gif',
          'target': 'Forearms',
        },
      ];
    } else if (workoutName == 'Push Day') {
      return [
        {
          'name': 'Joint Warmup',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/06/Arm-Circles.gif',
          'target': 'Mobility',
        },
        {
          'name': 'Pushups',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Push-Up.gif',
          'target': 'Chest, Triceps',
        },
        {
          'name': 'Smith Incline Bench Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Smith-Machine-Incline-Bench-Press.gif',
          'target': 'Upper Chest',
        },
        {
          'name': 'Cable Flys',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/09/Low-Cable-Fly.gif',
          'target': 'Chest',
        },
        {
          'name': 'Peck Deck Machine',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Pec-Deck-Fly.gif',
          'target': 'Chest',
        },
        {
          'name': 'Dips',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Triceps-Dip.gif',
          'target': 'Chest, Triceps',
        },
        {
          'name': 'Smith Shoulder Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Smith-Machine-Shoulder-Press.gif',
          'target': 'Shoulders',
        },
        {
          'name': 'Cable Lateral Raises',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Cable-Lateral-Raise.gif',
          'target': 'Side Delts',
        },
        {
          'name': 'Face Pulls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Face-Pull.gif',
          'target': 'Rear Delts',
        },
        {
          'name': 'Rope Pushdowns',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Pushdown.gif',
          'target': 'Triceps',
        },
        {
          'name': 'Dumbbell Overhead Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Dumbbell-Shoulder-Press.gif',
          'target': 'Shoulders',
        },
      ];
    } else if (workoutName == 'Legs (Hams)') {
      return [
        {
          'name': 'Stretches & Warmup',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/04/Hip-Circles.gif',
          'target': 'Mobility',
        },
        {
          'name': 'Leg Curls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Leg-Curl.gif',
          'target': 'Hamstrings',
        },
        {
          'name': 'Romanian Deadlifts',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Dumbbell-Romanian-Deadlift.gif',
          'target': 'Hamstrings, Glutes',
        },
        {
          'name': 'Lunges',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Dumbbell-Lunge.gif',
          'target': 'Legs',
        },
        {
          'name': 'Leg Extensions',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Leg-Extension.gif',
          'target': 'Quads',
        },
        {
          'name': 'Hip Abduction Machine',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Hip-Abduction-Machine.gif',
          'target': 'Glutes',
        },
        {
          'name': 'Calf Raises',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Calf-Raise.gif',
          'target': 'Calves',
        },
      ];
    } else if (workoutName == 'Legs (Quads)') {
      return [
        {
          'name': 'Stretches & Mobility',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/04/Hip-Circles.gif',
          'target': 'Mobility',
        },
        {
          'name': 'Barbell Squats',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Squat.gif',
          'target': 'Quads, Glutes',
        },
        {
          'name': 'Leg Extensions',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Leg-Extension.gif',
          'target': 'Quads',
        },
        {
          'name': 'Leg Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Leg-Press.gif',
          'target': 'Quads',
        },
        {
          'name': 'Leg Curls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Leg-Curl.gif',
          'target': 'Hamstrings',
        },
        {
          'name': 'Hip Abduction Machine',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Hip-Abduction-Machine.gif',
          'target': 'Glutes',
        },
        {
          'name': 'Calf Raises',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Calf-Raise.gif',
          'target': 'Calves',
        },
      ];
    } else if (workoutName == 'Full Body') {
      return [
        {
          'name': 'Warmup (Dynamic Stretches)',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/06/Arm-Circles.gif',
          'target': 'Mobility',
        },
        {
          'name': 'Deadlifts',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Deadlift.gif',
          'target': 'Full Body',
        },
        {
          'name': 'Bench Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Bench-Press.gif',
          'target': 'Chest',
        },
        {
          'name': 'Barbell Rows',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Bent-Over-Row.gif',
          'target': 'Back',
        },
        {
          'name': 'Overhead Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Shoulder-Press.gif',
          'target': 'Shoulders',
        },
        {
          'name': 'Squats',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Squat.gif',
          'target': 'Legs',
        },
        {
          'name': 'Pull Ups',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Pull-up.gif',
          'target': 'Back, Biceps',
        },
        {
          'name': 'Dips',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Triceps-Dip.gif',
          'target': 'Chest, Triceps',
        },
      ];
    }

    // Fallback
    return [
      {
        'name': 'Exercise',
        'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Push-Up.gif',
        'target': 'General',
      },
    ];
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
