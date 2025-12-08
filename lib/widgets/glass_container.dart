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
  final Border? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.blur = 10,
    this.opacity = 0.05,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return glass.GlassContainer(
      width: width,
      height: height,
      blur: blur,
      color: Color.fromRGBO(255, 255, 255, opacity),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: border ?? Border.all(color: AppColors.glassBorder),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
