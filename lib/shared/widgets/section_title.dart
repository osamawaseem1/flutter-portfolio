import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String label;
  final String title;
  final String? subtitle;
  final CrossAxisAlignment alignment;

  const SectionTitle({
    super.key,
    required this.label,
    required this.title,
    this.subtitle,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.tagLabel,
          ),
        ),
        const SizedBox(height: 16),
        Text(title, style: AppTextStyles.headingLarge),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(subtitle!, style: AppTextStyles.bodyMedium),
        ],
      ],
    );
  }
}
