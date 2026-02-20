import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class TagChip extends StatelessWidget {
  final String label;
  final Color? color;

  const TagChip({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: chipColor.withOpacity(0.25), width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.tagLabel.copyWith(color: chipColor),
      ),
    );
  }
}
