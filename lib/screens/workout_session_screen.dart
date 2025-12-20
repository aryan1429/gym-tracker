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

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> with TickerProviderStateMixin {
  late Timer _timer;
  Timer? _restTimer;
  int _restSecondsRemaining = 0;
  bool _isResting = false;
  
  late AnimationController _glowController;
  int _secondsElapsed = 0;
  int _currentExerciseIndex = 0;
  final PageController _pageController = PageController();

  // Data Source
  List<Map<String, String>> get _exercises {
    if (widget.workoutName == 'Pull Day') {
      return [
        {
          'name': 'Stretches (Lats & Back)',
          'sets': '2 Sets x 30s',
          'notes': 'Child\'s pose and separate lat stretches. Focus on deep breathing.',
        },
        {
          'name': 'Pull Ups (Warmup)',
          'sets': '2 Sets x 8-10 Reps',
          'notes': 'Full ROM. Chin over bar. Control the eccentric.',
        },
        {
          'name': 'Neutral Grip Lat Pulldown',
          'sets': '3 Sets x 10-8-8 Reps',
          'notes': 'Focus on driving elbows down.',
        },
        {
          'name': 'Barbell Rows',
          'sets': '3 Sets x 12-10-8 Reps',
          'notes': 'Hinge at hips. Keep back neutral. Squeeze at top.',
        },
        {
          'name': 'Single Arm Cable Rows',
          'sets': '2 Sets x 12-8 Reps',
          'notes': 'Full stretch at bottom. Rotation optional.',
        },
        {
          'name': 'Chest Supported T-Bar/Machine Rows',
          'sets': '2 Sets x 12-10 Reps',
          'notes': 'Keep chest glued to pad. Eliminate momentum.',
        },
        {
          'name': 'Lat Pullover',
          'sets': '3 Sets x 12-10-10 Reps',
          'notes': 'Use cable or dumbbell. Focus on the stretch.',
        },
        {
          'name': 'Incline DB Curls',
          'sets': '3 Sets x 12-Failure',
          'notes': 'Full stretch on biceps. Keep elbows back.',
        },
        {
          'name': 'Cable Hammer Curls',
          'sets': '3 Sets x 12 Reps',
          'notes': 'Rope attachment. Squeeze at peak.',
        },
        {
          'name': 'Kelso Shrugs',
          'sets': '3 Sets x 15-12-12 Reps',
          'notes': 'Shrug focusing on mid-traps/scapula retraction.',
        },
        {
          'name': 'Lower Back Extension',
          'sets': '2 Sets x 12-10 Reps',
          'notes': 'Controlled movement. Don\'t hyperextend.',
        },
        {
          'name': 'Bar Forearm Curl',
          'sets': '2 Sets x 15-20 Reps',
          'notes': 'Burnout the forearms.',
        },
        {
          'name': 'SUPERSET: Pronated + Reverse Curls',
          'sets': '2 Sets x 12 Reps + Failure',
          'notes': 'Perform Pronated Curls immediately followed by Reverse Curls.',
        },
      ];
    }
    
    // Fallback Mock Data for other days
    return [
      {
        'name': 'Exercise 1',
        'sets': '3 Sets',
        'notes': 'Placeholder for ${widget.workoutName}',
      },
    ];
  }

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
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  void _startRestTimer(int seconds) {
    _restTimer?.cancel();
    setState(() {
      _restSecondsRemaining = seconds;
      _isResting = true;
    });
    
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_restSecondsRemaining > 0) {
            _restSecondsRemaining--;
          } else {
            _isResting = false;
            timer.cancel(); // Changed 'ticker.cancel()' to 'timer.cancel()'
          }
        });
      }
    });
  }

  void _cancelRestTimer() {
    _restTimer?.cancel();
    setState(() {
      _isResting = false;
    });
  }

  void _showRestMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Start Rest Timer', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRestOption(30),
                _buildRestOption(60),
                _buildRestOption(90),
                _buildRestOption(120),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRestOption(int seconds) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _startRestTimer(seconds);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text('${seconds}s', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }

  String get _formattedTime {
    final minutes = (_secondsElapsed / 60).floor().toString().padLeft(2, '0');
    final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get _formattedRestTime {
    final minutes = (_restSecondsRemaining / 60).floor().toString().padLeft(2, '0');
    final seconds = (_restSecondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    _restTimer?.cancel();
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
      // Auto-suggest rest? Optional.
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
        actions: [
          IconButton(
            onPressed: _showRestMenu,
            icon: const Icon(Icons.timer_outlined, color: AppColors.primary),
            tooltip: 'Rest Timer',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
            
            // Rest Timer Overlay
            if (_isResting)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          'REST: $_formattedRestTime',
                          style: AppTextStyles.headlineLarge.copyWith(color: Colors.black),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _cancelRestTimer,
                          child: const Icon(Icons.close, color: Colors.black),
                        )
                      ],
                    ),
                  ).animate().scale(curve: Curves.easeOutBack),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
