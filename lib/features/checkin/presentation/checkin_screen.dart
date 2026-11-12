import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ns_app/core/theme/app_colors.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/brand_mark.dart';
import '../../../core/widgets/breathing_circle.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../exercises/presentation/exercise_detail_screen.dart';
import '../../exercises/presentation/widgets/exercise_card.dart';
import '../application/checkin_notifier.dart';
import '../application/checkin_state.dart';
import '../application/suggestion_service.dart';
import 'widgets/chip_selector.dart';

/// Icon per mood/time option, used by the vertical option-card list.
/// Purely cosmetic - lives in presentation, not application, so it can
/// change freely without touching check-in logic.
const _moodIcons = <String, IconData>{
  'Energetic': Icons.bolt_outlined,
  'Good': Icons.sentiment_satisfied_outlined,
  'Okay': Icons.sentiment_neutral_outlined,
  'Tired': Icons.bedtime_outlined,
  'Stressed': Icons.grain_outlined,
  'Sore': Icons.healing_outlined,
};

const _timeIcons = <String, IconData>{
  '5 min': Icons.timer_outlined,
  '15 min': Icons.schedule_outlined,
  '30+ min': Icons.hourglass_bottom_outlined,
};

class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkInNotifierProvider);
    final notifier = ref.read(checkInNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: switch (state.stage) {
          CheckInStage.form => _CheckInForm(state: state, notifier: notifier),
          CheckInStage.loading => const LoadingView(),
          CheckInStage.suggestions => _SuggestionsView(
            state: state,
            notifier: notifier,
          ),
          CheckInStage.error => ErrorView(
            message: "Something didn't go as expected:\n${state.errorMessage}",
            onRetry: notifier.reset,
          ),
        },
      ),
    );
  }
}

class _CheckInForm extends StatelessWidget {
  final CheckInState state;
  final CheckInNotifier notifier;

  const _CheckInForm({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const BrandMark(size: 30),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                ),
                child: Text(
                  'Serene Pulse',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.primaryStrong,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.outlineVariant),
              boxShadow: AppShadows.softTight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Home sanctuary',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'How are you feeling today?',
                  style: textTheme.displayLarge,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite_outline_rounded,
                      color: AppColors.primaryStrong,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Choose the tone that best matches your nervous system right now.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          Text(
            'Mood',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ChipSelector(
            options: moodOptions,
            selected: state.mood,
            onSelected: notifier.selectMood,
            icons: _moodIcons,
          ),
          const SizedBox(height: 24),

          Text(
            'Available time',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ChipSelector(
            options: timeOptions,
            selected: state.timeAvailable,
            onSelected: notifier.selectTime,
            icons: _timeIcons,
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: state.canSubmit ? notifier.submit : null,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Continue'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionsView extends StatelessWidget {
  final CheckInState state;
  final CheckInNotifier notifier;

  const _SuggestionsView({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (state.suggestions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BreathingCircle(size: 88),
              const SizedBox(height: AppDimens.spaceMd),
              Text(
                'No exercises yet \u2014 add some to your library first.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: AppDimens.spaceMd),
              OutlinedButton(
                onPressed: notifier.reset,
                child: const Text('Check in again'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceMd,
            AppDimens.spaceSm,
            AppDimens.spaceMd,
            AppDimens.spaceSm,
          ),
          child: Row(
            children: [
              const BrandMark(size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Feeling ${state.mood} \u00b7 ${state.timeAvailable}',
                  style: textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: notifier.reset,
                child: const Text('Check in again'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceXl),
            itemCount: state.suggestions.length,
            itemBuilder: (context, index) {
              final exercise = state.suggestions[index];
              return ExerciseCard(
                exercise: exercise,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => ExerciseDetailScreen(
                            exerciseId: exercise.id,
                            moodAtTheTime: state.mood,
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
