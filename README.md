# Orcarterycc

NEXORA PLAY is a Flutter game platform demo with a game library, profile, developer lab, and arcade-style game pages.

## Live phone demo

Open the GitHub Pages demo on your phone or browser:

https://orcartery-maker.github.io/Orcarterycc/

## GitHub deployment

This repository is already attached to GitHub and includes a GitHub Actions workflow that builds the Flutter web app and deploys it to GitHub Pages.

### Steps to publish the app

1. Push the current branch to GitHub.
2. Open your repository on GitHub.
3. Go to Settings > Pages.
4. Set Source to GitHub Actions.
5. Wait for the workflow to finish.
6. The Pages URL will become available at the link above.

### Local run

```bash
flutter pub get
flutter run
```

### Web build

```bash
flutter build web --release
```

## Repository notes

- App entry: `lib/main.dart`
- Core theme: `lib/app.dart`
- Game screens: `lib/gamepages/`
- Services: `lib/services/`
- Models: `lib/models/`

## GitHub Actions workflow

The workflow file is:

- `.github/workflows/flutter-web-pages.yml`

This workflow builds the app and deploys it automatically to GitHub Pages whenever changes are pushed to `main`.
