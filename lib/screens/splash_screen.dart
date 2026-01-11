import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'main_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
        vsync: this, duration: const Duration(seconds: 10))
      ..repeat();
    _navigateToHome();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 4)); // Slightly longer for effect
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (_, __, ___) => const MainScaffold(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Particle Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ParticlePainter(_particleController.value),
                );
              },
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
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
                )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 2.seconds, curve: Curves.easeInOut)
                .then()
                .animate() // Rotate continuously
                .rotate(duration: 10.seconds, curve: Curves.linear),

                const SizedBox(height: 40),
                
                // App Name
                Text(
                  'GYM TRACKER',
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontSize: 24, 
                    letterSpacing: 4,
                    color: Colors.white.withOpacity(0.9)
                  ),
                ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0)
                 .then().shimmer(duration: 2.seconds, delay: 1.seconds),

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
                       ).animate().fadeIn(delay: 1.2.seconds)
                        .boxShadow(
                          end: BoxShadow(
                            color: AppColors.primary.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ).shimmer(delay: 2.seconds, duration: 1.seconds),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double animationValue;
  final List<_Particle> particles = List.generate(50, (index) => _Particle());

  _ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      final progress = (particle.speed * animationValue + particle.initialOffset) % 1.0;
      final dy = size.height * (1 - progress);
      final dx = size.width * particle.xRatio + (50 * (progress - 0.5) * (parcelIsEven(particle) ? 1 : -1)); // Slight wave

      final opacity = (1 - (progress - 0.5).abs() * 2) * particle.maxOpacity;
      
      paint.color = AppColors.primary.withOpacity(opacity);
      canvas.drawCircle(Offset(dx, dy), particle.size, paint);
    }
  }

  bool parcelIsEven(_Particle p) => p.hashCode % 2 == 0;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Particle {
  // Random values for natural look
  final double xRatio = (DateTime.now().microsecondsSinceEpoch % 1000) / 1000.0;
  final double initialOffset = (DateTime.now().microsecondsSinceEpoch % 1000) / 1000.0;
  final double speed = 0.2 + ((DateTime.now().microsecondsSinceEpoch % 500) / 1000.0);
  final double size = 2.0 + ((DateTime.now().microsecondsSinceEpoch % 400) / 100.0);
  final double maxOpacity = 0.1 + ((DateTime.now().microsecondsSinceEpoch % 400) / 1000.0);
}
