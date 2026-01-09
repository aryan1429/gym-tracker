import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/workout_plan_card.dart';
import '../widgets/main_background.dart';
import 'workout_session_screen.dart';

class WorkoutSelectionScreen extends StatelessWidget {
  const WorkoutSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE').format(DateTime.now());

    return MainBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Today\'s\nWorkout',
              style: AppTextStyles.displayMedium,
            ).animate().fadeIn().slideY(begin: -0.2, end: 0),
            const SizedBox(height: 8),
            Text(
              'It\'s $today. Ready to crush it?',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    WorkoutPlanCard(
                      title: 'Pull Day',
                      subtitle: 'Back, Biceps & Rear Delts',
                      duration: '60 min',
                      icon: Icons.fitness_center,
                      isSuggested: true,
                      index: 0,
                      onTap: () => _navigateToSession(context, 'Pull Day', Icons.fitness_center),
                    ),
                    WorkoutPlanCard(
                      title: 'Push Day',
                      subtitle: 'Chest, Shoulders & Triceps',
                      duration: '55 min',
                      icon: Icons.accessibility_new_rounded,
                      isSuggested: false,
                      index: 1,
                      onTap: () => _navigateToSession(context, 'Push Day', Icons.accessibility_new_rounded),
                    ),
                    WorkoutPlanCard(
                      title: 'Legs (Quads)',
                      subtitle: 'Quads, Calves & Abs',
                      duration: '70 min',
                      icon: Icons.directions_run_rounded,
                      isSuggested: false,
                      index: 2,
                      onTap: () => _navigateToSession(context, 'Legs (Quads)', Icons.directions_run_rounded),
                    ),
                    WorkoutPlanCard(
                      title: 'Legs (Hams)',
                      subtitle: 'Hamstrings, Glutes & Abs',
                      duration: '65 min',
                      icon: Icons.directions_walk_rounded,
                      isSuggested: false,
                      index: 3,
                      onTap: () => _navigateToSession(context, 'Legs (Hams)', Icons.directions_walk_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
     );
  }

  void _navigateToSession(BuildContext context, String workoutName, IconData icon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutSessionScreen(
          workoutName: workoutName,
          workoutIcon: icon,
        ),
      ),
    );
  }
}
