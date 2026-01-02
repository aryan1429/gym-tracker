import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MainBackground extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool extendBody;

  const MainBackground({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.extendBody = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBody: extendBody,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent, // Important for gradient visibility if Scaffold has color
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          // Global Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF121212),
                  Color(0xFF1E1E1E),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),
          
          // Content
          SafeArea(
            bottom: !extendBody, // Don't verify safety for bottom if extending body (e.g. for nav bar)
            child: child,
          ),
        ],
      ),
    );
  }
}
