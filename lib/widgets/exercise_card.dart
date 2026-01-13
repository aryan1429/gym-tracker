import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

class ExerciseCard extends StatefulWidget {
  final String exerciseName;
  final String setsReps;
  final String notes;
  final String imageUrl;

  const ExerciseCard({
    super.key,
    required this.exerciseName,
    required this.setsReps,
    required this.notes,
    this.imageUrl = '',
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  // Mock tracking data: List of sets (Weight, Reps, Completed)
  final List<Map<String, dynamic>> _sets = [
    {'weight': '0', 'reps': '0', 'done': false},
    {'weight': '0', 'reps': '0', 'done': false},
    {'weight': '0', 'reps': '0', 'done': false},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize sets based on "setsReps" string roughly (e.g. "4 Sets" -> 4 items) or just default to 3
    final setMatches = RegExp(r'(\d+)\s*Sets').firstMatch(widget.setsReps);
    if (setMatches != null) {
      final count = int.parse(setMatches.group(1)!);
      if (count > 3) {
         _sets.add({'weight': '0', 'reps': '0', 'done': false});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: double.infinity,
      opacity: 0.05,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise Image/GIF
              if (widget.imageUrl.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.black26,
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.white24),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                                : null,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Header
              Text(
                widget.exerciseName,
                style: AppTextStyles.displayMedium.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 8),
              Text(
                widget.setsReps,
                style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              
                  // Instructions & Previous Best
                  Row(
                    children: [
                       Expanded(
                        child: GlassContainer(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.warning.withOpacity(0.15),
                              AppColors.warning.withOpacity(0.05),
                            ],
                          ),
                          border: Border.all(color: AppColors.warning.withOpacity(0.2)),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('INSTRUCTIONS', style: TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                              const SizedBox(height: 4),
                              Text(
                                widget.notes,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.warning.withOpacity(0.9), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassContainer(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary.withOpacity(0.15),
                              AppColors.primary.withOpacity(0.05),
                            ],
                          ),
                          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                          padding: const EdgeInsets.all(12),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PREVIOUS BEST', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                              SizedBox(height: 4),
                              Text(
                                '100kg x 8', // Mock data
                                style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              const SizedBox(height: 16),
              
              // Personal Notes Input
              GlassContainer(
                borderRadius: BorderRadius.circular(16),
                opacity: 0.03,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Add personal notes (e.g. Widen Grip)',
                    hintStyle: TextStyle(color: Colors.white24),
                    filled: false,
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.edit_note, color: Colors.white54),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sets Tracker
              _buildSetHeaders(),
              const SizedBox(height: 8),
              ..._sets.asMap().entries.map((entry) => _buildSetRow(entry.key, entry.value)),
              
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => setState(() => _sets.add({'weight': '0', 'reps': '0', 'done': false})),
                  child: GlassContainer(
                    borderRadius: BorderRadius.circular(30),
                    opacity: 0.1,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'ADD SET',
                          style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetHeaders() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text('SET', style: TextStyle(color: Colors.white54, fontSize: 12))),
          SizedBox(width: 16),
          Expanded(child: Center(child: Text('KG', style: TextStyle(color: Colors.white54, fontSize: 12)))),
          SizedBox(width: 16),
          Expanded(child: Center(child: Text('REPS', style: TextStyle(color: Colors.white54, fontSize: 12)))),
          SizedBox(width: 16),
          SizedBox(width: 40, child: Center(child: Icon(Icons.check, size: 16, color: Colors.white54))),
        ],
      ),
    );
  }

  Widget _buildSetRow(int index, Map<String, dynamic> set) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          // Set Number
          Container(
            width: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(width: 16),
          
          // Weight Input
          Expanded(
            child: _buildInput(set['weight'], (val) => set['weight'] = val),
          ),
          const SizedBox(width: 16),
          
          // Reps Input
          Expanded(
            child: _buildInput(set['reps'], (val) => set['reps'] = val),
          ),
          const SizedBox(width: 16),
          
          // Checkbox
          GestureDetector(
            onTap: () {
              setState(() {
                set['done'] = !set['done'];
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: set['done'] ? AppColors.primary : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: set['done'] 
                ? const Icon(Icons.check, color: Colors.black, size: 24).animate().scale()
                : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String initialValue, Function(String) onChanged) {
    return GlassContainer(
      height: 45,
      opacity: 0.05,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 8), // Center text vertically
          hintText: '-',
          hintStyle: TextStyle(color: Colors.white24),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
