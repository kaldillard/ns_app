import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../exercises/application/exercise_providers.dart';
import '../../tracking/application/tracking_notifier.dart';
import 'checkin_state.dart';
import 'suggestion_service.dart';

class CheckInNotifier extends Notifier<CheckInState> {
  @override
  CheckInState build() => const CheckInState();

  void selectMood(String mood) {
    state = state.copyWith(mood: mood);
  }

  void selectTime(String time) {
    state = state.copyWith(timeAvailable: time);
  }

  Future<void> submit() async {
    final mood = state.mood;
    final time = state.timeAvailable;
    if (mood == null || time == null) return;

    state = state.copyWith(stage: CheckInStage.loading);

    try {
      await ref
          .read(trackingNotifierProvider.notifier)
          .addCheckIn(mood: mood, timeAvailable: time);

      final repo = ref.read(exerciseRepositoryProvider);
      final all = await repo.fetchExercises();

      final suggestions = suggestExercises(
        allExercises: all,
        mood: mood,
        timeAvailable: time,
      );

      state = state.copyWith(
        stage: CheckInStage.suggestions,
        suggestions: suggestions,
      );
    } catch (e) {
      state = state.copyWith(
        stage: CheckInStage.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const CheckInState();
  }
}

final checkInNotifierProvider = NotifierProvider<CheckInNotifier, CheckInState>(
  CheckInNotifier.new,
);
