import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class NeonButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.primary;
    
    Widget button = Container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(buttonColor.red, buttonColor.green, buttonColor.blue, 0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Text(
        text,
        style: AppTextStyles.labelLarge.copyWith(
          color: Colors.black,
        ),
      ),
    );

    if (animate) {
      button = button.animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 2000.ms, color: const Color.fromRGBO(255, 255, 255, 0.5))
          .then()
          .boxShadow(
            begin: const BoxShadow(color: Colors.transparent),
            end: BoxShadow(color: Color.fromRGBO(buttonColor.red, buttonColor.green, buttonColor.blue, 0.5), blurRadius: 30, spreadRadius: 5),
            duration: 1500.ms,
            curve: Curves.easeInOut,
          )
          .then()
          .boxShadow(
            begin: BoxShadow(color: Color.fromRGBO(buttonColor.red, buttonColor.green, buttonColor.blue, 0.5), blurRadius: 30, spreadRadius: 5),
            end: const BoxShadow(color: Colors.transparent),
            duration: 1500.ms,
            curve: Curves.easeInOut,
          );
    }

    return GestureDetector(
      onTap: onPressed,
      child: button,
    );
  }
}
