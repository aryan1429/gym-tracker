import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
          DateFormat('HH:mm').format(_currentTime),
          style: AppTextStyles.displayLarge.copyWith(
            fontSize: 80,
            height: 0.9,
            shadows: [
              Shadow(
                color: AppColors.primary.withOpacity(0.5),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WorkoutSelectionScreen()),
          );
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
              '12 Day Streak',
              style: AppTextStyles.headlineLarge,
            ),
          ],
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Last Workout',
                '1h 20m',
                Icons.timer_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Type',
                'Push Day',
                Icons.fitness_center_outlined,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return CustomCard(
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
}
