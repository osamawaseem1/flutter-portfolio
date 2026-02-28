class AppConstants {
  static const double mobileBreakpoint = 768;

  // Personal info
  static const String name = 'Osama Soliman';
  static const String title = 'Flutter Developer';
  static const String location = 'Auckland, New Zealand';
  static const String email = 'iamosamasoliman@gmail.com';
  static const String linkedin = 'https://www.linkedin.com/in/osama-soliman-00980b320/';
  static const String github = 'https://github.com/osamawaseem1';
  static const String cvUrl = 'https://osamasolimannz.web.app/cv.pdf';

  // Bio
  static const String heroBio =
      'I build beautiful, performant apps for iOS, Android & Web — with Flutter at the core.';

  static const String aboutBio =
      'Flutter developer based in Auckland, New Zealand. I build production-grade mobile apps with clean architecture, smart state management, and a genuine obsession with UI quality. '
      'I go beyond simple screens — working with proximity logic, Firestore cost optimisation, and complex state flows. '
      'Currently contributing to Halal Kiwi, New Zealand\'s leading Muslim directory app. Previously built Masajidna — a full-stack mosque management platform across three Flutter apps.';

  // Stats
  static const List<Map<String, String>> stats = [
    {'value': '2+', 'label': 'Apps Shipped'},
    {'value': '4.8', 'label': 'Avg Store Rating'},
    {'value': '3', 'label': 'Apps Built'},
    {'value': '4+', 'label': 'Years Experience'},
  ];

  // Typewriter titles
  static const List<String> typewriterTitles = [
    'Flutter Developer',
    'Mobile Engineer',
    'Firebase Architect',
    'Cross-platform Builder',
  ];

  // Fun facts
  static const List<Map<String, String>> funFacts = [
    {'icon': '☕', 'label': 'Coffee-driven'},
    {'icon': '📱', 'label': 'Flutter since v1.0-era'},
    {'icon': '🌍', 'label': 'Remote-ready'},
    {'icon': '🎯', 'label': 'Pixel-perfect obsessed'},
  ];

  // Navigation items
  static const List<Map<String, String>> navItems = [
    {'label': 'Work', 'route': '/#work'},
    {'label': 'Tech Stack', 'route': '/#stack'},
    {'label': 'About', 'route': '/#about'},
    {'label': 'Contact', 'route': '/#contact'},
  ];

  // Section IDs for scroll
  static const String heroSection = 'hero';
  static const String statsSection = 'stats';
  static const String aboutSection = 'about';
  static const String skillsSection = 'stack';
  static const String projectsSection = 'work';
  static const String experienceSection = 'journey';
  static const String contactSection = 'contact';
}
