import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/utils/cv_download.dart';

class PortfolioNavbar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;

  const PortfolioNavbar({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  State<PortfolioNavbar> createState() => _PortfolioNavbarState();
}

class _PortfolioNavbarState extends State<PortfolioNavbar> {
  bool _scrolled = false;
  String _activeSection = AppConstants.heroSection;

  // The nav items map label → section key (only the ones shown in the navbar)
  static const _navSections = [
    AppConstants.projectsSection,
    AppConstants.skillsSection,
    AppConstants.aboutSection,
    AppConstants.contactSection,
  ];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = widget.scrollController.offset > 40;

    // Determine which section is currently in view
    String active = AppConstants.heroSection;
    for (final section in widget.sectionKeys.keys) {
      final key = widget.sectionKeys[section];
      if (key?.currentContext != null) {
        final box = key!.currentContext!.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;
        if (position <= 150) active = section;
      }
    }

    if (scrolled != _scrolled || active != _activeSection) {
      setState(() {
        _scrolled = scrolled;
        _activeSection = active;
      });
    }
  }

  void _scrollTo(String section) {
    final key = widget.sectionKeys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppConstants.mobileBreakpoint;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 70,
      decoration: BoxDecoration(
        color: _scrolled
            ? AppColors.background.withOpacity(0.9)
            : Colors.transparent,
        border: _scrolled
            ? Border(
                bottom: BorderSide(
                  color: AppColors.glassBorder,
                  width: 1,
                ),
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 48,
        ),
        child: Row(
          children: [
            Text(
              'Osama Soliman',
              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),

            const Spacer(),

            if (!isMobile) ...[
              _NavItem(
                  label: 'Work',
                  isActive: _activeSection == AppConstants.projectsSection,
                  onTap: () => _scrollTo(AppConstants.projectsSection)),
              const SizedBox(width: 32),
              _NavItem(
                  label: 'Tech Stack',
                  isActive: _activeSection == AppConstants.skillsSection,
                  onTap: () => _scrollTo(AppConstants.skillsSection)),
              const SizedBox(width: 32),
              _NavItem(
                  label: 'About',
                  isActive: _activeSection == AppConstants.aboutSection,
                  onTap: () => _scrollTo(AppConstants.aboutSection)),
              const SizedBox(width: 32),
              _NavItem(
                  label: 'Contact',
                  isActive: _activeSection == AppConstants.contactSection,
                  onTap: () => _scrollTo(AppConstants.contactSection)),
              const SizedBox(width: 40),
            ],

            if (!isMobile) ...[
              _AvailableBadge(),
              const SizedBox(width: 16),
            ],

            _ResumeButton(),

            if (isMobile) ...[
              const SizedBox(width: 12),
              _MobileMenuButton(
                sectionKeys: widget.sectionKeys,
                onTap: _scrollTo,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _NavItem({required this.label, this.isActive = false, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: AppTextStyles.navLabel.copyWith(
            color: active
                ? AppColors.accent
                : _hovered
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _AvailableBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.green.withOpacity(0.6),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Available for hire',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.green,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumeButton extends StatefulWidget {
  @override
  State<_ResumeButton> createState() => _ResumeButtonState();
}

class _ResumeButtonState extends State<_ResumeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: downloadCv,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.accent,
              width: 1.5,
            ),
          ),
          child: Text(
            'Resume',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final Map<String, GlobalKey> sectionKeys;
  final Function(String) onTap;

  const _MobileMenuButton({
    required this.sectionKeys,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showMenu(context),
      icon: const Icon(Icons.menu, color: AppColors.textPrimary),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuItem(ctx, 'Work', AppConstants.projectsSection),
            _menuItem(ctx, 'Tech Stack', AppConstants.skillsSection),
            _menuItem(ctx, 'About', AppConstants.aboutSection),
            _menuItem(ctx, 'Contact', AppConstants.contactSection),
            const SizedBox(height: 8),
            _AvailableBadge(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext ctx, String label, String section) {
    return ListTile(
      title: Text(
        label,
        style: AppTextStyles.headingSmall.copyWith(fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 14, color: AppColors.textSecondary),
      onTap: () {
        Navigator.pop(ctx);
        onTap(section);
      },
    );
  }
}
