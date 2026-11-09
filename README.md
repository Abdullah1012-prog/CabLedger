<div align="center">
  <img src="https://raw.githubusercontent.com/Abdullah1012-prog/CabLedger/main/web/icons/Icon-512.png" alt="CabLedger app icon" width="112" />
  <h1>CabLedger</h1>
  <p><strong>A clearer view of your cab business.</strong></p>
  <p>Track daily income, operating costs, monthly performance, and vehicle investment recovery in one Flutter app.</p>
</div>

---

## Overview

CabLedger is a cab driver earnings and vehicle investment tracker. Record each day's sales, fuel costs, and other expenses, then review profit through the dashboard, history, reports, and charts. Vehicle purchase details can be compared with cumulative operating profit to follow investment recovery. Records are stored locally in SQLite, with options to back up data and export reports.

## Features

- **Log daily finances** — Record sales, fuel, and other expenses by date and calculate net profit.
- **Check performance at a glance** — See today's figures and current-month totals on the dashboard.
- **Review your history** — Search records by date and filter by month or year.
- **Understand trends** — View monthly summaries, daily averages, best and lowest earning days, and charts.
- **Track vehicle investment** — Save vehicle purchase details and follow cumulative operating profit against purchase price.
- **Export and protect your records** — Export monthly reports as CSV or PDF and use database backup and restore.
- **Personalize the experience** — Choose light or dark mode and a supported currency display style.

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
test/            # Unit and widget tests
```

## Contributing

Bug reports and pull requests are welcome. For a larger change, open an issue first to discuss the proposal. Please include reproducible steps and relevant error output in bug reports.
