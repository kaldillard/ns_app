class ExerciseMedia {
  final String id;
  final String mediaType; // "image" or "video"
  final String url;
  final int sortOrder;

  ExerciseMedia({
    required this.id,
    required this.mediaType,
    required this.url,
    required this.sortOrder,
  });

  factory ExerciseMedia.fromJson(Map<String, dynamic> json) {
    return ExerciseMedia(
      id: json['id'] as String,
      mediaType: json['media_type'] as String,
      url: json['url'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  bool get isImage => mediaType == 'image';
  bool get isVideo => mediaType == 'video';
}

class Exercise {
  final String id;
  final String name;
  final String description;
  final String instructions;
  final String? category;
  final String? equipment;
  final List<String> tips;
  final List<String> tags;
  final List<ExerciseMedia> media;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.instructions,
    required this.category,
    required this.equipment,
    required this.tips,
    required this.tags,
    required this.media,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
      category: json['category'] as String?,
      equipment: json['equipment'] as String?,
      tips:
          (json['tips'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      tags:
          (json['tags'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      media:
          (json['media'] as List<dynamic>? ?? [])
              .map((m) => ExerciseMedia.fromJson(m as Map<String, dynamic>))
              .toList(),
    );
  }

  ExerciseMedia? get thumbnail {
    if (media.isEmpty) return null;
    final images = media.where((m) => m.isImage).toList();
    if (images.isNotEmpty) return images.first;
    return media.first;
  }
}
