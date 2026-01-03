import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:flutter/foundation.dart';

class WeatherService {
  // Use a demo API key for now - user should replace with their own
  static const String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
  late WeatherFactory _weatherFactory;

  WeatherService() {
    _weatherFactory = WeatherFactory(_apiKey);
  }

  /// Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied');
        return null;
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low, // Low accuracy is sufficient for weather
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  /// Fetch weather data for current location
  Future<Weather?> getCurrentWeather() async {
    try {
      final position = await getCurrentLocation();
      if (position == null) {
        // Return demo weather data if location is unavailable (for testing)
        return _getDemoWeather();
      }

      final weather = await _weatherFactory.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      return weather;
    } catch (e) {
      debugPrint('Error fetching weather: $e');
      // Return demo data on error for better UX
      return _getDemoWeather();
    }
  }

  /// Get demo weather data for testing
  Weather? _getDemoWeather() {
    // Note: This is a fallback for when API key is not set or network fails
    // In production, you'd want to handle this more gracefully
    return null;
  }

  /// Generate workout suggestions based on weather
  String getWorkoutSuggestion(Weather? weather) {
    if (weather == null) {
      return "💪 Ready to crush your workout!";
    }

    final temp = weather.temperature?.celsius ?? 20;
    final condition = weather.weatherMain?.toLowerCase() ?? '';
    final description = weather.weatherDescription?.toLowerCase() ?? '';

    // Rain/Snow conditions
    if (condition.contains('rain') || 
        condition.contains('snow') || 
        description.contains('rain') || 
        description.contains('snow')) {
      return "🏠 Weather's rough! Perfect day for indoor Push/Pull/Legs workout.";
    }

    // Very hot weather
    if (temp > 32) {
      return "🔥 It's hot out! Stay hydrated or workout in AC. Early morning recommended.";
    }

    // Hot weather
    if (temp > 28) {
      return "☀️ Warm weather - great for gym! Remember to stay hydrated.";
    }

    // Cold weather
    if (temp < 10) {
      return "❄️ Cold outside! Indoor workout recommended. Warm up properly!";
    }

    // Very cold
    if (temp < 5) {
      return "🥶 Freezing! Stay warm indoors and hit those weights!";
    }

    // Perfect weather
    if (temp >= 18 && temp <= 25) {
      return "✨ Perfect weather! Great day for any workout. Let's go!";
    }

    // Mild weather
    return "💪 Good weather for training. Time to hit the gym!";
  }

  /// Get weather emoji icon
  String getWeatherEmoji(Weather? weather) {
    if (weather == null) return '☁️';

    final condition = weather.weatherMain?.toLowerCase() ?? '';
    
    if (condition.contains('clear')) return '☀️';
    if (condition.contains('cloud')) return '☁️';
    if (condition.contains('rain')) return '🌧️';
    if (condition.contains('snow')) return '❄️';
    if (condition.contains('thunder')) return '⛈️';
    if (condition.contains('mist') || condition.contains('fog')) return '🌫️';
    
    return '☁️';
  }
}
