import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

class StatsBar extends StatelessWidget {
  const StatsBar({super.key});

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
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: isMobile
          ? _buildGrid()
          : _buildRow(),
    );
  }

  Widget _buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _buildItems(),
    );
  }

  Widget _buildGrid() {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: 16,
      runSpacing: 24,
      children: _buildItems(),
    );
  }

  List<Widget> _buildItems() {
    return AppConstants.stats.asMap().entries.map((entry) {
      final i = entry.key;
      final stat = entry.value;
      return _StatItem(
        value: stat['value']!,
        label: stat['label']!,
        delay: Duration(milliseconds: 100 * i),
      );
    }).toList();
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Duration delay;

  const _StatItem({
    required this.value,
    required this.label,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.statNumber)
            .animate(delay: delay)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.statLabel)
            .animate(delay: delay + 100.ms)
            .fadeIn(duration: 600.ms),
      ],
    );
  }
}
