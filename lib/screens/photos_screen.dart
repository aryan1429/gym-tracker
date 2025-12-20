import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  String? _selectedMonth;

  final Map<String, int> _albums = {
    'December 2024': 12,
    'November 2024': 18,
    'October 2024': 15,
    'September 2024': 8,
    'August 2024': 20,
    'July 2024': 14,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with simplified navigation
              Row(
                children: [
                   if (_selectedMonth != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: IconButton(
                        onPressed: () => setState(() => _selectedMonth = null),
                        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surfaceLight,
                          padding: const EdgeInsets.all(12),
                        ),
                      ).animate().scale(),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedMonth ?? 'Progress Photos',
                        style: AppTextStyles.displayMedium.copyWith(
                          fontSize: _selectedMonth != null ? 28 : 32
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedMonth != null 
                            ? 'Displaying photos from this month' 
                            : 'Categorized by month',
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Animated Switcher for Views
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedMonth == null 
                      ? _buildAlbumList() 
                      : _buildGalleryView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumList() {
    return GridView.builder(
      key: const ValueKey('album_list'),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _albums.length,
      itemBuilder: (context, index) {
        final month = _albums.keys.elementAt(index);
        final count = _albums[month]!;
        return CustomCard(
          onTap: () => setState(() => _selectedMonth = month),
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.surfaceLight.withOpacity(0.5),
                  AppColors.surfaceLight,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ]
                  ),
                  child: const Icon(
                    Icons.folder_special_rounded, 
                    color: AppColors.primary, 
                    size: 40
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  month,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineLarge.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '$count Photos',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildGalleryView() {
    return GridView.builder(
      key: ValueKey('gallery_$_selectedMonth'),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _albums[_selectedMonth] ?? 0,
      itemBuilder: (context, index) {
        return _buildPhotoItem(context, index);
      },
    );
  }

  Widget _buildPhotoItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _showPhotoDetail(context, index),
      child: Hero(
        tag: 'photo_${_selectedMonth}_$index',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.surfaceLight,
            image: const DecorationImage(
              image: NetworkImage('https://via.placeholder.com/300x400'), // Placeholder
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color.fromRGBO(0, 0, 0, 0.8),
                ],
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_selectedMonth!.split(' ')[0]} ${index + 1}',
                  style: AppTextStyles.labelLarge.copyWith(fontSize: 14),
                ),
                Text(
                  'Shot ${index + 1}',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (50 * index).ms).scale();
  }

  void _showPhotoDetail(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Hero(
              tag: 'photo_${_selectedMonth}_$index',
              child: Image.network(
                'https://via.placeholder.com/600x800',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
