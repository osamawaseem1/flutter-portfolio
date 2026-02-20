import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

class PortfolioFooter extends StatelessWidget {
  const PortfolioFooter({super.key});

  void _scrollToTop(BuildContext context) {
    final scrollable = Scrollable.maybeOf(context);
    scrollable?.position.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 28,
        horizontal: isMobile ? 24 : 80,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeft(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildSocialLinks(),
                    const Spacer(),
                    _BackToTop(onTap: () => _scrollToTop(context)),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                _buildLeft(),
                const Spacer(),
                _buildSocialLinks(),
                const SizedBox(width: 24),
                _BackToTop(onTap: () => _scrollToTop(context)),
              ],
            ),
    );
  }

  Widget _buildLeft() {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
        children: [
          TextSpan(
            text: '${AppConstants.name} · ',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const TextSpan(text: 'Built with Flutter Web & '),
          const TextSpan(text: '❤️', style: TextStyle(fontSize: 12)),
          const TextSpan(text: ' · © 2026'),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FooterIcon(
          icon: Icons.code,
          tooltip: 'GitHub',
          url: AppConstants.github,
        ),
        const SizedBox(width: 8),
        _FooterIcon(
          icon: Icons.work_outline,
          tooltip: 'LinkedIn',
          url: AppConstants.linkedin,
        ),
      ],
    );
  }
}

class _FooterIcon extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final String url;
  const _FooterIcon({required this.icon, required this.tooltip, required this.url});

  @override
  State<_FooterIcon> createState() => _FooterIconState();
}

class _FooterIconState extends State<_FooterIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.url)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _hovered ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _hovered ? AppColors.accent.withOpacity(0.3) : AppColors.glassBorder,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 15,
              color: _hovered ? AppColors.accent : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackToTop extends StatefulWidget {
  final VoidCallback onTap;
  const _BackToTop({required this.onTap});

  @override
  State<_BackToTop> createState() => _BackToTopState();
}

class _BackToTopState extends State<_BackToTop> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accent.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? AppColors.accent.withOpacity(0.3) : AppColors.glassBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.keyboard_arrow_up,
                size: 14,
                color: _hovered ? AppColors.accent : AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                'Top',
                style: AppTextStyles.labelMedium.copyWith(
                  fontSize: 12,
                  color: _hovered ? AppColors.accent : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
