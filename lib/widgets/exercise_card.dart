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
              
              // Notes & History
              Row(
                children: [
                   Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 171, 64, 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color.fromRGBO(255, 171, 64, 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('INSTRUCTIONS', style: TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            widget.notes,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.warning, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PREVIOUS BEST', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
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
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add personal notes (e.g. Widen Grip)',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.edit_note, color: Colors.white54),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              // Sets Tracker
              _buildSetHeaders(),
              const SizedBox(height: 8),
              ..._sets.asMap().entries.map((entry) => _buildSetRow(entry.key, entry.value)),
              
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () => setState(() => _sets.add({'weight': '0', 'reps': '0', 'done': false})),
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  label: const Text('Add Set', style: TextStyle(color: AppColors.primary)),
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
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 10), // Adjust alignment
          hintText: '-',
          hintStyle: TextStyle(color: Colors.white24),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
