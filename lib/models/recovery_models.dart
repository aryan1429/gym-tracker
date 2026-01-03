import 'package:flutter/material.dart';

/// Recovery level for a muscle group
enum RecoveryLevel {
  fresh,     // Not worked in 72+ hours
  ready,     // 48-72 hours since last workout
  fatigued,  // 24-48 hours since last workout
  sore,      // Less than 24 hours or high soreness
}

/// Extension to get color and display text for recovery levels
extension RecoveryLevelExtension on RecoveryLevel {
  Color get color {
    switch (this) {
      case RecoveryLevel.fresh:
        return const Color(0xFF00FF88); // Bright green
      case RecoveryLevel.ready:
        return const Color(0xFF88FF00); // Yellow-green
      case RecoveryLevel.fatigued:
        return const Color(0xFFFFAA00); // Orange
      case RecoveryLevel.sore:
        return const Color(0xFFFF3366); // Red-pink
    }
  }

  String get label {
    switch (this) {
      case RecoveryLevel.fresh:
        return 'Fresh';
      case RecoveryLevel.ready:
        return 'Ready';
      case RecoveryLevel.fatigued:
        return 'Fatigued';
      case RecoveryLevel.sore:
        return 'Sore';
    }
  }

  IconData get icon {
    switch (this) {
      case RecoveryLevel.fresh:
        return Icons.check_circle_rounded;
      case RecoveryLevel.ready:
        return Icons.thumb_up_rounded;
      case RecoveryLevel.fatigued:
        return Icons.warning_rounded;
      case RecoveryLevel.sore:
        return Icons.healing_rounded;
    }
  }
}

/// Represents a muscle group in the body
class MuscleGroup {
  final String id;
  final String name;
  final IconData icon;
  final List<String> relatedExercises;

  const MuscleGroup({
    required this.id,
    required this.name,
    required this.icon,
    required this.relatedExercises,
  });

  /// Predefined muscle groups
  static const List<MuscleGroup> all = [
    MuscleGroup(
      id: 'chest',
      name: 'Chest',
      icon: Icons.accessibility_new_rounded,
      relatedExercises: ['Bench Press', 'Push Ups', 'Cable Flys', 'Dips'],
    ),
    MuscleGroup(
      id: 'back',
      name: 'Back',
      icon: Icons.accessibility_rounded,
      relatedExercises: ['Pull Ups', 'Rows', 'Lat Pulldown', 'Deadlifts'],
    ),
    MuscleGroup(
      id: 'shoulders',
      name: 'Shoulders',
      icon: Icons.fitness_center_rounded,
      relatedExercises: ['Shoulder Press', 'Lateral Raises', 'Face Pulls'],
    ),
    MuscleGroup(
      id: 'biceps',
      name: 'Biceps',
      icon: Icons.sports_gymnastics_rounded,
      relatedExercises: ['Curls', 'Pull Ups', 'Rows'],
    ),
    MuscleGroup(
      id: 'triceps',
      name: 'Triceps',
      icon: Icons.sports_handball_rounded,
      relatedExercises: ['Pushdowns', 'Dips', 'Bench Press'],
    ),
    MuscleGroup(
      id: 'quads',
      name: 'Quadriceps',
      icon: Icons.directions_run_rounded,
      relatedExercises: ['Squats', 'Leg Press', 'Leg Extensions'],
    ),
    MuscleGroup(
      id: 'hamstrings',
      name: 'Hamstrings',
      icon: Icons.directions_walk_rounded,
      relatedExercises: ['Leg Curls', 'Romanian Deadlifts', 'Lunges'],
    ),
    MuscleGroup(
      id: 'glutes',
      name: 'Glutes',
      icon: Icons.airline_seat_recline_normal_rounded,
      relatedExercises: ['Squats', 'Hip Thrusts', 'Lunges'],
    ),
    MuscleGroup(
      id: 'calves',
      name: 'Calves',
      icon: Icons.height_rounded,
      relatedExercises: ['Calf Raises'],
    ),
    MuscleGroup(
      id: 'core',
      name: 'Core',
      icon: Icons.center_focus_strong_rounded,
      relatedExercises: ['Planks', 'Crunches', 'Russian Twists'],
    ),
  ];

  static MuscleGroup? findById(String id) {
    try {
      return all.firstWhere((mg) => mg.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// Recovery status for a specific muscle group
class RecoveryStatus {
  final MuscleGroup muscleGroup;
  final DateTime? lastWorked;
  final int soreness; // 0-5 scale
  final RecoveryLevel level;

  RecoveryStatus({
    required this.muscleGroup,
    this.lastWorked,
    this.soreness = 0,
    RecoveryLevel? level,
  }) : level = level ?? _calculateLevel(lastWorked, soreness);

  /// Calculate recovery level based on time and soreness
  static RecoveryLevel _calculateLevel(DateTime? lastWorked, int soreness) {
    // High soreness overrides time-based calculation
    if (soreness >= 4) return RecoveryLevel.sore;

    if (lastWorked == null) return RecoveryLevel.fresh;

    final hoursSince = DateTime.now().difference(lastWorked).inHours;

    if (hoursSince >= 72) {
      return RecoveryLevel.fresh;
    } else if (hoursSince >= 48) {
      return soreness >= 2 ? RecoveryLevel.fatigued : RecoveryLevel.ready;
    } else if (hoursSince >= 24) {
      return RecoveryLevel.fatigued;
    } else {
      return RecoveryLevel.sore;
    }
  }

  /// Get hours since last workout
  int? get hoursSinceLastWorkout {
    if (lastWorked == null) return null;
    return DateTime.now().difference(lastWorked!).inHours;
  }

  /// Get days since last workout
  String get daysSinceText {
    if (lastWorked == null) return 'Never';
    final days = DateTime.now().difference(lastWorked!).inDays;
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    return '$days days ago';
  }

  /// Create a copy with updated values
  RecoveryStatus copyWith({
    MuscleGroup? muscleGroup,
    DateTime? lastWorked,
    int? soreness,
    RecoveryLevel? level,
  }) {
    return RecoveryStatus(
      muscleGroup: muscleGroup ?? this.muscleGroup,
      lastWorked: lastWorked ?? this.lastWorked,
      soreness: soreness ?? this.soreness,
      level: level,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'muscleGroupId': muscleGroup.id,
      'lastWorked': lastWorked?.toIso8601String(),
      'soreness': soreness,
    };
  }

  /// Create from JSON
  static RecoveryStatus? fromJson(Map<String, dynamic> json) {
    final muscleGroup = MuscleGroup.findById(json['muscleGroupId'] as String);
    if (muscleGroup == null) return null;

    return RecoveryStatus(
      muscleGroup: muscleGroup,
      lastWorked: json['lastWorked'] != null 
          ? DateTime.parse(json['lastWorked'] as String)
          : null,
      soreness: json['soreness'] as int? ?? 0,
    );
  }
}
