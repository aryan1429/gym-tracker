import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart' as glass;
import '../theme/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return glass.GlassContainer(
      height: 80,
      width: double.infinity,
      blur: 20,
      color: const Color.fromRGBO(255, 255, 255, 0.1),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      border: Border.all(color: Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_rounded, 'Home', 0),
          _buildNavItem(Icons.fitness_center_rounded, 'Workout', 1),
          _buildNavItem(Icons.calendar_month_rounded, 'Calendar', 2),
          _buildNavItem(Icons.photo_library_rounded, 'Photos', 3),
          _buildNavItem(Icons.person_rounded, 'Profile', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? const Color.fromRGBO(0, 255, 136, 0.2) : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      const BoxShadow(
                        color: Color.fromRGBO(0, 255, 136, 0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 10,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
