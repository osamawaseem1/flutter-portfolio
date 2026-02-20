import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/animated_section.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppConstants.mobileBreakpoint;

    return AnimatedSection(
      sectionKey: AppConstants.aboutSection,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 96,
          horizontal: isMobile ? 24 : 80,
        ),
        child: isMobile ? _buildMobile() : _buildDesktop(),
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _buildPhoto()),
        const SizedBox(width: 64),
        Expanded(flex: 6, child: _buildContent()),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        Center(child: _buildPhoto()),
        const SizedBox(height: 40),
        _buildContent(),
      ],
    );
  }

  Widget _buildPhoto() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.35),
                blurRadius: 48,
                spreadRadius: 12,
              ),
              BoxShadow(
                color: AppColors.accent.withOpacity(0.15),
                blurRadius: 80,
                spreadRadius: 20,
              ),
            ],
          ),
        ),
        Container(
          width: 184,
          height: 184,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accent,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.4),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          label: 'About',
          title: 'Engineering precision.\nCreative soul.',
        ),
        const SizedBox(height: 20),

        Text(AppConstants.aboutBio, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 28),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _StatusBadge(label: 'Open to Work', color: AppColors.green),
            _StatusBadge(label: 'Available Freelance', color: AppColors.accent),
            _StatusBadge(label: 'Remote-friendly', color: AppColors.flutterBlue),
          ],
        ),

        const SizedBox(height: 32),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppConstants.funFacts.map((f) {
            return GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              borderRadius: 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(f['icon']!, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(f['label']!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 32),

        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 16, color: AppColors.accent),
            const SizedBox(width: 6),
            Text(
              '${AppConstants.location} — Open to Remote Worldwide',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
