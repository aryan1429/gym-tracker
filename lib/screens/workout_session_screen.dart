import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/exercise_card.dart';
import '../widgets/neon_button.dart';
import 'workout_completed_screen.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final String workoutName;

  const WorkoutSessionScreen({
    super.key,
    required this.workoutName,
  });

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _glowController;
  int _secondsElapsed = 0;
  int _currentExerciseIndex = 0;
  final PageController _pageController = PageController();

  // Mock Data
  final List<Map<String, String>> _exercises = [
    {
      'name': 'Deadlifts',
      'sets': '4 Sets x 5-8 Reps',
      'notes': 'Focus on form. Keep back straight.',
    },
    {
      'name': 'Pull Ups',
      'sets': '3 Sets x Failure',
      'notes': 'Full ROM. Chin over bar.',
    },
    {
      'name': 'Barbell Rows',
      'sets': '3 Sets x 8-12 Reps',
      'notes': 'Squeeze at the top.',
    },
    {
      'name': 'Face Pulls',
      'sets': '3 Sets x 15-20 Reps',
      'notes': 'Focus on rear delts.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  String get _formattedTime {
    final minutes = (_secondsElapsed / 60).floor().toString().padLeft(2, '0');
    final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    _glowController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _completeExercise() {
    if (_currentExerciseIndex < _exercises.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentExerciseIndex++;
      });
    } else {
      _finishWorkout();
    }
  }

  void _finishWorkout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutCompletedScreen(
          duration: _formattedTime,
          workoutName: widget.workoutName,
        ),
      ),
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Exit Workout?',
            style: AppTextStyles.headlineLarge,
          ),
          content: Text(
            'Are you sure you want to exit? Your progress will be lost.',
            style: AppTextStyles.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Exit workout screen
              },
              child: Text(
                'Exit',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: _showExitConfirmationDialog,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    _formattedTime,
                    style: AppTextStyles.displayMedium.copyWith(
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(
                    widget.workoutName.toUpperCase(),
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),

            // Progress Bar
            LinearProgressIndicator(
              value: (_currentExerciseIndex + 1) / _exercises.length,
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),

            // Exercise Cards
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _exercises.length,
                itemBuilder: (context, index) {
                  final exercise = _exercises[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ExerciseCard(
                      exerciseName: exercise['name']!,
                      setsReps: exercise['sets']!,
                      notes: exercise['notes']!,
                    ).animate().fadeIn().slideX(begin: 0.2, end: 0),
                  );
                },
              ),
            ),

            // Complete Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2 + 0.4 * _glowController.value),
                          blurRadius: 8 + 10 * _glowController.value,
                          spreadRadius: 1 + 2 * _glowController.value,
                        ),
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1 + 0.2 * _glowController.value),
                          blurRadius: 20 + 20 * _glowController.value,
                          spreadRadius: 5 + 10 * _glowController.value,
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
                child: NeonButton(
                  text: _currentExerciseIndex == _exercises.length - 1
                      ? 'FINISH WORKOUT'
                      : 'COMPLETE EXERCISE',
                  onPressed: _completeExercise,
                  animate: true,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
