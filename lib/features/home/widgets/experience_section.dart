import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/animated_section.dart';

class _ExperienceData {
  final String role;
  final String company;
  final String period;
  final String type;
  final List<String> bullets;
  final IconData icon;
  final Color color;

  const _ExperienceData({
    required this.role,
    required this.company,
    required this.period,
    required this.type,
    required this.bullets,
    required this.icon,
    required this.color,
  });
}

const _experiences = [
  _ExperienceData(
    role: 'Flutter Developer',
    company: 'Halal Kiwi',
    period: 'Jan 2023 – Present',
    type: 'Full-time',
    bullets: [
      'Redesigned the app\'s UI end to end — identified the need, planned the design, and delivered it without being directed',
      'Added fuzzy search which improved search experience that made finding listings faster and more intuitive',
      'Reduced Firestore database read costs by reworking how data was structured and fetched, improving app load times',
    ],
    icon: Icons.restaurant,
    color: AppColors.green,
  ),
  _ExperienceData(
    role: 'Mobile Lead',
    company: 'Masajidna (Personal Project)',
    period: 'Nov 2025 – Feb 2026',
    type: 'Personal Project',
    bullets: [
      'Built a "Catch Prayer" feature that finds mosques a user can reach before prayer starts using Google Distance Matrix API',
      'Designed the Firestore data model from scratch — embedded prayer times in the mosque document to minimise read costs',
      'Added offline-first architecture using Firestore persistence to reduce repeat reads for returning users',
      'Secured the platform with Firebase App Check, rate limiting, and query size restrictions',
    ],
    icon: Icons.mosque,
    color: AppColors.accent,
  ),
  _ExperienceData(
    role: 'Flutter Student',
    company: 'TG Academy',
    period: 'Aug 2021 – Oct 2022',
    type: 'Education',
    bullets: [
      'Completed a structured, full-year Flutter & Dart program covering fundamentals through advanced development',
      'Built multiple training projects during and after the course to deepen practical skills',
    ],
    icon: Icons.school,
    color: AppColors.flutterBlue,
  ),
];

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;

    return AnimatedSection(
      sectionKey: AppConstants.experienceSection,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 96,
          horizontal: isMobile ? 24 : 80,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              label: 'Experience',
              title: 'My Journey',
            ),
            const SizedBox(height: 56),
            _buildTimeline(isMobile),
            const SizedBox(height: 56),
            _buildEducation(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(bool isMobile) {
    return Column(
      children: _experiences.asMap().entries.map((entry) {
        return _TimelineItem(
          experience: entry.value,
          isLast: entry.key == _experiences.length - 1,
        );
      }).toList(),
    );
  }

  Widget _buildEducation(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Education', style: AppTextStyles.headingSmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 24),
        isMobile
            ? Column(
                children: [
                  _EducationCard(
                    degree: 'Bachelor of Computer Science',
                    school: 'Auckland University of Technology (AUT)',
                    period: '2025 – 2028 (in progress)',
                    icon: Icons.school_outlined,
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: 16),
                  _EducationCard(
                    degree: 'Flutter Development Program',
                    school: 'TG Academy',
                    period: 'Aug 2021 – Oct 2022',
                    icon: Icons.flutter_dash,
                    color: AppColors.flutterBlue,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _EducationCard(
                      degree: 'Bachelor of Computer and Information Sciences',
                      school: 'Auckland University of Technology (AUT)',
                      period: 'Jul 2024 – Present',
                      icon: Icons.school_outlined,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _EducationCard(
                      degree: 'Flutter Development Program',
                      school: 'TG Academy',
                      period: 'Aug 2021 – Oct 2022',
                      icon: Icons.flutter_dash,
                      color: AppColors.flutterBlue,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final _ExperienceData experience;
  final bool isLast;
  const _TimelineItem({required this.experience, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: experience.color.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: experience.color.withOpacity(0.4), width: 1.5),
                  ),
                  child: Icon(experience.icon, size: 18, color: experience.color),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: AppColors.divider,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(experience.role, style: AppTextStyles.headingSmall),
                            const SizedBox(height: 4),
                            Text(experience.company, style: AppTextStyles.bodyMedium.copyWith(color: experience.color)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(experience.period, style: AppTextStyles.labelMedium),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: experience.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              experience.type,
                              style: AppTextStyles.labelMedium.copyWith(color: experience.color, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...experience.bullets.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: experience.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(b, style: AppTextStyles.bodySmall),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  final String degree;
  final String school;
  final String period;
  final IconData icon;
  final Color color;
  const _EducationCard({
    required this.degree,
    required this.school,
    required this.period,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(degree, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(school, style: AppTextStyles.bodySmall.copyWith(color: color)),
                const SizedBox(height: 2),
                Text(period, style: AppTextStyles.labelMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
