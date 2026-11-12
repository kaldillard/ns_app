import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../application/exercise_providers.dart';
import 'exercise_detail_screen.dart';
import 'widgets/exercise_card.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  final _searchController = TextEditingController();
  String _search = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() => _search = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = (
      category: null,
      tag: null,
      search: _search.isEmpty ? null : _search,
    );
    final asyncExercises = ref.watch(exerciseListProvider(query));

    return Scaffold(
      body: SafeArea(
        child: asyncExercises.when(
          data: (exercises) {
            final visibleExercises = exercises;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    children: [
                      const Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.02,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F1EC),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Sanctuary',
                          style: TextStyle(
                            color: Color(0xFF476557),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search exercises...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0EC),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0xFFE7E3DE)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A1A1C1A),
                              blurRadius: 18,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCEDE4),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: const Icon(
                                Icons.air_rounded,
                                size: 32,
                                color: Color(0xFF476557),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Daily reset',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Breathing cues for a calmer nervous system.',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Quick picks',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      if (visibleExercises.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Text(
                              'No exercises found.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        )
                      else
                        ...List.generate(visibleExercises.length, (index) {
                          final exercise = visibleExercises[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppDimens.spaceSm),
                            child: ExerciseCard(
                              exercise: exercise,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ExerciseDetailScreen(
                                          exerciseId: exercise.id,
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const LoadingView(),
          error:
              (e, st) => ErrorView(
                message: "Couldn't load exercises:\n$e",
                onRetry: () => ref.invalidate(exerciseListProvider(query)),
              ),
        ),
      ),
    );
  }
}
