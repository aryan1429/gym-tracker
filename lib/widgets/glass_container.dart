import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart' as glass;
import '../theme/app_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final BoxBorder? border;
  final Gradient? gradientBorder;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.blur = 15,
    this.opacity = 0.08,
    this.border,
    this.gradientBorder,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    // If a gradient border is provided, we wrap the glass container
    // in a Container with the gradient border.
    if (gradientBorder != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(24),
          gradient: gradientBorder,
        ),
        padding: const EdgeInsets.all(1.5), // Border width
        child: _buildInnerGlass(),
      );
    }

    return _buildInnerGlass();
  }

  Widget _buildInnerGlass() {
    return glass.GlassContainer(
      width: width,
      height: height,
      blur: blur,
      color: Colors.white.withOpacity(opacity),
      gradient: gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(opacity + 0.05),
              Colors.white.withOpacity(opacity),
            ],
          ),
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      border: border ??
          (gradientBorder == null
              ? Border.all(color: AppColors.glassBorder.withOpacity(0.1))
              : null), // Hide default border if gradient border is used
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
