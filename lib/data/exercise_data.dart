import 'package:flutter/foundation.dart';

// Dedicated data file to share exercises between screens
class ExerciseData {
  static List<Map<String, String>> _processList(List<Map<String, String>> list) {
    if (!kIsWeb) return list;
    return list.map((e) {
      if (e.containsKey('image')) {
        final url = e['image']!;
        // Use wsrv.nl for CORS proxy and optimization
        final cleanUrl = url.replaceFirst(RegExp(r'^https?://'), '');
        final proxyUrl = 'https://wsrv.nl/?url=$cleanUrl&output=gif&n=-1';
        return {...e, 'image': proxyUrl};
      }
      return e;
    }).toList();
  }

  static List<Map<String, String>> getExercises(String workoutName) {
    if (workoutName == 'Pull Day') {
      return _processList([
        {
          'name': 'Child Pose (Lats & Back)',
          // Using a more reliable direct GIF source if possible, or keeping the tenor one but noting it might be fragile
          // Trying a standard fitness gif source for stability
          'image': 'https://media.tenor.com/gk7x8VVpBNMAAAAM/workout-working-out.gif', 
          'target': 'Mobility',
          'sets': '2 Sets x 30s',
          'notes': 'Focus on deep breathing and stretching the lats.',
        },
        {
          'name': 'Pull Ups',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Pull-up.gif',
          'target': 'Back, Biceps',
          'sets': '2 Sets x 8-10 Reps',
          'notes': 'Chin over bar. Control the descent.',
        },
         {
          'name': 'Neutral Grip Lat Pulldown',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Close-Grip-Lat-Pulldown.gif',
          'target': 'Lats',
          'sets': '3 Sets x 10-8-8 Reps',
          'notes': 'Drive elbows down.',
        },
        {
          'name': 'Barbell Rows',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Bent-Over-Row.gif',
          'target': 'Back',
          'sets': '3 Sets x 12-10-8 Reps',
          'notes': 'Keep back neutral.',
        },
        {
          'name': 'Single Arm Cable Rows',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/One-Arm-Cable-Row.gif',
          'target': 'Back',
          'sets': '2 Sets x 12-8 Reps',
          'notes': 'Full stretch at bottom.',
        },
        {
          'name': 'Chest Supported T-Bar Rows',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Lever-T-bar-Row.gif',
          'target': 'Upper Back',
          'sets': '2 Sets x 12-10 Reps',
          'notes': 'Chest glued to pad.',
        },
        {
          'name': 'Lat Pullover',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Cable-Pullover.gif',
          'target': 'Lats',
          'sets': '3 Sets x 12-10-10 Reps',
          'notes': 'Focus on stretch.',
        },
        {
          'name': 'Incline DB Curls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Incline-Dumbbell-Curl.gif',
          'target': 'Biceps',
          'sets': '3 Sets x 12-Failure',
          'notes': 'Elbows back.',
        },
        {
          'name': 'Cable Hammer Curls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Cable-Hammer-Curl.gif',
          'target': 'Biceps, Forearms',
          'sets': '3 Sets x 12 Reps',
          'notes': 'Squeeze at peak.',
        },
        {
          'name': 'Kelso Shrugs',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Dumbbell-Shrug.gif',
          'target': 'Traps',
          'sets': '3 Sets x 15-12-12 Reps',
          'notes': 'Scapular retraction.',
        },
        {
          'name': 'Lower Back Extension',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Back-Extension.gif',
          'target': 'Lower Back',
          'sets': '2 Sets x 12-10 Reps',
          'notes': 'Control movement.',
        },
        {
          'name': 'Forearm Curls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Wrist-Curl.gif',
          'target': 'Forearms',
          'sets': '2 Sets x 15-20 Reps',
          'notes': 'Burnout.',
        },
      ]);
    } else if (workoutName == 'Push Day') {
      return _processList([
        {
          'name': 'Joint Warmup',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/06/Arm-Circles.gif',
          'target': 'Mobility',
           'sets': '5 mins',
          'notes': 'Dynamic stretching.',
        },
        {
          'name': 'Pushups',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Push-Up.gif',
          'target': 'Chest, Triceps',
          'sets': '1 Set x 60 Reps',
          'notes': 'Warmup set.',
        },
        {
          'name': 'Smith Incline Bench Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Smith-Machine-Incline-Bench-Press.gif',
          'target': 'Upper Chest',
          'sets': '3 Sets x 12-10-8 Reps',
          'notes': 'Controlled negative.',
        },
        {
          'name': 'Cable Flys',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/09/Low-Cable-Fly.gif',
          'target': 'Chest',
           'sets': '3 Sets x 12-10-8 Reps',
          'notes': 'Squeeze chest.',
        },
        {
          'name': 'Peck Deck Machine',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Pec-Deck-Fly.gif',
          'target': 'Chest',
           'sets': '2 Sets x Failure',
          'notes': 'Constant tension.',
        },
        {
          'name': 'Dips',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Triceps-Dip.gif',
          'target': 'Chest, Triceps',
           'sets': '2 Sets x Failure',
          'notes': 'Lean forward.',
        },
        {
          'name': 'Smith Shoulder Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Smith-Machine-Shoulder-Press.gif',
          'target': 'Shoulders',
           'sets': '3 Sets x 12-10-8 Reps',
          'notes': 'Bar to chin level.',
        },
        {
          'name': 'Cable Lateral Raises',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Cable-Lateral-Raise.gif',
          'target': 'Side Delts',
           'sets': '3 Sets x 12-6 Reps',
          'notes': 'Lead with elbows.',
        },
        {
          'name': 'Face Pulls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Face-Pull.gif',
          'target': 'Rear Delts',
           'sets': '3 Sets x 12-12-10 Reps',
          'notes': 'External rotation.',
        },
        {
          'name': 'Rope Pushdowns',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Pushdown.gif',
          'target': 'Triceps',
           'sets': '3 Sets x Failure',
          'notes': 'Squeeze at bottom.',
        },
        {
          'name': 'Dumbbell Overhead Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Dumbbell-Shoulder-Press.gif',
          'target': 'Shoulders',
           'sets': '2 Sets x 12 Reps',
          'notes': 'Core tight.',
        },
      ]);
    } else if (workoutName == 'Legs (Hams)') {
      return _processList([
        {
          'name': 'Stretches & Warmup',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/04/Hip-Circles.gif',
          'target': 'Mobility',
           'sets': '5 mins',
          'notes': 'Warmup properly.',
        },
        {
          'name': 'Leg Curls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Leg-Curl.gif',
          'target': 'Hamstrings',
           'sets': '3 Sets x 15-12-10 Reps',
          'notes': 'Control eccentric.',
        },
        {
          'name': 'Romanian Deadlifts',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Dumbbell-Romanian-Deadlift.gif',
          'target': 'Hamstrings, Glutes',
           'sets': '2 Sets x 12-10 Reps',
          'notes': 'Hinge at hips.',
        },
        {
          'name': 'Lunges',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Dumbbell-Lunge.gif',
          'target': 'Legs',
           'sets': '2 Sets',
          'notes': 'Keep core tight.',
        },
        {
          'name': 'Leg Extensions',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Leg-Extension.gif',
          'target': 'Quads',
           'sets': '3 Sets x 15-20 Reps',
          'notes': 'Squeeze at top.',
        },
        {
          'name': 'Hip Abduction Machine',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Hip-Abduction-Machine.gif',
          'target': 'Glutes',
           'sets': '2 Sets x 12-15 Reps',
          'notes': 'Control movement.',
        },
        {
          'name': 'Calf Raises',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Calf-Raise.gif',
          'target': 'Calves',
           'sets': '3 Sets x Failure',
          'notes': 'Full ROM.',
        },
      ]);
    } else if (workoutName == 'Legs (Quads)') {
      return _processList([
        {
          'name': 'Stretches & Mobility',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/04/Hip-Circles.gif',
          'target': 'Mobility',
           'sets': '5 mins',
          'notes': 'Warmup.',
        },
        {
          'name': 'Barbell Squats',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Squat.gif',
          'target': 'Quads, Glutes',
           'sets': '3 Sets x 10-8-8 Reps',
          'notes': 'Depth is key.',
        },
        {
          'name': 'Leg Extensions',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Leg-Extension.gif',
          'target': 'Quads',
           'sets': '4 Sets x 15-20 Reps',
          'notes': 'High volume.',
        },
        {
          'name': 'Leg Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Leg-Press.gif',
          'target': 'Quads',
           'sets': '3 Sets x 15-12 Reps',
          'notes': 'Full ROM.',
        },
        {
          'name': 'Leg Curls',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Leg-Curl.gif',
          'target': 'Hamstrings',
           'sets': '3 Sets x 15-12-12 Reps',
          'notes': 'Balance.',
        },
        {
          'name': 'Hip Abduction Machine',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Hip-Abduction-Machine.gif',
          'target': 'Glutes',
           'sets': '2 Sets x 15 Reps',
          'notes': 'Glute focus.',
        },
        {
          'name': 'Calf Raises',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Calf-Raise.gif',
          'target': 'Calves',
           'sets': '2 Sets x Failure',
          'notes': 'Burn it out.',
        },
      ]);
    } else if (workoutName == 'Full Body') {
      return _processList([
         {
          'name': 'Warmup (Dynamic Stretches)',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/06/Arm-Circles.gif',
          'target': 'Mobility',
           'sets': '5 mins',
          'notes': 'Dynamic.',
        },
        {
          'name': 'Deadlifts',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Deadlift.gif',
          'target': 'Full Body',
           'sets': '3 Sets x 5-8 Reps',
          'notes': 'Flat back.',
        },
        {
          'name': 'Bench Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Bench-Press.gif',
          'target': 'Chest',
           'sets': '3 Sets x 8-10 Reps',
          'notes': 'Controlled.',
        },
        {
          'name': 'Barbell Rows',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Bent-Over-Row.gif',
          'target': 'Back',
           'sets': '3 Sets x 10-12 Reps',
          'notes': 'Squeeze.',
        },
        {
          'name': 'Overhead Press',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Shoulder-Press.gif',
          'target': 'Shoulders',
           'sets': '3 Sets x 8-12 Reps',
          'notes': 'Full extension.',
        },
        {
          'name': 'Squats',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Barbell-Squat.gif',
          'target': 'Legs',
           'sets': '3 Sets x 8-12 Reps',
          'notes': 'Depth.',
        },
         {
          'name': 'Pull Ups',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Pull-up.gif',
          'target': 'Back, Biceps',
           'sets': '3 Sets',
          'notes': 'Chin up.',
        },
        {
          'name': 'Dips',
          'image': 'https://fitnessprogramer.com/wp-content/uploads/2021/02/Triceps-Dip.gif',
          'target': 'Chest, Triceps',
           'sets': '3 Sets',
          'notes': 'Dip low.',
        },
      ]);
    }
    
    return _processList([]);
  }
}
