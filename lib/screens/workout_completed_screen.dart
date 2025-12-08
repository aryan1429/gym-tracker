import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_button.dart';
import '../widgets/glass_container.dart';
import '../widgets/custom_card.dart';
import 'main_scaffold.dart';

class WorkoutCompletedScreen extends StatelessWidget {
  final String duration;
  final String workoutName;

  const WorkoutCompletedScreen({
    super.key,
    required this.duration,
    required this.workoutName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Celebration Background Effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    Colors.transparent,
                  ],
                  radius: 1.5,
                  center: Alignment.center,
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 2000.ms),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Icon(Icons.emoji_events_rounded, size: 80, color: AppColors.warning)
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.elasticOut)
                      .then()
                      .shimmer(duration: 1200.ms),
                  const SizedBox(height: 24),
                  Text(
                    'WORKOUT\nCOMPLETED!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.primary,
                      height: 1.1,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 40),
                  
                  // Stats Grid
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('Duration', duration, Icons.timer)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatCard('Calories', '450', Icons.local_fire_department)),
                    ],
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 16),
                  _buildStatCard('Workout Type', workoutName, Icons.fitness_center)
                      .animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 40),
                  
                  // Photo Upload
                  GlassContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(Icons.camera_alt_rounded, size: 40, color: AppColors.textPrimary),
                        const SizedBox(height: 16),
                        Text(
                          'Upload Gym Photo',
                          style: AppTextStyles.headlineLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Attendance counts only after photo upload',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                  
                  const Spacer(),
                  
                  NeonButton(
                    text: 'FINISH',
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScaffold()),
                        (route) => false,
                      );
                    },
                    animate: true,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineLarge,
          ),
          Text(
            label,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
