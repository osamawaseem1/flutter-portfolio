# Osama Soliman Flutter Portfolio

The original Flutter implementation of Osama Soliman's personal portfolio. It brings experience, project summaries, technical skills, education, and contact information into a responsive single-page application.

This is a legacy reference project, not the source of the current [osamasoliman.com](https://osamasoliman.com) website. Its content and links may differ from the live portfolio.

## Highlights

- Responsive Flutter Web layout for desktop, tablet, and mobile.
- Sections for profile, experience, projects, skills, education, and contact.
- Reusable design-system components for cards, headings, tags, typography, and spacing.
- Shared theme, colour, and typography configuration.
- A CV download link and external project and contact links.
- Web metadata, `robots.txt`, and `sitemap.xml` files.
- Firebase Hosting configuration.

## Run locally

Use a Flutter SDK that satisfies the Dart `^3.10.7` constraint in [`pubspec.yaml`](pubspec.yaml), with Chrome available as a target.

```bash
flutter pub get
flutter run -d chrome
```

## Quality checks

```bash
flutter analyze
flutter build web
```

These are suggested local checks, not a claim that the current checkout passes them. The existing [`test/widget_test.dart`](test/widget_test.dart) is the generated counter test: it refers to `MyApp`, while the application now defines `PortfolioApp`. Replace it with portfolio-specific tests before relying on `flutter test`.

Manually check narrow and wide layouts, keyboard navigation, theme colours, section navigation, and every external link. Accessibility and performance need their own verification; the presence of a theme or metadata does not establish compliance or search visibility.

## Build and deployment caution

Build the static web application with:

```bash
flutter build web --release
```

The output is written to `build/web`. The checked-in `.firebaserc` points to `osamasolimannz`, which hosts the current website. **Do not deploy this legacy application to that default project: it would replace the current site.**

If you want to host your own copy, configure a separate Firebase project and explicitly verify the target project and Hosting site before deploying. Review the contact details, CV URL, canonical metadata, robots file, and sitemap for your own domain first.

## Repository structure

```text
lib/
├── core/                  # Theme, constants, and shared configuration
├── features/home/         # Portfolio sections and page composition
├── shared/widgets/        # Reusable visual components
├── shared/utils/          # Browser CV download helper
└── main.dart              # Application entry point
web/                       # Web metadata, icons, sitemap, and robots file
test/                      # Original counter test, pending replacement
```

[`HomeScreen`](lib/features/home/home_screen.dart) composes the page sections and manages scroll navigation. Shared profile details and external URLs are held in [`AppConstants`](lib/core/constants/app_constants.dart). The CV is linked from its configured URL, not bundled as a tracked file in `web/`.

## Scope and limitations

- This is a Flutter Web presentation project, not a backend or contact-form service.
- The browser-specific CV helper uses `dart:html`; native-platform support is not established by this implementation.
- Contact details and project content are static and require manual updates.
- There is no current automated portfolio test coverage demonstrated by the original counter test.
