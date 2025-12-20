import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PhotoProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  
  // Data Structure: Album Name (Month Year) -> List of Image Paths
  // Using String paths instead of XFile to support potential mixing of local/network later
  final Map<String, List<String>> _albums = {
    // Initial Mock Data
    'December 2025': [],
    'November 2025': [], 
  };

  Map<String, List<String>> get albums => _albums;

  // For demo purposes, we allow forcing a date to simulate testing historical albums
  // In production, this would just use DateTime.now()
  Future<void> capturePhoto({DateTime? overrideDate}) async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      
      if (photo != null) {
        _savePhoto(photo, overrideDate ?? DateTime.now());
      }
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    }
  }

  void _savePhoto(XFile photo, DateTime date) {
    // Format Album Name: "December 2025"
    final String albumName = DateFormat('MMMM yyyy').format(date);
    
    if (!_albums.containsKey(albumName)) {
      _albums[albumName] = [];
    }

    // Add new photo to the beginning of the list (newest first)
    _albums[albumName]!.insert(0, photo.path);
    
    notifyListeners();
  }
}
