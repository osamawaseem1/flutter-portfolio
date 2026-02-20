import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/animated_section.dart';
import '../../../shared/utils/cv_download.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _messageController.text.isEmpty) return;
    final subject = Uri.encodeComponent('Portfolio Contact — ${_nameController.text}');
    final body = Uri.encodeComponent('From: ${_nameController.text} (${_emailController.text})\n\n${_messageController.text}');
    await launchUrl(Uri.parse('mailto:${AppConstants.email}?subject=$subject&body=$body'));
    if (mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;

    return AnimatedSection(
      sectionKey: AppConstants.contactSection,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 96,
          horizontal: isMobile ? 24 : 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isMobile
                ? _buildMobile()
                : _buildDesktop(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _buildLeft()),
        const SizedBox(width: 64),
        Expanded(flex: 5, child: _buildForm()),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLeft(),
        const SizedBox(height: 40),
        _buildForm(),
      ],
    );
  }

  Widget _buildLeft() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          label: 'Contact',
          title: "Let's Build\nSomething Great.",
        ),
        const SizedBox(height: 20),
        Text(
          'Whether it\'s a full-time role, freelance project, or just a chat — I\'m open to it. Based in Auckland, available remotely worldwide.',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 36),

        _InfoRow(
          icon: Icons.location_on_outlined,
          label: AppConstants.location,
          subtitle: 'Open to Remote Worldwide',
        ),
        const SizedBox(height: 16),
        _InfoRow(
          icon: Icons.email_outlined,
          label: AppConstants.email,
          onTap: () => launchUrl(Uri.parse('mailto:${AppConstants.email}')),
        ),

        const SizedBox(height: 36),

        Row(
          children: [
            _SocialLink(
              icon: Icons.code,
              label: 'GitHub',
              url: AppConstants.github,
            ),
            const SizedBox(width: 12),
            _SocialLink(
              icon: Icons.work_outline,
              label: 'LinkedIn',
              url: AppConstants.linkedin,
            ),
            const SizedBox(width: 12),
            _SocialLink(
              icon: Icons.download,
              label: 'CV',
              url: AppConstants.cvUrl,
              onTap: downloadCv,
            ),
          ],
        ),

        const SizedBox(height: 32),

        Row(
          children: [
            const Icon(Icons.update, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 6),
            Text(
              'Last updated: February 2026',
              style: AppTextStyles.labelMedium.copyWith(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm() {
    if (_sent) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.green.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.green.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 48, color: AppColors.green),
            const SizedBox(height: 16),
            Text('Message sent!', style: AppTextStyles.headingSmall.copyWith(color: AppColors.green)),
            const SizedBox(height: 8),
            Text(
              'Thanks for reaching out. I\'ll get back to you soon.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FormField(
            controller: _nameController,
            label: 'Name',
            hint: 'Your name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _FormField(
            controller: _emailController,
            label: 'Email',
            hint: 'your@email.com',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          _FormField(
            controller: _messageController,
            label: 'Message',
            hint: 'Tell me about the project or opportunity...',
            icon: Icons.chat_bubble_outline,
            maxLines: 5,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: _SendButton(onTap: _send),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  const _InfoRow({required this.icon, required this.label, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: onTap != null ? AppColors.accent : AppColors.textPrimary,
                  decoration: onTap != null ? TextDecoration.underline : null,
                ),
              ),
              if (subtitle != null)
                Text(subtitle!, style: AppTextStyles.labelMedium.copyWith(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final VoidCallback? onTap;
  const _SocialLink({required this.icon, required this.label, required this.url, this.onTap});

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap ?? () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accent.withOpacity(0.1) : AppColors.glassBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? AppColors.accent.withOpacity(0.4) : AppColors.glassBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 14, color: _hovered ? AppColors.accent : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: _hovered ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
            prefixIcon: maxLines == 1 ? Icon(icon, size: 16, color: AppColors.textSecondary) : null,
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _SendButton extends StatefulWidget {
  final VoidCallback onTap;
  const _SendButton({required this.onTap});

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
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
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accent, Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)]
                : [],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Send Message',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.send, size: 16, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
