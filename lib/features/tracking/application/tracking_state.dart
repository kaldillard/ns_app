import '../data/tracking_models.dart';

class TrackingState {
  final List<MoodCheckIn> checkIns;
  final List<CompletedExercise> completedExercises;

  const TrackingState({
    this.checkIns = const [],
    this.completedExercises = const [],
  });

  TrackingState copyWith({
    List<MoodCheckIn>? checkIns,
    List<CompletedExercise>? completedExercises,
  }) {
    return TrackingState(
      checkIns: checkIns ?? this.checkIns,
      completedExercises: completedExercises ?? this.completedExercises,
    );
  }
}

/// A single entry for the history list - either a check-in or a completed
/// exercise. Carries raw domain data plus a common timestamp to sort by;
/// formatting (icons, date strings) is decided in the presentation layer,
/// not here, so a UI designer can restyle history display freely.
class HistoryItem {
  final DateTime timestamp;
  final MoodCheckIn? checkIn;
  final CompletedExercise? completedExercise;

  HistoryItem.fromCheckIn(MoodCheckIn c)
    : timestamp = c.timestamp,
      checkIn = c,
      completedExercise = null;

  HistoryItem.fromCompleted(CompletedExercise c)
    : timestamp = c.timestamp,
      checkIn = null,
      completedExercise = c;
}
