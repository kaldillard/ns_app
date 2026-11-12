class MoodCheckIn {
  final String id;
  final DateTime timestamp;
  final String mood;
  final String timeAvailable;

  MoodCheckIn({
    required this.id,
    required this.timestamp,
    required this.mood,
    required this.timeAvailable,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'mood': mood,
    'timeAvailable': timeAvailable,
  };

  factory MoodCheckIn.fromJson(Map<String, dynamic> json) => MoodCheckIn(
    id: json['id'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    mood: json['mood'] as String,
    timeAvailable: json['timeAvailable'] as String,
  );
}

class CompletedExercise {
  final String id;
  final DateTime timestamp;
  final String exerciseId;
  final String exerciseName;
  final String? moodAtTheTime;

  CompletedExercise({
    required this.id,
    required this.timestamp,
    required this.exerciseId,
    required this.exerciseName,
    this.moodAtTheTime,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'exerciseId': exerciseId,
    'exerciseName': exerciseName,
    'moodAtTheTime': moodAtTheTime,
  };

  factory CompletedExercise.fromJson(Map<String, dynamic> json) =>
      CompletedExercise(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        exerciseId: json['exerciseId'] as String,
        exerciseName: json['exerciseName'] as String,
        moodAtTheTime: json['moodAtTheTime'] as String?,
      );
}
