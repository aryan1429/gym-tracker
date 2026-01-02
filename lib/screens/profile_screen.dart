import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/custom_card.dart';
import '../widgets/main_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 32),
            _buildStatsRow(),
            const SizedBox(height: 32),
            _buildAchievementsSection(),
            const SizedBox(height: 32),
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/300'), // Placeholder
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.black, size: 20),
            ),
          ],
        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
        const SizedBox(height: 16),
        Text(
          'Alex Johnson',
          style: AppTextStyles.headlineLarge.copyWith(fontSize: 28),
        ).animate().fadeIn().slideY(begin: 0.5, end: 0),
        const SizedBox(height: 4),
        Text(
          'Pro Member',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Weight', '75', 'kg', 0)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Height', '180', 'cm', 1)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Age', '24', 'yo', 2)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String unit, int index) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.headlineLarge.copyWith(fontSize: 24),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (300 + (index * 100)).ms).slideX();
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Recent Achievements',
            style: AppTextStyles.headlineLarge.copyWith(fontSize: 20),
          ),
        ).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildAchievementItem('7 Day Streak', Icons.local_fire_department, Colors.orange, 0),
              const SizedBox(width: 16),
              _buildAchievementItem('Early Bird', Icons.wb_sunny, Colors.amber, 1),
              const SizedBox(width: 16),
              _buildAchievementItem('Heavy Lifter', Icons.fitness_center, Colors.blue, 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(String label, IconData icon, Color color, int index) {
    return GlassContainer(
      width: 140,
      height: 160,
      opacity: 0.05,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (700 + (index * 100)).ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Settings',
            style: AppTextStyles.headlineLarge.copyWith(fontSize: 20),
          ),
        ).animate().fadeIn(delay: 900.ms),
        const SizedBox(height: 16),
        GlassContainer(
          borderRadius: BorderRadius.circular(24),
          opacity: 0.03,
          child: Column(
            children: [
              _buildSettingItem('Account', Icons.person_outline),
              const Divider(height: 1, color: Colors.white10),
              _buildSettingItem('Notifications', Icons.notifications_none),
              const Divider(height: 1, color: Colors.white10),
              _buildSettingItem('Workout Settings', Icons.settings_outlined),
              const Divider(height: 1, color: Colors.white10),
              _buildSettingItem('Privacy Policy', Icons.lock_outline),
            ],
          ),
        ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.1, end: 0),
      ],
    );
  }

  Widget _buildSettingItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}
