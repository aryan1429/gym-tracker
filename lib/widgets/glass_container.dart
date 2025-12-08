import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import '../theme/app_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.blur = 10,
    this.opacity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer.frostedGlass(
      width: width,
      height: height,
      padding: padding,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      blur: blur,
      color: Colors.white.withOpacity(opacity),
      borderColor: AppColors.glassBorder,
      child: child,
    );
  }
}
