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
        Expanded(flex: 6, child: Center(child: _buildTextContent())),
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
      mainAxisSize: MainAxisSize.min,
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
    return _CodeWindowsMockup()
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

class _CodeWindowsMockup extends StatefulWidget {
  @override
  State<_CodeWindowsMockup> createState() => _CodeWindowsMockupState();
}

class _CodeWindowsMockupState extends State<_CodeWindowsMockup>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  // Syntax highlight colours
  static const _kw  = Color(0xFFC792EA); // keywords
  static const _str = Color(0xFFC3E88D); // strings
  static const _cls = Color(0xFF82AAFF); // types / class names
  static const _num = Color(0xFFF78C6C); // numbers / hex
  static const _cmt = Color(0xFF546E7A); // comments
  static const _def = Color(0xFFCDD3DE); // default text
  static const _dec = Color(0xFF89DDFF); // decorators

  TextSpan _ts(String t, Color c) =>
      TextSpan(text: t, style: TextStyle(color: c));

  Widget _cl(List<TextSpan> spans) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              height: 1.6,
            ),
            children: spans,
          ),
        ),
      );

  Widget _blank() => const SizedBox(height: 4);

  @override
  Widget build(BuildContext context) {
    final mainLines = [
      _cl([_ts('import ', _kw), _ts("'package:flutter/material.dart'", _str), _ts(';', _def)]),
      _blank(),
      _cl([_ts('void ', _kw), _ts('main', _cls), _ts('() => ', _def), _ts('runApp', _cls), _ts('(', _def), _ts('const ', _kw), _ts('App', _cls), _ts('());', _def)]),
      _blank(),
      _cl([_ts('class ', _kw), _ts('App ', _cls), _ts('extends ', _kw), _ts('StatelessWidget ', _cls), _ts('{', _def)]),
      _cl([_ts('  ', _def), _ts('@override', _dec)]),
      _cl([_ts('  ', _def), _ts('Widget ', _cls), _ts('build', _cls), _ts('(', _def), _ts('BuildContext ', _cls), _ts('ctx) {', _def)]),
      _cl([_ts('    return ', _kw), _ts('MaterialApp', _cls), _ts('(', _def)]),
      _cl([_ts('      theme: ', _def), _ts('AppTheme', _cls), _ts('.dark,', _def)]),
      _cl([_ts('      home: ', _def), _ts('const ', _kw), _ts('HomePage', _cls), _ts('(),', _def)]),
      _cl([_ts('    );', _def)]),
      _cl([_ts('  }', _def)]),
      _cl([_ts('}', _def)]),
    ];

    final themeLines = [
      _cl([_ts('// App colour theme', _cmt)]),
      _blank(),
      _cl([_ts('class ', _kw), _ts('AppTheme ', _cls), _ts('{', _def)]),
      _cl([_ts('  static ', _kw), _ts('ThemeData ', _cls), _ts('get dark ', _def), _ts('=>', _def)]),
      _cl([_ts('    ', _def), _ts('ThemeData', _cls), _ts('(', _def)]),
      _cl([_ts('      brightness: ', _def), _ts('Brightness', _cls), _ts('.dark,', _def)]),
      _cl([_ts('      primaryColor: ', _def), _ts('Color', _cls), _ts('(', _def), _ts('0xFF7B74CC', _num), _ts('),', _def)]),
      _cl([_ts('    );', _def)]),
      _cl([_ts('}', _def)]),
    ];

    final profileLines = [
      _cl([_ts('// About the developer', _cmt)]),
      _blank(),
      _cl([_ts('class ', _kw), _ts('OsamaSoliman ', _cls), _ts('{', _def)]),
      _cl([_ts('  final ', _kw), _ts('name ', _def), _ts('= ', _def), _ts("'Osama Soliman'", _str), _ts(';', _def)]),
      _cl([_ts('  final ', _kw), _ts('role ', _def), _ts('= ', _def), _ts("'Flutter Developer'", _str), _ts(';', _def)]),
      _cl([_ts('  final ', _kw), _ts('location ', _def), _ts('= ', _def), _ts("'Auckland, NZ'", _str), _ts(';', _def)]),
      _blank(),
      _cl([_ts('  final ', _kw), _ts('skills ', _def), _ts('= [', _def)]),
      _cl([_ts("    'Flutter'", _str), _ts(', ', _def), _ts("'Firebase'", _str), _ts(',', _def)]),
      _cl([_ts("    'Riverpod'", _str), _ts(', ', _def), _ts("'Go Router'", _str), _ts(',', _def)]),
      _cl([_ts('  ];', _def)]),
      _cl([_ts('}', _def)]),
    ];

    final skillsLines = [
      _cl([_ts('// Stack overview', _cmt)]),
      _blank(),
      _cl([_ts('const ', _kw), _ts('stack ', _def), _ts('= {', _def)]),
      _cl([_ts("  'lang'", _str), _ts(': ', _def), _ts("'Dart'", _str), _ts(',', _def)]),
      _cl([_ts("  'ui'", _str), _ts(': ', _def), _ts("'Flutter'", _str), _ts(',', _def)]),
      _cl([_ts("  'state'", _str), _ts(': ', _def), _ts("'Riverpod'", _str), _ts(',', _def)]),
      _cl([_ts("  'backend'", _str), _ts(': ', _def), _ts("'Firebase'", _str), _ts(',', _def)]),
      _cl([_ts('};', _def)]),
    ];

    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: child,
      ),
      child: Center(
        child: SizedBox(
          width: 420,
          height: 460,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bottom-right — skills.dart (back)
              Positioned(
                top: 248,
                left: 210,
                child: Opacity(
                  opacity: 0.55,
                  child: _buildWindow(
                    filename: 'skills.dart',
                    lines: skillsLines,
                    width: 185,
                  ),
                ),
              ),
              // Bottom-left — theme.dart
              Positioned(
                top: 235,
                left: 8,
                child: Opacity(
                  opacity: 0.70,
                  child: _buildWindow(
                    filename: 'theme.dart',
                    lines: themeLines,
                    width: 220,
                  ),
                ),
              ),
              // Top-right — profile.dart
              Positioned(
                top: 14,
                left: 200,
                child: Opacity(
                  opacity: 0.88,
                  child: _buildWindow(
                    filename: 'profile.dart',
                    lines: profileLines,
                    width: 212,
                  ),
                ),
              ),
              // Top-left — main.dart (front)
              Positioned(
                top: 0,
                left: 0,
                child: _buildWindow(
                  filename: 'main.dart',
                  lines: mainLines,
                  width: 262,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWindow({
    required String filename,
    required List<Widget> lines,
    required double width,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF080912),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.12),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chrome bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF0C0D1A),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
            ),
            child: Row(
              children: [
                _WinDot(color: const Color(0xFFFF5F57)),
                const SizedBox(width: 5),
                _WinDot(color: const Color(0xFFFFBD2E)),
                const SizedBox(width: 5),
                _WinDot(color: const Color(0xFF28CA41)),
                const SizedBox(width: 12),
                Text(
                  filename,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    color: Color(0xFF546E7A),
                  ),
                ),
              ],
            ),
          ),
          // Code content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: lines,
            ),
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
  Widget build(BuildContext context) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
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
