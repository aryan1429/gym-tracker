import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  
  Weather? _currentWeather;
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdate;

  Weather? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdate => _lastUpdate;

  /// Get weather suggestion for workouts
  String get workoutSuggestion => _weatherService.getWorkoutSuggestion(_currentWeather);

  /// Get weather emoji
  String get weatherEmoji => _weatherService.getWeatherEmoji(_currentWeather);

  /// Get temperature string
  String get temperatureString {
    if (_currentWeather == null) return '--°';
    final temp = _currentWeather!.temperature?.celsius?.round() ?? 0;
    return '$temp°C';
  }

  /// Get weather condition
  String get condition {
    if (_currentWeather == null) return 'Loading...';
    return _currentWeather!.weatherDescription ?? 'Unknown';
  }

  /// Load weather data
  Future<void> loadWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final weather = await _weatherService.getCurrentWeather();
      _currentWeather = weather;
      _lastUpdate = DateTime.now();
      _error = null;
    } catch (e) {
      _error = 'Failed to load weather';
      debugPrint('Error loading weather: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh weather if data is stale (older than 30 minutes)
  Future<void> refreshIfNeeded() async {
    if (_lastUpdate == null || 
        DateTime.now().difference(_lastUpdate!).inMinutes > 30) {
      await loadWeather();
    }
  }

  /// Force refresh weather
  Future<void> refresh() async {
    await loadWeather();
  }
}
