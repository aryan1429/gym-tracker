import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'main_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const MainScaffold(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Deep black background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Logo / Icon
            // Logo / Icon
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                      'assets/images/gym_logo.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat())
             .rotate(duration: 2.seconds, curve: Curves.easeInOutCubic)
             .shimmer(duration: 1.5.seconds, color: Colors.white.withOpacity(0.5))
             .animate() // Separate chain for entrance/exit
             .scale(duration: 600.ms, curve: Curves.easeOutBack)
             .then(delay: 2000.ms)
             .fade(duration: 400.ms, begin: 1, end: 0),

            const SizedBox(height: 40),
            
            // App Name (Optional, but looks nice)
            Text(
              'GYM TRACKER',
              style: AppTextStyles.headlineLarge.copyWith(
                fontSize: 24, 
                letterSpacing: 4,
                color: Colors.white.withOpacity(0.9)
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),

            const Spacer(),
            
            // Signature
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                children: [
                   Text(
                    'Made by',
                     style: AppTextStyles.bodyMedium.copyWith(color: Colors.white38, fontSize: 12),
                   ).animate().fadeIn(delay: 1.seconds),
                   const SizedBox(height: 8),
                   Text(
                     'Handsome Aryan',
                     style: AppTextStyles.displayMedium.copyWith(
                       fontSize: 18, 
                       color: AppColors.primary,
                       fontWeight: FontWeight.bold,
                     ),
                   ).animate().fadeIn(delay: 1.2.seconds).shimmer(delay: 2.seconds, duration: 1.seconds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
