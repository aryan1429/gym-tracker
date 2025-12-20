import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/workout_plan_card.dart';
import 'workout_session_screen.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  void _navigateToSession(BuildContext context, String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutSessionScreen(workoutName: workoutName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Workouts',
                style: AppTextStyles.displayMedium,
              ).animate().fadeIn().slideX(),
              const SizedBox(height: 8),
              Text(
                'Explore & Manage Plans',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              ).animate().fadeIn(delay: 200.ms).slideX(),
              const SizedBox(height: 32),
              
              Expanded(
                child: ListView(
                  clipBehavior: Clip.none,
                  children: [
                    WorkoutPlanCard(
                      title: 'Pull Day',
                      subtitle: 'Back, Biceps & Rear Delts',
                      duration: '60 min',
                      icon: Icons.fitness_center,
                      isSuggested: false,
                      index: 0,
                      onTap: () => _navigateToSession(context, 'Pull Day'),
                    ),
                    WorkoutPlanCard(
                      title: 'Push Day',
                      subtitle: 'Chest, Shoulders & Triceps',
                      duration: '55 min',
                      icon: Icons.accessibility_new_rounded,
                      isSuggested: false, // In library view, we don't necessarily highlight one
                      index: 1,
                      onTap: () => _navigateToSession(context, 'Push Day'),
                    ),
                    WorkoutPlanCard(
                      title: 'Legs (Quads)',
                      subtitle: 'Quads, Calves & Abs',
                      duration: '70 min',
                      icon: Icons.directions_run_rounded,
                      isSuggested: false,
                      index: 2,
                      onTap: () => _navigateToSession(context, 'Legs (Quads)'),
                    ),
                    WorkoutPlanCard(
                      title: 'Legs (Hams)',
                      subtitle: 'Hamstrings, Glutes & Abs',
                      duration: '65 min',
                      icon: Icons.directions_walk_rounded,
                      isSuggested: false,
                      index: 3,
                      onTap: () => _navigateToSession(context, 'Legs (Hams)'),
                    ),
                     WorkoutPlanCard(
                      title: 'Full Body',
                      subtitle: 'Compound Movements',
                      duration: '90 min',
                      icon: Icons.bolt_rounded,
                      isSuggested: false,
                      index: 4,
                      onTap: () => _navigateToSession(context, 'Full Body'),
                    ),
                    const SizedBox(height: 100), // Spacing for bottom nav
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
