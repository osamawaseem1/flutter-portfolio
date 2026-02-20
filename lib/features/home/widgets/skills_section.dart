import 'dart:math' show min;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/animated_section.dart';

class _Skill {
  final String name;
  final String category;
  final IconData icon;
  final Color color;
  final double level; // 0.0 – 1.0
  const _Skill(this.name, this.category, this.icon, this.color, this.level);
}

// First 2 go in the right block next to Flutter; the rest fill the grid below.
const _skills = [
  _Skill('Firebase',        'Cloud',           Icons.whatshot_outlined,        Color(0xFFF6820D), 0.95),
  _Skill('Supabase',        'Database',        Icons.storage_outlined,         Color(0xFF3ECF8E), 0.75),
  _Skill('Figma',           'UI Design',       Icons.design_services_outlined, Color(0xFFFF7262), 0.80),
  _Skill('GraphQL',         'API',             Icons.account_tree_outlined,    Color(0xFFE10098), 0.70),
  _Skill('Go Router',       'Navigation',      Icons.route_outlined,           Color(0xFF54C5F8), 0.90),
  _Skill('Git & GitHub',    'Version Control', Icons.merge_type,               Color(0xFFF05032), 0.92),
  _Skill('REST API',        'Networking',      Icons.api_outlined,             Color(0xFF26C6DA), 0.88),
  _Skill('TypeScript',      'Backend',         Icons.code_outlined,            Color(0xFF3178C6), 0.70),
  _Skill('Cloud Functions', 'Serverless',      Icons.cloud_outlined,           Color(0xFFF6820D), 0.82),
  _Skill('App Store',       'Deployment',      Icons.store_outlined,           Color(0xFF2196F3), 0.85),
  _Skill('Hive / SQLite',   'Local Storage',   Icons.save_outlined,            Color(0xFFFFB300), 0.78),
  _Skill('Fastlane',        'CI / CD',         Icons.rocket_launch_outlined,   Color(0xFF8B5CF6), 0.65),
  _Skill('Unit Testing',    'Quality',         Icons.bug_report_outlined,      Color(0xFF66BB6A), 0.75),
  _Skill('Xcode',           'iOS',             Icons.phone_iphone_outlined,    Color(0xFF1575F9), 0.72),
];

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;

    return AnimatedSection(
      sectionKey: AppConstants.skillsSection,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 96,
          horizontal: isMobile ? 24 : 80,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              label: 'Tech Stack',
              title: 'Technical Arsenal',
              subtitle:
                  'The specialized tools and frameworks I use to engineer high-performance mobile experiences.',
            ),
            const SizedBox(height: 48),
            isMobile ? _buildMobile() : _buildDesktop(),
          ],
        ),
      ),
    );
  }

  //  col1     col2     col3     col4
  //  ┌────────────────┬────────────────┐   ─── bigH = cellH×2 + gap
  //  │                │  Dart  2w×1h   │   ─── cellH
  //  │  Flutter 2w×2h ├───────┬────────┤   ─── gap
  //  │                │ sk[0] │ sk[1]  │   ─── cellH
  //  ├───────┬────────┼───────┼────────┤
  //  │ sk[2] │ sk[3]  │ sk[4] │ sk[5]  │   ─── cellH rows below
  //  │  …    │   …    │   …   │   …    │
  //  └───────┴────────┴───────┴────────┘

  Widget _buildDesktop() {
    return LayoutBuilder(builder: (_, constraints) {
      const gap   = 14.0;
      const cellH = 132.0;
      final cellW = (constraints.maxWidth - 3 * gap) / 4;
      final bigW  = cellW * 2 + gap;
      final bigH  = cellH * 2 + gap;

      final rightSkills = _skills.take(2).toList();
      final gridSkills  = _skills.skip(2).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: bigW,
                height: bigH,
                child: const _FlutterCard(),
              ),
              const SizedBox(width: gap),
              SizedBox(
                width: bigW,
                child: Column(
                  children: [
                    SizedBox(
                      width: bigW,
                      height: cellH,
                      child: const _DartCard(),
                    ),
                    const SizedBox(height: gap),
                    Row(
                      children: [
                        SizedBox(
                          width: cellW,
                          height: cellH,
                          child: _SkillCard(skill: rightSkills[0]),
                        ),
                        const SizedBox(width: gap),
                        SizedBox(
                          width: cellW,
                          height: cellH,
                          child: _SkillCard(skill: rightSkills[1]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          ..._gridRows(gridSkills, cellW, cellH, gap),
        ],
      );
    });
  }

  List<Widget> _gridRows(
    List<_Skill> skills,
    double cellW,
    double cellH,
    double gap,
  ) {
    final rows = <Widget>[];
    for (int i = 0; i < skills.length; i += 4) {
      rows.add(SizedBox(height: gap));
      final slice = skills.sublist(i, min(i + 4, skills.length));
      rows.add(Row(
        children: List.generate(4, (j) {
          return [
            if (j > 0) SizedBox(width: gap),
            SizedBox(
              width: cellW,
              height: cellH,
              child: j < slice.length
                  ? _SkillCard(skill: slice[j])
                  : const SizedBox(),
            ),
          ];
        }).expand((e) => e).toList(),
      ));
    }
    return rows;
  }

  Widget _buildMobile() {
    return Column(
      children: [
        const _FlutterCard(),
        const SizedBox(height: 14),
        const _DartCard(),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 120,
          ),
          itemCount: _skills.length,
          itemBuilder: (_, i) => _SkillCard(skill: _skills[i]),
        ),
      ],
    );
  }
}

class _FlutterCard extends StatefulWidget {
  const _FlutterCard();
  @override
  State<_FlutterCard> createState() => _FlutterCardState();
}

class _FlutterCardState extends State<_FlutterCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.flutterBlue.withOpacity(0.06) : AppColors.glassBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? AppColors.flutterBlue.withOpacity(0.3) : AppColors.glassBorder,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.flutterBlue.withOpacity(0.08), blurRadius: 24)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.flutterBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.flutter_dash, size: 26, color: AppColors.flutterBlue),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Flutter',
                    style:
                        AppTextStyles.headingMedium.copyWith(fontSize: 22)),
                const SizedBox(width: 10),
                _Badge(label: 'Framework of Choice', color: AppColors.flutterBlue),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Building beautiful, natively compiled applications from a single codebase. Expert in custom widgets, complex animations, and deep platform integration.',
              style: AppTextStyles.bodySmall.copyWith(height: 1.7),
            ),
            const Spacer(),
            _Bar(label: 'BLoC', level: 0.85, color: const Color(0xFF8B5CF6)),
            const SizedBox(height: 12),
            _Bar(label: 'Riverpod', level: 1.0, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}

class _DartCard extends StatefulWidget {
  const _DartCard();
  @override
  State<_DartCard> createState() => _DartCardState();
}

class _DartCardState extends State<_DartCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    const dartBlue = Color(0xFF00B4FF);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: _hovered ? dartBlue.withOpacity(0.06) : AppColors.glassBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? dartBlue.withOpacity(0.3) : AppColors.glassBorder,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: dartBlue.withOpacity(0.08), blurRadius: 20)]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: dartBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.code, size: 22, color: dartBlue),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('Dart',
                          style: AppTextStyles.headingSmall
                              .copyWith(fontSize: 20)),
                      const SizedBox(width: 10),
                      _Badge(label: 'Language · Expert', color: dartBlue),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Type-safe language powering Flutter. Expert in async, generics, isolates, and null safety.',
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            _Ring(level: 1.0, color: dartBlue),
          ],
        ),
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final _Skill skill;
  const _SkillCard({required this.skill});
  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final skill = widget.skill;
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _hovered ? skill.color.withOpacity(0.06) : AppColors.glassBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered ? skill.color.withOpacity(0.28) : AppColors.glassBorder,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: skill.color.withOpacity(0.07), blurRadius: 14)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: skill.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(skill.icon, size: 16, color: skill.color),
                ),
                const Spacer(),
                Text(
                  '${(skill.level * 100).round()}%',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: skill.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              skill.name,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              skill.category,
              style: AppTextStyles.labelMedium
                  .copyWith(fontSize: 10, color: AppColors.textMuted),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: skill.level,
                minHeight: 4,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation(skill.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: AppTextStyles.labelMedium.copyWith(color: color, fontSize: 10)),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double level;
  final Color color;
  const _Bar({required this.label, required this.level, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.labelMedium
                .copyWith(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: level,
            minHeight: 4,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _Ring extends StatelessWidget {
  final double level;
  final Color color;
  const _Ring({required this.level, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: level,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(color),
            strokeWidth: 3,
            strokeCap: StrokeCap.round,
          ),
          Text(
            '${(level * 100).round()}%',
            style: AppTextStyles.labelMedium
                .copyWith(color: color, fontSize: 9, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
