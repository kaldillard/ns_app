import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_client.dart';
import '../data/exercise_model.dart';
import '../data/exercise_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: Env.apiBaseUrl);
});

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return ExerciseRepository(ref.watch(apiClientProvider));
});

/// Query parameters for listing exercises, bundled as a record so it works
/// as a `.family` argument. Riverpod caches each distinct query separately,
/// so switching between two searches you've already run returns instantly
/// from cache instead of refetching.
typedef ExerciseQuery = ({String? category, String? tag, String? search});

const noExerciseFilter = (category: null, tag: null, search: null);

final exerciseListProvider =
    FutureProvider.family<List<Exercise>, ExerciseQuery>((ref, query) {
      final repo = ref.watch(exerciseRepositoryProvider);
      return repo.fetchExercises(
        category: query.category,
        tag: query.tag,
        search: query.search,
      );
    });

final exerciseDetailProvider = FutureProvider.family<Exercise, String>((
  ref,
  id,
) {
  final repo = ref.watch(exerciseRepositoryProvider);
  return repo.fetchExercise(id);
});
