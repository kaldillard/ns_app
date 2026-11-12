import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

/// A vertical list of selectable "radio cards" - icon, label, and a
/// trailing circular checkmark - matching the reference's option-list
/// pattern (e.g. "I wanna breathe better" / "I wanna live happier").
/// Selected state gets a light-green tint, green border, and filled
/// green checkmark. Pure presentation, no business logic - restyle
/// freely without touching anything else.
class ChipSelector extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  final Map<String, IconData>? icons;

  const ChipSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          options.map((option) {
            final isSelected = selected == option;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceSm),
              child: _OptionCard(
                label: option,
                icon: icons?[option] ?? Icons.circle_outlined,
                selected: isSelected,
                onTap: () => onSelected(option),
              ),
            );
          }).toList(),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: selected ? AppColors.primarySoft : AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: selected ? AppColors.primaryStrong : AppColors.outlineVariant,
          width: selected ? 1.2 : 1,
        ),
        boxShadow:
            selected
                ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.surface : AppColors.warmSand,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color:
                        selected
                            ? AppColors.primaryStrong
                            : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                _CheckCircle(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  final bool selected;
  const _CheckCircle({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primaryStrong : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.primaryStrong : AppColors.outline,
          width: 1.6,
        ),
      ),
      child:
          selected
              ? const Icon(Icons.check, size: 15, color: Colors.white)
              : null,
    );
  }
}
