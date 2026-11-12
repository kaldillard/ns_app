import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../tracking/application/tracking_notifier.dart';
import '../application/exercise_providers.dart';
import '../data/exercise_model.dart';
import 'widgets/media_carousel.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;
  final String? moodAtTheTime;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    this.moodAtTheTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncExercise = ref.watch(exerciseDetailProvider(exerciseId));

    return Scaffold(
      appBar: AppBar(title: Text(asyncExercise.value?.name ?? 'Exercise')),
      body: asyncExercise.when(
        data:
            (exercise) => _ExerciseDetailBody(
              exercise: exercise,
              moodAtTheTime: moodAtTheTime,
            ),
        loading: () => const LoadingView(),
        error:
            (e, st) => ErrorView(
              message: 'Failed to load: $e',
              onRetry: () => ref.invalidate(exerciseDetailProvider(exerciseId)),
            ),
      ),
    );
  }
}

class _ExerciseDetailBody extends ConsumerStatefulWidget {
  final Exercise exercise;
  final String? moodAtTheTime;

  const _ExerciseDetailBody({required this.exercise, this.moodAtTheTime});

  @override
  ConsumerState<_ExerciseDetailBody> createState() =>
      _ExerciseDetailBodyState();
}

class _ExerciseDetailBodyState extends ConsumerState<_ExerciseDetailBody> {
  bool _markedDone = false;

  Future<void> _markAsDone() async {
    await ref
        .read(trackingNotifierProvider.notifier)
        .addCompletedExercise(
          exerciseId: widget.exercise.id,
          exerciseName: widget.exercise.name,
          moodAtTheTime: widget.moodAtTheTime,
        );
    if (!mounted) return;
    setState(() => _markedDone = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Nice work! Logged to your history.'),
        backgroundColor: AppColors.oliveGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd,
        AppDimens.spaceSm,
        AppDimens.spaceMd,
        AppDimens.spaceXl,
      ),
      children: [
        if (ex.media.isNotEmpty) MediaCarousel(media: ex.media),
        if (ex.media.isNotEmpty) const SizedBox(height: AppDimens.spaceMd),
        Wrap(
          spacing: AppDimens.spaceXs,
          children: [
            if (ex.category != null) Chip(label: Text(ex.category!)),
            if (ex.equipment != null)
              Chip(label: Text('Equipment: ${ex.equipment}')),
          ],
        ),
        const SizedBox(height: AppDimens.spaceSm),
        if (ex.description.isNotEmpty) ...[
          Text(ex.description, style: textTheme.bodyLarge),
          const SizedBox(height: AppDimens.spaceMd),
        ],
        if (ex.instructions.isNotEmpty) ...[
          Text('Instructions', style: textTheme.titleLarge),
          const SizedBox(height: AppDimens.spaceXs),
          Text(ex.instructions, style: textTheme.bodyLarge),
          const SizedBox(height: AppDimens.spaceMd),
        ],
        if (ex.tips.isNotEmpty) ...[
          Text('Tips', style: textTheme.titleLarge),
          const SizedBox(height: AppDimens.spaceXs),
          ...ex.tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.circle,
                    size: 6,
                    color: AppColors.oliveGreen,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(tip, style: textTheme.bodyMedium)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),
        ],
        if (ex.tags.isNotEmpty) ...[
          Wrap(
            spacing: AppDimens.spaceXs,
            runSpacing: AppDimens.spaceXs,
            children:
                ex.tags
                    .map(
                      (t) => Chip(
                        label: Text(t, style: textTheme.bodySmall),
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: AppDimens.spaceLg),
        ],
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _markedDone ? null : _markAsDone,
            icon: Icon(_markedDone ? Icons.check : Icons.check_circle_outline),
            label: Text(_markedDone ? 'Marked as done' : 'Mark as done'),
          ),
        ),
      ],
    );
  }
}
