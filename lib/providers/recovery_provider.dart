import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recovery_models.dart';

class RecoveryProvider extends ChangeNotifier {
  static const String _storageKey = 'recovery_statuses';
  
  Map<String, RecoveryStatus> _recoveryStatuses = {};
  bool _isLoading = false;

  Map<String, RecoveryStatus> get recoveryStatuses => _recoveryStatuses;
  bool get isLoading => _isLoading;

  /// Get recovery status for a specific muscle group
  RecoveryStatus getStatus(String muscleGroupId) {
    if (_recoveryStatuses.containsKey(muscleGroupId)) {
      return _recoveryStatuses[muscleGroupId]!;
    }
    
    // Return default status if not found
    final muscleGroup = MuscleGroup.findById(muscleGroupId);
    if (muscleGroup != null) {
      return RecoveryStatus(muscleGroup: muscleGroup);
    }
    
    throw Exception('Muscle group not found: $muscleGroupId');
  }

  /// Get all statuses as a list
  List<RecoveryStatus> get allStatuses {
    // Ensure we have status for all muscle groups
    final statuses = <RecoveryStatus>[];
    for (final muscleGroup in MuscleGroup.all) {
      statuses.add(getStatus(muscleGroup.id));
    }
    return statuses;
  }

  /// Get overall recovery percentage (0-100)
  int get overallRecoveryPercentage {
    if (_recoveryStatuses.isEmpty) return 100;
    
    final statuses = allStatuses;
    final recovered = statuses.where((s) => 
      s.level == RecoveryLevel.fresh || s.level == RecoveryLevel.ready
    ).length;
    
    return ((recovered / statuses.length) * 100).round();
  }

  /// Get muscles that are ready to train
  List<RecoveryStatus> get readyMuscles {
    return allStatuses.where((s) => 
      s.level == RecoveryLevel.fresh || s.level == RecoveryLevel.ready
    ).toList();
  }

  /// Get muscles that need rest
  List<RecoveryStatus> get soreMuscles {
    return allStatuses.where((s) => 
      s.level == RecoveryLevel.sore || s.level == RecoveryLevel.fatigued
    ).toList();
  }

  /// Log workout for specific muscle groups
  Future<void> logWorkout(List<String> muscleGroupIds, {int defaultSoreness = 2}) async {
    for (final id in muscleGroupIds) {
      final muscleGroup = MuscleGroup.findById(id);
      if (muscleGroup != null) {
        _recoveryStatuses[id] = RecoveryStatus(
          muscleGroup: muscleGroup,
          lastWorked: DateTime.now(),
          soreness: defaultSoreness,
        );
      }
    }
    
    await _saveToStorage();
    notifyListeners();
  }

  /// Update soreness level for a muscle group
  Future<void> updateSoreness(String muscleGroupId, int soreness) async {
    final currentStatus = getStatus(muscleGroupId);
    _recoveryStatuses[muscleGroupId] = RecoveryStatus(
      muscleGroup: currentStatus.muscleGroup,
      lastWorked: currentStatus.lastWorked,
      soreness: soreness.clamp(0, 5),
    );
    
    await _saveToStorage();
    notifyListeners();
  }

  /// Load recovery data from storage
  Future<void> loadFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _recoveryStatuses = {};
        
        jsonMap.forEach((key, value) {
          final status = RecoveryStatus.fromJson(value as Map<String, dynamic>);
          if (status != null) {
            _recoveryStatuses[key] = status;
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading recovery data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save recovery data to storage
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> jsonMap = {};
      
      _recoveryStatuses.forEach((key, value) {
        jsonMap[key] = value.toJson();
      });
      
      await prefs.setString(_storageKey, json.encode(jsonMap));
    } catch (e) {
      debugPrint('Error saving recovery data: $e');
    }
  }

  /// Get workout suggestion based on recovery status
  String getWorkoutSuggestion() {
    final ready = readyMuscles;
    
    if (ready.isEmpty) {
      return '🛌 All muscles need rest. Take a recovery day!';
    }
    
    // Check for specific workout splits
    final readyIds = ready.map((s) => s.muscleGroup.id).toSet();
    
    if (readyIds.containsAll(['chest', 'shoulders', 'triceps'])) {
      return '💪 Perfect for Push Day! Chest, shoulders, and triceps are ready.';
    }
    
    if (readyIds.containsAll(['back', 'biceps'])) {
      return '🔥 Pull Day recommended! Back and biceps are recovered.';
    }
    
    if (readyIds.containsAll(['quads', 'hamstrings', 'glutes'])) {
      return '🦵 Leg Day time! Lower body is fully recovered.';
    }
    
    if (ready.length >= 5) {
      return '✨ Most muscles recovered! Great day for any workout.';
    }
    
    final muscleNames = ready.take(3).map((s) => s.muscleGroup.name).join(', ');
    return '💪 Ready: $muscleNames. Time to train!';
  }

  /// Determine which muscles were worked based on workout type
  static List<String> getMusclesForWorkout(String workoutType) {
    final type = workoutType.toLowerCase();
    
    if (type.contains('push')) {
      return ['chest', 'shoulders', 'triceps'];
    } else if (type.contains('pull')) {
      return ['back', 'biceps'];
    } else if (type.contains('leg')) {
      return ['quads', 'hamstrings', 'glutes', 'calves'];
    } else if (type.contains('full')) {
      return ['chest', 'back', 'shoulders', 'biceps', 'triceps', 'quads', 'hamstrings'];
    }
    
    return [];
  }
}
