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
          NavBarItem(
            icon: Icons.home_rounded,
            label: 'Home',
            index: 0,
            isSelected: currentIndex == 0,
            onTap: onTap,
          ),
          NavBarItem(
            icon: Icons.fitness_center_rounded,
            label: 'Workout',
            index: 1,
            isSelected: currentIndex == 1,
            onTap: onTap,
          ),
          NavBarItem(
            icon: Icons.calendar_month_rounded,
            label: 'Calendar',
            index: 2,
            isSelected: currentIndex == 2,
            onTap: onTap,
          ),
          NavBarItem(
            icon: Icons.healing_rounded,
            label: 'Recovery',
            index: 3,
            isSelected: currentIndex == 3,
            onTap: onTap,
          ),
          NavBarItem(
            icon: Icons.photo_library_rounded,
            label: 'Photos',
            index: 4,
            isSelected: currentIndex == 4,
            onTap: onTap,
          ),
          NavBarItem(
            icon: Icons.person_rounded,
            label: 'Profile',
            index: 5,
            isSelected: currentIndex == 5,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

// Animated Navigation Bar Item
class NavBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final Function(int) onTap;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rippleController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _glowAnimation;

  bool _isPressed = false;
  bool? _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Scale animation controller
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    // Ripple animation controller
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: Curves.easeOut,
      ),
    );

    // Glow pulse animation controller
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rippleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
    _rippleController.forward(from: 0.0);
    _glowController.forward(from: 0.0).then((_) => _glowController.reverse());
    widget.onTap(widget.index);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isHovering = _isHovered ?? false;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        behavior: HitTestBehavior.opaque,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ripple effect
                AnimatedBuilder(
                  animation: _rippleAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 50 * _rippleAnimation.value,
                      height: 50 * _rippleAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(
                          0.3 * (1 - _rippleAnimation.value),
                        ),
                      ),
                    );
                  },
                ),
                // Main content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: widget.isSelected
                                ? LinearGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.2),
                                      AppColors.primary.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: !widget.isSelected && isHovering
                                ? const Color.fromRGBO(0, 255, 136, 0.1)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            boxShadow: widget.isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color.fromRGBO(0, 255, 136, 0.6),
                                      blurRadius: 15 * _glowAnimation.value,
                                      spreadRadius: 2 * _glowAnimation.value,
                                    ),
                                    BoxShadow(
                                      color: const Color.fromRGBO(0, 255, 136, 0.3),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                    ),
                                  ]
                                : isHovering
                                    ? [
                                        const BoxShadow(
                                          color: Color.fromRGBO(0, 255, 136, 0.3),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        )
                                      ]
                                    : [],
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.isSelected
                                ? AppColors.primary
                                : isHovering
                                    ? AppColors.primary.withOpacity(0.7)
                                    : AppColors.textSecondary,
                            size: 24,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 10,
                        color: widget.isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            widget.isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
