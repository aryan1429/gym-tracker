import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final bool animate;

  const NeonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.animate = false,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppColors.primary;
    
    Widget button = AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              buttonColor,
              buttonColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: AppColors.neonShadow(buttonColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Text(
          widget.text,
          style: AppTextStyles.labelLarge.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );

    if (widget.animate) {
      button = button.animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 2000.ms, color: const Color.fromRGBO(255, 255, 255, 0.4))
          .then()
          .boxShadow(
            begin: BoxShadow(color: buttonColor.withOpacity(0.5), blurRadius: 20, spreadRadius: -5),
            end: BoxShadow(color: buttonColor.withOpacity(0.8), blurRadius: 30, spreadRadius: 5),
            duration: 1500.ms,
            curve: Curves.easeInOut,
          )
          .then()
          .boxShadow(
             begin: BoxShadow(color: buttonColor.withOpacity(0.8), blurRadius: 30, spreadRadius: 5),
             end: BoxShadow(color: buttonColor.withOpacity(0.5), blurRadius: 20, spreadRadius: -5),
            duration: 1500.ms,
            curve: Curves.easeInOut,
          );
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: button,
    );
  }
}
