import '../../exercises/data/exercise_model.dart';

/// Moods the check-in screen offers, and roughly what kind of exercise
/// tags/categories fit each one. Tags are freeform text you set yourself
/// when creating exercises - these are just keyword hints matched against
/// your own tags/category, so use similar wording when tagging exercises
/// for the best matches (e.g. give gentle exercises a "recovery" or
/// "stretching" tag).
const Map<String, List<String>> moodTagHints = {
  'Energetic': ['cardio', 'strength', 'intense', 'full-body'],
  'Good': ['strength', 'full-body', 'beginner-friendly'],
  'Okay': ['beginner-friendly', 'full-body', 'no-equipment'],
  'Tired': ['low-intensity', 'recovery', 'stretching', 'no-equipment'],
  'Stressed': ['stretching', 'recovery', 'breathing', 'mobility'],
  'Sore': ['recovery', 'stretching', 'mobility', 'low-intensity'],
};

const List<String> moodOptions = [
  'Energetic',
  'Good',
  'Okay',
  'Tired',
  'Stressed',
  'Sore',
];

const List<String> timeOptions = ['5 min', '15 min', '30+ min'];

int _suggestionCountForTime(String timeAvailable) {
  switch (timeAvailable) {
    case '5 min':
      return 2;
    case '15 min':
      return 4;
    default:
      return 6;
  }
}

/// Scores and sorts exercises by relevance to a mood, then trims the list
/// to a sensible count based on how much time the person has.
List<Exercise> suggestExercises({
  required List<Exercise> allExercises,
  required String mood,
  required String timeAvailable,
}) {
  final hints = (moodTagHints[mood] ?? []).map((h) => h.toLowerCase()).toList();

  int scoreFor(Exercise ex) {
    final haystack = [
      ...ex.tags.map((t) => t.toLowerCase()),
      (ex.category ?? '').toLowerCase(),
    ];
    int score = 0;
    for (final hint in hints) {
      if (haystack.any((h) => h.contains(hint))) score++;
    }
    return score;
  }

  final scored = allExercises.map((e) => MapEntry(e, scoreFor(e))).toList();
  scored.sort((a, b) => b.value.compareTo(a.value));

  final anyMatches = scored.any((e) => e.value > 0);
  final ordered =
      anyMatches
          ? scored.map((e) => e.key).toList()
          : (allExercises.toList()..shuffle());

  final count = _suggestionCountForTime(timeAvailable);
  return ordered.take(count).toList();
}
