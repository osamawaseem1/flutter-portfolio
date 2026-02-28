import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/animated_section.dart';

class _ProjectData {
  final String name;
  final String description;
  final String statusBadge;
  final String? starLabel;
  final List<String> tags;
  final IconData icon;
  final Color accentColor;
  final String? githubUrl;
  final String? liveUrl;
  final bool featured;

  const _ProjectData({
    required this.name,
    required this.description,
    required this.statusBadge,
    this.starLabel,
    required this.tags,
    required this.icon,
    required this.accentColor,
    this.githubUrl,
    this.liveUrl,
    this.featured = false,
  });
}

const _projects = [
  _ProjectData(
    name: 'Masajidna',
    description:
        'A full-stack mosque management platform across three Flutter apps — admin panel, community app, and mosque display screen. Firebase backend with offline-first persistence and a proximity-based prayer finder using Google Distance Matrix API.',
    statusBadge: 'COMPLETED',
    starLabel: '★ Featured',
    tags: ['Flutter', 'Firebase', 'Riverpod', 'Go Router', 'Cloud Functions'],
    icon: Icons.mosque,
    accentColor: AppColors.accent,
    featured: true,
  ),
  _ProjectData(
    name: 'Halal Kiwi',
    description:
        "NZ's leading Muslim directory app. Halal restaurants, barcode scanner, mosques & businesses.",
    statusBadge: 'LIVE',
    starLabel: '★ 4.8',
    tags: ['Flutter', 'Firebase', 'Riverpod'],
    icon: Icons.restaurant,
    accentColor: Color(0xFF48BB78),
    liveUrl: 'https://apps.apple.com/nz/app/halal-kiwi/id6444034060',
  ),
  _ProjectData(
    name: 'This Portfolio',
    description:
        'Built with Flutter Web. Every pixel crafted in Flutter, deployed on Firebase.',
    statusBadge: 'WEB',
    starLabel: null,
    tags: ['Flutter Web', 'Riverpod', 'Go Router'],
    icon: Icons.web,
    accentColor: Color(0xFF54C5F8),
    githubUrl: AppConstants.github,
  ),
];

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return AnimatedSection(
      sectionKey: AppConstants.projectsSection,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 96,
          horizontal: isMobile ? 24 : 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(
                  child: SectionTitle(
                    label: 'Projects',
                    title: 'Selected Works',
                    subtitle: 'Projects built from scratch, in production.',
                  ),
                ),
                if (!isMobile) _ViewAllButton(),
              ],
            ),
            const SizedBox(height: 48),

            _FeaturedProjectCard(project: _projects.first),
            const SizedBox(height: 20),

            isMobile
                ? Column(
                    children: _projects
                        .skip(1)
                        .map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _ProjectCard(project: p),
                            ))
                        .toList(),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _projects.skip(1).expand((project) {
                      return [
                        Expanded(child: _ProjectCard(project: project)),
                        if (project != _projects.last) const SizedBox(width: 20),
                      ];
                    }).toList(),
                  ),

            if (isMobile) ...[
              const SizedBox(height: 24),
              Center(child: _ViewAllButton()),
            ],
          ],
        ),
      ),
    );
  }
}

class _ViewAllButton extends StatefulWidget {
  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(AppConstants.github)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.bodySmall.copyWith(
                color: _hovered ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              child: const Text('View all projects'),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.arrow_forward,
              size: 14,
              color: _hovered ? AppColors.accent : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedProjectCard extends StatefulWidget {
  final _ProjectData project;
  const _FeaturedProjectCard({required this.project});

  @override
  State<_FeaturedProjectCard> createState() => _FeaturedProjectCardState();
}

class _FeaturedProjectCardState extends State<_FeaturedProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final isMobile = MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.identity()
          ..translate(0.0, _hovered ? -4.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? project.accentColor.withOpacity(0.5)
                : AppColors.glassBorder,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: project.accentColor.withOpacity(0.12),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: isMobile
              ? _buildMobile(project)
              : _buildDesktop(project),
        ),
      ),
    );
  }

  Widget _buildDesktop(_ProjectData p) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 55, child: _buildLeft(p)),
          const SizedBox(width: 32),
          Expanded(flex: 45, child: _UIMockupPanel(accentColor: p.accentColor)),
        ],
      ),
    );
  }

  Widget _buildMobile(_ProjectData p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLeft(p),
        const SizedBox(height: 24),
        SizedBox(height: 180, child: _UIMockupPanel(accentColor: p.accentColor)),
      ],
    );
  }

  Widget _buildLeft(_ProjectData p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _StatusBadge(
              label: p.statusBadge,
              color: const Color(0xFF48BB78),
            ),
            if (p.starLabel != null) ...[
              const SizedBox(width: 8),
              _StatusBadge(
                label: p.starLabel!,
                color: Colors.amber,
              ),
            ],
          ],
        ),
        const SizedBox(height: 18),

        Text(p.name, style: AppTextStyles.headingMedium.copyWith(fontSize: 28)),
        const SizedBox(height: 12),

        Text(
          p.description,
          style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
        ),
        const SizedBox(height: 20),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: p.tags.map((t) => _TagChip(label: t)).toList(),
        ),
        const SizedBox(height: 28),

        Row(
          children: [
            _OutlinedActionButton(
              label: 'View Project',
              onTap: p.liveUrl != null
                  ? () => launchUrl(Uri.parse(p.liveUrl!))
                  : null,
            ),
            const SizedBox(width: 10),
            _CodeIconButton(
              onTap: p.githubUrl != null
                  ? () => launchUrl(Uri.parse(p.githubUrl!))
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _UIMockupPanel extends StatelessWidget {
  final Color accentColor;
  const _UIMockupPanel({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF050810),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Window chrome dots
          Row(
            children: const [
              _WinDot(color: Color(0xFFFF5F57)),
              SizedBox(width: 6),
              _WinDot(color: Color(0xFFFFBD2E)),
              SizedBox(width: 6),
              _WinDot(color: Color(0xFF28CA41)),
            ],
          ),
          const SizedBox(height: 14),
          // Navbar skeleton
          _SkeletonBar(widthFactor: 1.0, height: 8, delay: 0, accentColor: accentColor),
          const SizedBox(height: 12),
          // Two cards
          Row(
            children: [
              Expanded(child: _SkeletonCard(delay: 200, accentColor: accentColor)),
              const SizedBox(width: 8),
              Expanded(child: _SkeletonCard(delay: 400, accentColor: accentColor)),
            ],
          ),
          const SizedBox(height: 12),
          // Text lines
          _SkeletonBar(widthFactor: 0.85, height: 6, delay: 600, accentColor: accentColor),
          const SizedBox(height: 7),
          _SkeletonBar(widthFactor: 0.65, height: 6, delay: 800, accentColor: accentColor),
          const SizedBox(height: 7),
          _SkeletonBar(widthFactor: 0.45, height: 6, delay: 1000, accentColor: accentColor),
          const Spacer(),
          // Buttons
          Row(
            children: [
              _SkeletonBtn(delay: 1200, accentColor: accentColor),
              const SizedBox(width: 8),
              _SkeletonBtn(delay: 1400, accentColor: accentColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _WinDot extends StatelessWidget {
  final Color color;
  const _WinDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  final double widthFactor;
  final double height;
  final int delay;
  final Color accentColor;
  const _SkeletonBar({
    required this.widthFactor,
    required this.height,
    required this.delay,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth * widthFactor,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF0E0F20),
            borderRadius: BorderRadius.circular(4),
          ),
        )
            .animate(onPlay: (c) => c.repeat(), delay: Duration(milliseconds: delay))
            .shimmer(duration: 1800.ms, color: accentColor.withOpacity(0.12));
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final int delay;
  final Color accentColor;
  const _SkeletonCard({required this.delay, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0F20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF161728),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 6,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF161728),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat(), delay: Duration(milliseconds: delay))
        .shimmer(duration: 1800.ms, color: accentColor.withOpacity(0.12));
  }
}

class _SkeletonBtn extends StatelessWidget {
  final int delay;
  final Color accentColor;
  const _SkeletonBtn({required this.delay, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF0E0F20),
        borderRadius: BorderRadius.circular(6),
      ),
    )
        .animate(onPlay: (c) => c.repeat(), delay: Duration(milliseconds: delay))
        .shimmer(duration: 1800.ms, color: accentColor.withOpacity(0.12));
  }
}

class _ProjectCard extends StatefulWidget {
  final _ProjectData project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.identity()
          ..translate(0.0, _hovered ? -4.0 : 0.0, 0.0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? project.accentColor.withOpacity(0.4)
                : AppColors.glassBorder,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: project.accentColor.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 3,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: project.accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(project.icon, size: 20, color: project.accentColor),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusBadge(label: project.statusBadge, color: project.accentColor),
                    if (project.starLabel != null) ...[
                      const SizedBox(height: 4),
                      _StatusBadge(label: project.starLabel!, color: Colors.amber),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(project.name,
                style: AppTextStyles.headingSmall.copyWith(fontSize: 17)),
            const SizedBox(height: 8),

            Text(
              project.description,
              style: AppTextStyles.bodySmall.copyWith(height: 1.6),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: project.tags.take(3).map((t) => _TagChip(label: t)).toList(),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                if (project.githubUrl != null)
                  _SmallIconButton(
                    icon: Icons.code,
                    onTap: () => launchUrl(Uri.parse(project.githubUrl!)),
                    hovered: _hovered,
                    color: project.accentColor,
                  ),
                if (project.liveUrl != null) ...[
                  if (project.githubUrl != null) const SizedBox(width: 8),
                  _SmallIconButton(
                    icon: Icons.open_in_new,
                    onTap: () => launchUrl(Uri.parse(project.liveUrl!)),
                    hovered: _hovered,
                    color: project.accentColor,
                  ),
                ],
                const Spacer(),
                Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: _hovered ? project.accentColor : AppColors.textMuted,
                ),
              ],
            ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _OutlinedActionButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  const _OutlinedActionButton({required this.label, this.onTap});

  @override
  State<_OutlinedActionButton> createState() => _OutlinedActionButtonState();
}

class _OutlinedActionButtonState extends State<_OutlinedActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.textPrimary.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward, size: 13, color: AppColors.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeIconButton extends StatefulWidget {
  final VoidCallback? onTap;
  const _CodeIconButton({this.onTap});

  @override
  State<_CodeIconButton> createState() => _CodeIconButtonState();
}

class _CodeIconButtonState extends State<_CodeIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? AppColors.accent.withOpacity(0.4) : AppColors.glassBorder,
            ),
          ),
          child: Icon(
            Icons.code,
            size: 16,
            color: _hovered ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hovered;
  final Color color;
  const _SmallIconButton({
    required this.icon,
    required this.onTap,
    required this.hovered,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: hovered ? color.withOpacity(0.1) : AppColors.glassBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hovered ? color.withOpacity(0.4) : AppColors.glassBorder,
          ),
        ),
        child: Icon(icon, size: 14, color: hovered ? color : AppColors.textSecondary),
      ),
    );
  }
}
