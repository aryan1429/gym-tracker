import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/weather_provider.dart';
import '../widgets/glass_container.dart';
import '../theme/app_theme.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        if (weatherProvider.isLoading) {
          return _buildLoadingState();
        }

        if (weatherProvider.error != null) {
          return _buildErrorState(weatherProvider);
        }

        return _buildWeatherCard(context, weatherProvider);
      },
    );
  }

  Widget _buildLoadingState() {
    return GlassContainer(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Loading weather...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WeatherProvider weatherProvider) {
    return GlassContainer(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.orange.withOpacity(0.8),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                weatherProvider.error ?? 'Weather unavailable',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context, WeatherProvider weatherProvider) {
    return GlassContainer(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weather Info Row
            Row(
              children: [
                // Weather Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.neonBlue.withOpacity(0.3),
                        AppTheme.neonPurple.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.neonBlue.withOpacity(0.5),
                      width: 1,
                    ),
                    boxShadow: AppColors.neonShadow(AppTheme.neonBlue),
                  ),
                  child: Text(
                    weatherProvider.weatherEmoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 2000.ms,
                      color: AppTheme.neonBlue.withOpacity(0.3),
                    ),
                const SizedBox(width: 16),
                // Temperature and Condition
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weatherProvider.temperatureString,
                        style: AppTextStyles.displayMedium.copyWith(
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        weatherProvider.condition,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Refresh Button
                IconButton(
                  onPressed: () => weatherProvider.refresh(),
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: AppTheme.neonBlue,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.neonBlue.withOpacity(0.2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(
              color: Colors.white24,
              height: 1,
            ),
            const SizedBox(height: 12),
            // Workout Suggestion
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.neonPink.withOpacity(0.3),
                        AppTheme.neonPurple.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: Colors.amber,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Workout Tip',
                        style: TextStyle(
                          color: AppTheme.neonPink,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        weatherProvider.workoutSuggestion,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOutCubic);
  }
}
