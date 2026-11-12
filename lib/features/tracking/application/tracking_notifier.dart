import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/storage/shared_prefs_provider.dart';
import '../data/tracking_models.dart';
import '../data/tracking_repository.dart';
import 'tracking_state.dart';

const _uuid = Uuid();

class TrackingNotifier extends Notifier<TrackingState> {
  late final TrackingRepository _repository;

  @override
  TrackingState build() {
    _repository = TrackingRepository(ref.watch(sharedPreferencesProvider));
    return TrackingState(
      checkIns: _repository.getCheckIns(),
      completedExercises: _repository.getCompletedExercises(),
    );
  }

  Future<void> addCheckIn({
    required String mood,
    required String timeAvailable,
  }) async {
    final entry = MoodCheckIn(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      mood: mood,
      timeAvailable: timeAvailable,
    );
    final updated = [entry, ...state.checkIns];
    await _repository.saveCheckIns(updated);
    state = state.copyWith(checkIns: updated);
  }

  Future<void> addCompletedExercise({
    required String exerciseId,
    required String exerciseName,
    String? moodAtTheTime,
  }) async {
    final entry = CompletedExercise(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      moodAtTheTime: moodAtTheTime,
    );
    final updated = [entry, ...state.completedExercises];
    await _repository.saveCompletedExercises(updated);
    state = state.copyWith(completedExercises: updated);
  }
}

final trackingNotifierProvider =
    NotifierProvider<TrackingNotifier, TrackingState>(TrackingNotifier.new);

/// Merged, sorted view of check-ins + completed exercises for the history
/// screen. Automatically recomputes whenever tracking state changes -
/// the history screen stays live without any manual refresh needed.
final historyItemsProvider = Provider<List<HistoryItem>>((ref) {
  final trackingState = ref.watch(trackingNotifierProvider);
  final items = <HistoryItem>[
    ...trackingState.checkIns.map(HistoryItem.fromCheckIn),
    ...trackingState.completedExercises.map(HistoryItem.fromCompleted),
  ];
  items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return items;
});
