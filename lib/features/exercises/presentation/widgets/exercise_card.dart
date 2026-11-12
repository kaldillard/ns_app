import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../data/exercise_model.dart';

/// A floating, softly-shadowed card for an exercise in a list. Pure UI,
/// no business logic - restyle freely without touching data/application.
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseCard({super.key, required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final thumb = exercise.thumbnail;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceXs,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          boxShadow: AppShadows.softTight,
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimens.radiusMedium),
                    bottomLeft: Radius.circular(AppDimens.radiusMedium),
                  ),
                  child: SizedBox(
                    width: 92,
                    height: 92,
                    child:
                        thumb != null && thumb.isImage
                            ? Image.network(
                              thumb.url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            )
                            : _placeholder(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceSm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          exercise.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (exercise.category != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            exercise.category!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        if (exercise.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            exercise.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.warmSand,
      child: const Icon(Icons.spa_outlined, color: AppColors.oliveGreen),
    );
  }
}
