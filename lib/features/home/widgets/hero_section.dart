import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/utils/cv_download.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onViewWork;

  const HeroSection({super.key, required this.onViewWork});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  int _titleIndex = 0;
  int _charCount = 0;
  bool _deleting = false;
  Timer? _typeTimer;
  bool _animationsPaused = false;

  String get _currentTitle => AppConstants.typewriterTitles[_titleIndex];
  String get _displayText => _currentTitle.substring(0, _charCount);

  @override
  void initState() {
    super.initState();
    _startTypewriter();
  }

  void _startTypewriter() {
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      if (!mounted) return;
      setState(() {
        if (!_deleting) {
          if (_charCount < _currentTitle.length) {
            _charCount++;
          } else {
            Future.delayed(const Duration(milliseconds: 1800), () {
              if (mounted) setState(() => _deleting = true);
            });
          }
        } else {
          if (_charCount > 0) {
            _charCount--;
          } else {
            _deleting = false;
            _titleIndex =
                (_titleIndex + 1) % AppConstants.typewriterTitles.length;
          }
        }
      });
    });
  }

  void _pauseAnimations() {
    if (_animationsPaused) return;
    _animationsPaused = true;
    _typeTimer?.cancel();
    _typeTimer = null;
  }

  void _resumeAnimations() {
    if (!_animationsPaused) return;
    _animationsPaused = false;
    _startTypewriter();
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppConstants.mobileBreakpoint;

    final screenHeight = MediaQuery.of(context).size.height;

    return VisibilityDetector(
      key: const Key('hero-section-visibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) {
          _pauseAnimations();
        } else {
          _resumeAnimations();
        }
      },
      child: Container(
      width: double.infinity,
      height: screenHeight,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: 100,
            ),
            child: isMobile
                ? _buildMobileLayout()
                : _buildDesktopLayout(),
          ),

          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: _ScrollIndicator(),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: _buildTextContent()),
        const SizedBox(width: 48),
        Expanded(flex: 4, child: _buildDeviceMockup()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    // Lay out content at a fixed reference width where the large heading fits
    // on one line, then FittedBox scales the whole block down to the actual
    // screen width — preventing mid-word character breaks.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 520,
        child: _buildTextContent(),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.smartphone, size: 13, color: AppColors.accent),
              const SizedBox(width: 6),
              Text(
                'Flutter & Mobile Expert',
                style: AppTextStyles.tagLabel,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0),

        const SizedBox(height: 24),

        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Building ',
                style: AppTextStyles.displayLarge,
              ),
              TextSpan(
                text: 'Digital\nExperiences',
                style: AppTextStyles.displayLarge.copyWith(
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [AppColors.accent, AppColors.accentCyan],
                    ).createShader(
                        const Rect.fromLTWH(0, 0, 400, 80)),
                ),
              ),
              TextSpan(
                text: ' for\nMobile',
                style: AppTextStyles.displayLarge,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 700.ms)
            .slideY(begin: 0.3, end: 0),

        const SizedBox(height: 20),

        Row(
          children: [
            Text(
              _displayText,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.accentCyan,
                fontWeight: FontWeight.w600,
              ),
            ),
            AnimatedOpacity(
              opacity: _deleting ? 0.3 : 1,
              duration: const Duration(milliseconds: 300),
              child: Text(
                '|',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

        const SizedBox(height: 16),

        Text(
          AppConstants.heroBio,
          style: AppTextStyles.bodyMedium,
        )
            .animate()
            .fadeIn(delay: 700.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 36),

        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            _PrimaryButton(
              label: 'View My Work',
              onTap: widget.onViewWork,
            ),
            _SecondaryButton(
              label: 'Download CV',
              onTap: downloadCv,
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 900.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 40),

        Row(
          children: [
            _SocialIcon(
              icon: Icons.code,
              tooltip: 'GitHub',
              url: AppConstants.github,
            ),
            const SizedBox(width: 16),
            _SocialIcon(
              icon: Icons.work,
              tooltip: 'LinkedIn',
              url: AppConstants.linkedin,
            ),
          ],
        ).animate().fadeIn(delay: 1100.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildDeviceMockup() {
    return _DeviceMockup()
        .animate()
        .fadeIn(delay: 600.ms, duration: 800.ms)
        .slideX(begin: 0.2, end: 0);
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withOpacity(0.04)
      ..strokeWidth = 1;

    const spacing = 90.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final dotPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    for (double x = 0; x < size.width; x += spacing * 4) {
      for (double y = 0; y < size.height; y += spacing * 4) {
        canvas.drawCircle(Offset(x, y), 2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DeviceMockup extends StatefulWidget {
  @override
  State<_DeviceMockup> createState() => _DeviceMockupState();
}

class _DeviceMockupState extends State<_DeviceMockup>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: child,
      ),
      child: Center(
        child: Container(
          width: 260,
          height: 480,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.card,
                AppColors.surface,
              ],
            ),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.15),
                blurRadius: 60,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: AppColors.accentCyan.withOpacity(0.08),
                blurRadius: 80,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: _buildAppPreview(),
          ),
        ),
      ),
    );
  }

  Widget _buildAppPreview() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1A2E), Color(0xFF0A0F1E)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('9:41', style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
                Row(
                  children: const [
                    Icon(Icons.signal_cellular_alt, size: 14, color: AppColors.textSecondary),
                    SizedBox(width: 4),
                    Icon(Icons.wifi, size: 14, color: AppColors.textSecondary),
                    SizedBox(width: 4),
                    Icon(Icons.battery_full, size: 14, color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.mosque, size: 18, color: AppColors.accent),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Masajidna', style: AppTextStyles.headingSmall.copyWith(fontSize: 14)),
                    Text('Mosque Finder', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.glassBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.search, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text('Find nearby mosques...', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _miniCard('Masjid Al-Noor', '2 min drive', Icons.location_on),
            const SizedBox(height: 8),
            _miniCard('Auckland Mosque', '5 min drive', Icons.location_on),
            const SizedBox(height: 8),
            _miniCard('Green Lane Masjid', '8 min drive', Icons.location_on),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statMini('Fajr', '5:42 AM'),
                _statMini('Dhuhr', '1:15 PM'),
                _statMini('Asr', '4:30 PM'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniCard(String name, String distance, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: AppColors.accent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textPrimary)),
                Text(distance, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _statMini(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.accentCyan, fontWeight: FontWeight.w600)),
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
      ],
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accent, Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.download, size: 16, color: AppColors.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final String url;
  const _SocialIcon({required this.icon, required this.tooltip, required this.url});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.url)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _hovered ? AppColors.accent.withOpacity(0.15) : AppColors.glassBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _hovered ? AppColors.accent.withOpacity(0.4) : AppColors.glassBorder,
              ),
            ),
            child: Icon(widget.icon, size: 18, color: _hovered ? AppColors.accent : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _ScrollIndicator extends StatefulWidget {
  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: child,
      ),
      child: Column(
        children: [
          Text('Scroll', style: AppTextStyles.bodySmall.copyWith(fontSize: 11, letterSpacing: 2)),
          const SizedBox(height: 6),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 20),
        ],
      ),
    );
  }
}
