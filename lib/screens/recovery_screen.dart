import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/recovery_provider.dart';
import '../models/recovery_models.dart';
import '../widgets/main_background.dart';
import '../widgets/glass_container.dart';
import '../theme/app_theme.dart';

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildOverallStatus(context),
              const SizedBox(height: 24),
              _buildSuggestionCard(context),
              const SizedBox(height: 24),
              Expanded(
                child: _buildMuscleList(context),
              ),
              const SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.neonPink.withOpacity(0.3),
                    AppTheme.neonPurple.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.healing_rounded,
                color: AppTheme.neonPink,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'RECOVERY',
              style: AppTextStyles.displayLarge.copyWith(
                fontSize: 32,
                shadows: [
                  Shadow(
                    color: AppTheme.neonPink.withOpacity(0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.2, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 8),
        Text(
          'Track muscle recovery status',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildOverallStatus(BuildContext context) {
    return Consumer<RecoveryProvider>(
      builder: (context, provider, child) {
        final percentage = provider.overallRecoveryPercentage;
        final ready = provider.readyMuscles.length;
        final total = MuscleGroup.all.length;

        return GlassContainer(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Circular progress indicator
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: percentage / 100,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getColorForPercentage(percentage),
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Status text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Recovery',
                        style: AppTextStyles.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$ready of $total muscle groups ready',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 400.ms).scale(delay: 400.ms);
      },
    );
  }

  Widget _buildSuggestionCard(BuildContext context) {
    return Consumer<RecoveryProvider>(
      builder: (context, provider, child) {
        return GlassContainer(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.neonBlue.withOpacity(0.3),
                        AppTheme.neonPurple.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: Colors.amber,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    provider.getWorkoutSuggestion(),
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 600.ms);
      },
    );
  }

  Widget _buildMuscleList(BuildContext context) {
    return Consumer<RecoveryProvider>(
      builder: (context, provider, child) {
        final statuses = provider.allStatuses;

        return ListView.builder(
          itemCount: statuses.length,
          itemBuilder: (context, index) {
            final status = statuses[index];
            return _buildMuscleCard(context, status, provider)
                .animate(delay: (800 + index * 100).ms)
                .fadeIn()
                .slideX(begin: 0.2, end: 0);
          },
        );
      },
    );
  }

  Widget _buildMuscleCard(
    BuildContext context,
    RecoveryStatus status,
    RecoveryProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Muscle icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: status.level.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: status.level.color.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      status.muscleGroup.icon,
                      color: status.level.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Muscle info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              status.muscleGroup.name,
                              style: AppTextStyles.headlineLarge.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: status.level.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: status.level.color.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    status.level.icon,
                                    size: 12,
                                    color: status.level.color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    status.level.label,
                                    style: TextStyle(
                                      color: status.level.color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          status.daysSinceText,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Soreness slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Soreness Level',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${status.soreness}/5',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          color: status.level.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: status.level.color,
                      inactiveTrackColor: Colors.white.withOpacity(0.1),
                      thumbColor: status.level.color,
                      overlayColor: status.level.color.withOpacity(0.2),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: status.soreness.toDouble(),
                      min: 0,
                      max: 5,
                      divisions: 5,
                      onChanged: (value) {
                        provider.updateSoreness(
                          status.muscleGroup.id,
                          value.round(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForPercentage(int percentage) {
    if (percentage >= 80) return const Color(0xFF00FF88);
    if (percentage >= 60) return const Color(0xFF88FF00);
    if (percentage >= 40) return const Color(0xFFFFAA00);
    return const Color(0xFFFF3366);
  }
}
