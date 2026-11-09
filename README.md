<div align="center">
  <img src="https://raw.githubusercontent.com/Abdullah1012-prog/CabLedger/main/web/icons/Icon-512.png" alt="CabLedger app icon" width="112" />
  <h1>CabLedger</h1>
  <p><strong>A clearer view of your cab business.</strong></p>
  <p>Track daily income, operating costs, monthly performance, and vehicle investment recovery in one Flutter app.</p>

  <p>
    <a href="https://github.com/Abdullah1012-prog/CabLedger/stargazers"><img src="https://img.shields.io/github/stars/Abdullah1012-prog/CabLedger?style=flat-square&color=gold" alt="GitHub stars" /></a>
    <a href="https://github.com/Abdullah1012-prog/CabLedger/issues"><img src="https://img.shields.io/github/issues/Abdullah1012-prog/CabLedger?style=flat-square" alt="GitHub issues" /></a>
    <a href="https://github.com/Abdullah1012-prog/CabLedger/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-not%20specified-lightgrey?style=flat-square" alt="License not specified" /></a>
    <img src="https://img.shields.io/badge/Flutter-app-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Built with Flutter" />
    <img src="https://img.shields.io/badge/Dart-SDK%20%5E3.13.7-0175C2?style=flat-square&logo=dart&logoColor=white" alt="Dart SDK ^3.13.7" />
  </p>
</div>

---

## Overview

CabLedger is a cab driver earnings and vehicle investment tracker. Record each day's sales, fuel costs, and other expenses, then review the resulting profit through a dashboard, history, charts, and monthly reports.

Vehicle purchase details can be compared with cumulative operating profit to help you follow investment recovery. Records are stored locally in SQLite, with options to back up data and export reports.

## What you can do

- **Log daily finances** — Record sales, fuel, and other expenses by date and calculate net profit.
- **Check performance at a glance** — See today's figures and current-month totals on the dashboard.
- **Review your history** — Search records by date and filter by month or year.
- **Understand trends** — View monthly summaries, daily averages, best and lowest earning days, and charts.
- **Track vehicle investment** — Save vehicle purchase details and follow cumulative operating profit against purchase price.
- **Export and protect your records** — Export monthly reports as CSV or PDF and use database backup and restore.
- **Personalize the experience** — Choose light or dark mode and a supported currency display style.

## Screenshots

Screenshots are not included in the repository yet. Add genuine app captures to `docs/screenshots/` and link them here, for example:

```md
![CabLedger dashboard](docs/screenshots/dashboard.png)
```

Suggested captures: dashboard, daily record form, monthly report, and vehicle investment screen.

## App description

**Short description:** Track cab earnings, operating costs, monthly performance, and vehicle investment recovery.

**Full description:** CabLedger helps cab drivers keep their business finances organized. Record daily sales, fuel costs, and other expenses, then see net profit and follow performance over time. Review monthly totals and charts, browse your record history, and track operating profit against your vehicle's purchase price. Export reports to CSV or PDF and use the built-in backup and restore tools to manage your locally stored data.

CabLedger is a financial tracking tool, not tax, accounting, or financial advice.

## Getting started

### Prerequisites

- Flutter SDK with the Dart SDK version allowed by `pubspec.yaml` (`^3.13.7`).
- A Flutter-supported device, emulator, or desktop target.

### Run the app

```bash
git clone https://github.com/Abdullah1012-prog/CabLedger.git
cd CabLedger
flutter pub get
flutter run
```

To choose a specific target, run `flutter devices` and then `flutter run -d <device-id>`.

### Run checks

```bash
flutter analyze
flutter test
```

## Built with

- [Flutter](https://flutter.dev/) and Dart
- SQLite with `sqflite` and `sqflite_common_ffi`
- [Provider](https://pub.dev/packages/provider) for state management
- [`fl_chart`](https://pub.dev/packages/fl_chart) for charts
- [`pdf`](https://pub.dev/packages/pdf) and [`printing`](https://pub.dev/packages/printing) for PDF output

## Project structure

```text
lib/
├── core/        # Shared formatting and theme
├── data/        # Database, models, and repositories
├── domain/      # Financial calculations
├── export/      # CSV, PDF, and backup services
├── features/    # Dashboard, history, records, reports, settings, vehicle
└── state/       # Provider controllers
 test/           # Unit and widget tests
```

## Contributing

Bug reports and pull requests are welcome. For a larger change, open an issue first to discuss the proposal. Please include reproducible steps and relevant error output in bug reports, and avoid sharing personal financial data.

## License

This repository does not currently include a license file. Until one is added, standard copyright restrictions apply; please contact the repository owner before reusing or distributing the code.
