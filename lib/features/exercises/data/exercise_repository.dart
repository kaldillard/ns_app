import '../../../core/network/api_client.dart';
import 'exercise_model.dart';

/// Data access for exercises. Only talks to [ApiClient] and returns
/// domain models - no Flutter/UI imports here, so this layer is fully
/// testable and reusable outside of widgets.
class ExerciseRepository {
  final ApiClient _client;

  ExerciseRepository(this._client);

  Future<List<Exercise>> fetchExercises({
    String? category,
    String? tag,
    String? search,
    int limit = 100,
  }) async {
    final params = <String, String>{'limit': '$limit'};
    if (category != null && category.isNotEmpty) params['category'] = category;
    if (tag != null && tag.isNotEmpty) params['tag'] = tag;
    if (search != null && search.isNotEmpty) params['search'] = search;

    final data = await _client.getList(
      '/api/v1/exercises',
      queryParameters: params,
    );
    return data
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Exercise> fetchExercise(String id) async {
    final data = await _client.getJson('/api/v1/exercises/$id');
    return Exercise.fromJson(data);
  }
}
