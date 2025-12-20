import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/glass_container.dart';
import 'workout_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF121212),
                  Color(0xFF1E1E1E),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const Spacer(),
                  _buildStartButton(),
                  const Spacer(),
                  _buildStreakAndSummary(),
                  const SizedBox(height: 80), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('h:mm a').format(_currentTime),
          style: AppTextStyles.displayLarge.copyWith(
            fontSize: 80,
            height: 0.9,
            shadows: const [
              Shadow(
                color: Color.fromRGBO(0, 255, 136, 0.5),
                blurRadius: 20,
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: -0.2, end: 0),
        Text(
          DateFormat('EEEE, MMM d').format(_currentTime).toUpperCase(),
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 200.ms).slideX(),
      ],
    );
  }

  Widget _buildStartButton() {
    return Center(
      child: NeonButton(
        text: 'START WORKOUT',
        onPressed: () async {
          final success = await context.read<PhotoProvider>().capturePhoto();
          if (context.mounted) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Photo Saved! Selecting Workout...')
                      .animate()
                      .slideX(begin: -0.2, end: 0, duration: 400.ms, curve: Curves.easeOutCubic)
                      .fadeIn(),
                  backgroundColor: AppColors.primary.withOpacity(0.8),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            // Navigate regardless
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const WorkoutSelectionScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(position: animation.drive(tween), child: child);
                },
              ),
            );
          }
        },
        animate: true,
      ),
    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack);
  }

  Widget _buildStreakAndSummary() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.local_fire_department_rounded, color: AppColors.warning, size: 28),
            const SizedBox(width: 8),
            Text(
              '16 Day Streak',
              style: AppTextStyles.headlineLarge,
            ),
          ],
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Last Workout',
                value: '1h 20m',
                icon: Icons.timer_outlined,
                onTap: () => _showLastWorkoutDetails(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: 'Type',
                value: 'Push Day',
                icon: Icons.fitness_center_outlined,
                onTap: () => _showWorkoutTypeDetails(context),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.headlineLarge.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _showLastWorkoutDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GlassContainer(
        height: MediaQuery.of(context).size.height * 0.6,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                   const Icon(Icons.history_rounded, color: AppColors.primary, size: 32),
                   const SizedBox(width: 12),
                   Text(
                     'Last Workout',
                     style: AppTextStyles.headlineLarge,
                   ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Key Stats Row
              Row(
                children: [
                  Expanded(child: _buildDetailStat('Duration', '1h 20m', Icons.timer_rounded)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDetailStat('Calories', '450 kcal', Icons.local_fire_department_rounded)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDetailStat('Date', 'Yesterday', Icons.calendar_today_rounded)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDetailStat('Focus', 'Push Day', Icons.fitness_center_rounded)),
                ],
              ),
              
              const SizedBox(height: 32),
              Text(
                'Exercises Completed',
                style: AppTextStyles.headlineLarge.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildExerciseItem('Bench Press', '4 sets x 10 reps'),
                    _buildExerciseItem('Incline Dumbbell Press', '3 sets x 12 reps'),
                    _buildExerciseItem('Cable Flyes', '3 sets x 15 reps'),
                    _buildExerciseItem('Tricep Pushdowns', '4 sets x 12 reps'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(String name, String details) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.bodyLarge),
              Text(details, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  void _showWorkoutTypeDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GlassContainer(
        height: MediaQuery.of(context).size.height * 0.6,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                   Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.fitness_center_rounded, color: AppColors.primary, size: 32),
                   ),
                   const SizedBox(width: 16),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         'Push Day',
                         style: AppTextStyles.headlineLarge,
                       ),
                       Text(
                         'Chest, Shoulders & Triceps',
                         style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                       ),
                     ],
                   ),
                ],
              ),
              const SizedBox(height: 32),
              
              Text(
                'Focus Areas',
                style: AppTextStyles.headlineLarge.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDetailStat('Main Focus', 'Chest', Icons.accessibility_new_rounded)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDetailStat('Secondary', 'Triceps', Icons.offline_bolt_rounded)),
                ],
              ),
              
              const SizedBox(height: 32),
              Text(
                'Weekly Schedule',
                style: AppTextStyles.headlineLarge.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.03),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.05)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDayStatus('M', true, true),
                    _buildDayStatus('T', false, false),
                    _buildDayStatus('W', false, false),
                    _buildDayStatus('T', true, false),
                    _buildDayStatus('F', false, false),
                    _buildDayStatus('S', false, false),
                    _buildDayStatus('S', false, false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayStatus(String day, bool isPushDay, bool isCompleted) {
    return Column(
      children: [
        Text(
          day,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isPushDay ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isPushDay ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted 
                ? AppColors.primary 
                : isPushDay 
                    ? AppColors.primary.withOpacity(0.2) 
                    : Colors.transparent,
          ),
        ),
      ],
    );
  }
}
