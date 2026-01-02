import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : (_isHovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: GlassContainer(
            borderRadius: BorderRadius.circular(20),
            opacity: _isHovered ? 0.08 : 0.05,
            border: Border.all(
              color: _isHovered 
                  ? AppColors.primary.withOpacity(0.5) 
                  : AppColors.glassBorder,
              width: _isHovered ? 1.5 : 1.0,
            ),
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(16),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
