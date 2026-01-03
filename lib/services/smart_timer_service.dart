import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

class SmartTimerService {
  static const double _stationaryThreshold = 0.5; // m/s² threshold for stationary
  static const double _activeThreshold = 2.0; // m/s² threshold for active movement
  static const int _debounceSeconds = 2; // Seconds to wait before triggering

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  Timer? _debounceTimer;
  
  bool _isListening = false;
  bool _autoStartEnabled = true;
  DateTime? _lastMovementTime;
  double _currentMagnitude = 0;
  
  // Callbacks
  Function()? onTimerStart;
  Function()? onTimerCancel;
  
  bool get isListening => _isListening;
  bool get autoStartEnabled => _autoStartEnabled;
  double get currentMagnitude => _currentMagnitude;

  /// Start listening to accelerometer
  void startListening({
    Function()? onStart,
    Function()? onCancel,
  }) {
    if (_isListening) return;

    onTimerStart = onStart;
    onTimerCancel = onCancel;
    _isListening = true;
    _lastMovementTime = DateTime.now();

    _accelerometerSubscription = accelerometerEventStream().listen(
      _handleAccelerometerEvent,
      onError: (error) {
        debugPrint('Accelerometer error: $error');
        stopListening();
      },
    );
  }

  /// Stop listening to accelerometer
  void stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _isListening = false;
  }

  /// Handle accelerometer events
  void _handleAccelerometerEvent(AccelerometerEvent event) {
    // Calculate magnitude of acceleration
    _currentMagnitude = _calculateMagnitude(event.x, event.y, event.z);

    if (_currentMagnitude > _activeThreshold) {
      // Phone is moving significantly - user is active
      _handleActiveMovement();
    } else if (_currentMagnitude < _stationaryThreshold) {
      // Phone is stationary - potential rest period
      _handleStationaryDetection();
    } else {
      // In-between - small movements (could be holding phone)
      _resetDebounceTimer();
    }
  }

  /// Calculate magnitude of acceleration vector
  double _calculateMagnitude(double x, double y, double z) {
    // Subtract gravity (9.8 m/s²) to get actual movement
    // We're interested in changes from rest position
    return ((x * x) + (y * y) + (z * z)).abs();
  }

  /// Handle active movement detection
  void _handleActiveMovement() {
    _lastMovementTime = DateTime.now();
    _resetDebounceTimer();
    
    // If timer was auto-started, cancel it since user is active
    if (onTimerCancel != null) {
      onTimerCancel!();
    }
  }

  /// Handle stationary detection
  void _handleStationaryDetection() {
    if (_lastMovementTime == null) return;

    final secondsSinceMovement = DateTime.now().difference(_lastMovementTime!).inSeconds;

    if (secondsSinceMovement >= _debounceSeconds && _debounceTimer == null) {
      // Phone has been stationary for enough time - start rest timer
      _startDebounceTimer();
    }
  }

  /// Start debounce timer before triggering auto-start
  void _startDebounceTimer() {
    _debounceTimer = Timer(Duration(seconds: _debounceSeconds), () {
      if (_autoStartEnabled && onTimerStart != null) {
        onTimerStart!();
        _triggerHapticFeedback();
      }
      _debounceTimer = null;
    });
  }

  /// Reset debounce timer
  void _resetDebounceTimer() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  /// Trigger haptic feedback
  Future<void> _triggerHapticFeedback() async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        await Vibration.vibrate(duration: 200);
      }
    } catch (e) {
      debugPrint('Vibration error: $e');
    }
  }

  /// Trigger completion vibration (when rest period ends)
  Future<void> triggerCompletionVibration() async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        // Pattern: vibrate 3 times
        await Vibration.vibrate(
          pattern: [0, 100, 100, 100, 100, 100],
        );
      }
    } catch (e) {
      debugPrint('Vibration error: $e');
    }
  }

  /// Toggle auto-start feature
  void setAutoStartEnabled(bool enabled) {
    _autoStartEnabled = enabled;
  }

  /// Dispose of resources
  void dispose() {
    stopListening();
  }
}

/// Timer settings model
class TimerSettings {
  final bool autoStartEnabled;
  final int defaultRestSeconds;
  final bool vibrationEnabled;
  final Map<String, int> exerciseSpecificRest;

  const TimerSettings({
    this.autoStartEnabled = true,
    this.defaultRestSeconds = 90,
    this.vibrationEnabled = true,
    this.exerciseSpecificRest = const {},
  });

  TimerSettings copyWith({
    bool? autoStartEnabled,
    int? defaultRestSeconds,
    bool? vibrationEnabled,
    Map<String, int>? exerciseSpecificRest,
  }) {
    return TimerSettings(
      autoStartEnabled: autoStartEnabled ?? this.autoStartEnabled,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      exerciseSpecificRest: exerciseSpecificRest ?? this.exerciseSpecificRest,
    );
  }

  /// Get rest time for specific exercise
  int getRestTimeForExercise(String exerciseName) {
    return exerciseSpecificRest[exerciseName] ?? defaultRestSeconds;
  }
}
