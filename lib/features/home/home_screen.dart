import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'widgets/navbar.dart';
import 'widgets/hero_section.dart';
import 'widgets/stats_bar.dart';
import 'widgets/about_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/experience_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  // Section keys for scroll-to navigation
  final _sectionKeys = <String, GlobalKey>{
    AppConstants.heroSection: GlobalKey(),
    AppConstants.statsSection: GlobalKey(),
    AppConstants.aboutSection: GlobalKey(),
    AppConstants.skillsSection: GlobalKey(),
    AppConstants.projectsSection: GlobalKey(),
    AppConstants.experienceSection: GlobalKey(),
    AppConstants.contactSection: GlobalKey(),
  };

  void _scrollToWork() {
    final key = _sectionKeys[AppConstants.projectsSection];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PortfolioNavbar(
        scrollController: _scrollController,
        sectionKeys: _sectionKeys,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              key: _sectionKeys[AppConstants.heroSection],
              child: HeroSection(onViewWork: _scrollToWork),
            ),

            Container(
              key: _sectionKeys[AppConstants.statsSection],
              child: const StatsBar(),
            ),

            Container(
              key: _sectionKeys[AppConstants.aboutSection],
              child: const AboutSection(),
            ),

            Container(
              key: _sectionKeys[AppConstants.skillsSection],
              child: const SkillsSection(),
            ),

            Container(
              key: _sectionKeys[AppConstants.projectsSection],
              child: const ProjectsSection(),
            ),

            Container(
              key: _sectionKeys[AppConstants.experienceSection],
              child: const ExperienceSection(),
            ),

            Container(
              key: _sectionKeys[AppConstants.contactSection],
              child: const ContactSection(),
            ),

            const PortfolioFooter(),
          ],
        ),
      ),
    );
  }
}
