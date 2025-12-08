import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/custom_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  // Mock Attendance Data
  final Map<DateTime, bool> _attendanceData = {
    DateTime.now().subtract(const Duration(days: 1)): true, // Yesterday: Attended
    DateTime.now().subtract(const Duration(days: 2)): true,
    DateTime.now().subtract(const Duration(days: 3)): false, // Missed
    DateTime.now().subtract(const Duration(days: 4)): true,
    DateTime.now().subtract(const Duration(days: 5)): true,
    DateTime.now().subtract(const Duration(days: 6)): true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildStatsHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: GlassContainer(
                  opacity: 0.05,
                  child: TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      _showDayDetails(context, selectedDay);
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: AppTextStyles.bodyMedium,
                      weekendTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      outsideTextStyle: AppTextStyles.bodyMedium.copyWith(color: const Color.fromRGBO(179, 179, 179, 0.5)),
                      todayDecoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 255, 136, 0.3),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: AppTextStyles.headlineLarge,
                      leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
                      rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        return _buildDayCell(day);
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        return _buildDayCell(day, isSelected: true);
                      },
                      todayBuilder: (context, day, focusedDay) {
                        return _buildDayCell(day, isToday: true);
                      },
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

  Widget _buildDayCell(DateTime day, {bool isSelected = false, bool isToday = false}) {
    // Check attendance
    // Normalize date to ignore time
    final normalizedDay = DateTime(day.year, day.month, day.day);
    bool? attended;
    
    // Simple check against mock data keys (inefficient for large data but fine for mock)
    for (var key in _attendanceData.keys) {
      if (isSameDay(key, normalizedDay)) {
        attended = _attendanceData[key];
        break;
      }
    }

    Color? bgColor;
    if (attended == true) {
      bgColor = const Color.fromRGBO(0, 255, 136, 0.2);
    } else if (attended == false) {
      bgColor = const Color.fromRGBO(255, 68, 68, 0.2);
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(color: AppColors.primary) : null,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: attended == true ? AppColors.primary : (attended == false ? AppColors.error : AppColors.textPrimary),
            fontWeight: attended != null ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Row(
      children: [
        Expanded(
          child: CustomCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.local_fire_department, color: AppColors.warning, size: 32),
                const SizedBox(height: 8),
                Text('12 Days', style: AppTextStyles.headlineLarge),
                Text('Current Streak', style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.emoji_events, color: AppColors.primary, size: 32),
                const SizedBox(height: 8),
                Text('24 Days', style: AppTextStyles.headlineLarge),
                Text('Best Streak', style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDayDetails(BuildContext context, DateTime day) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        height: 300,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workout Details',
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Date: ${day.day}/${day.month}/${day.year}',
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 24),
              // Mock details
              Row(
                children: [
                  const Icon(Icons.fitness_center, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('Push Day', style: AppTextStyles.bodyLarge),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.timer, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('1h 15m', style: AppTextStyles.bodyLarge),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
