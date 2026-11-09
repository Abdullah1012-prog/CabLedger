# CabLedger

CabLedger is a Flutter app for cab drivers to track daily earnings, running costs, and vehicle investment recovery in one place.

## Features

- Record daily sales, fuel costs, and other expenses, and calculate net profit.
- Review earnings over time, including monthly totals, averages, and best and lowest days.
- Keep vehicle purchase details and track cumulative operating profit against the purchase price.
- View dashboard summaries, record history, and charts and reports.
- Export records and reports to CSV or PDF.
- Back up and restore app data, and choose light or dark appearance.
- Store records locally using SQLite.

## Getting started

### Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) with Dart SDK `^3.13.7` (see `pubspec.yaml`).
- A device, emulator, or desktop target supported by your Flutter installation.

### Run the app

```bash
git clone https://github.com/Abdullah1012-prog/CabLedger.git
cd CabLedger
flutter pub get
flutter run
```

To select a specific connected device or target, run `flutter devices` and then use `flutter run -d <device-id>`.

## Development

Run the test suite and static analysis with:

```bash
flutter test
flutter analyze
```

## Data and backups

CabLedger uses a local SQLite database for its records. The app includes backup and restore, along with CSV and PDF export options. Keep backup files somewhere safe; restoring a backup replaces the app's current database contents.

## Built with

- [Flutter](https://flutter.dev/) and Dart
- SQLite (`sqflite`)
- Provider for app state
- `fl_chart` for charts
- `pdf` and `printing` for PDF reports

## Contributing

Issues and pull requests are welcome. For significant changes, please open an issue first to discuss what you would like to change.

## License

No license is currently specified in this repository. Unless a license is added, standard copyright restrictions apply.
