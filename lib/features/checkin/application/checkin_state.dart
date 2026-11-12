import '../../exercises/data/exercise_model.dart';

enum CheckInStage { form, loading, suggestions, error }

class CheckInState {
  final CheckInStage stage;
  final String? mood;
  final String? timeAvailable;
  final List<Exercise> suggestions;
  final String? errorMessage;

  const CheckInState({
    this.stage = CheckInStage.form,
    this.mood,
    this.timeAvailable,
    this.suggestions = const [],
    this.errorMessage,
  });

  CheckInState copyWith({
    CheckInStage? stage,
    String? mood,
    String? timeAvailable,
    List<Exercise>? suggestions,
    String? errorMessage,
  }) {
    return CheckInState(
      stage: stage ?? this.stage,
      mood: mood ?? this.mood,
      timeAvailable: timeAvailable ?? this.timeAvailable,
      suggestions: suggestions ?? this.suggestions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get canSubmit => mood != null && timeAvailable != null;
}
