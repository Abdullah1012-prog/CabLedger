<div align="center">
  <img src="https://raw.githubusercontent.com/Abdullah1012-prog/CabLedger/main/web/icons/Icon-512.png" alt="CabLedger app icon" width="120" />
  <h1>CabLedger</h1>
  <p><strong>Your cab business finances, clearly tracked.</strong></p>
  <p>Log daily income and running costs, understand your profit, and follow your vehicle investment recovery—all in one Flutter app.</p>

  <p>
    <a href="https://github.com/Abdullah1012-prog/CabLedger/stargazers"><img src="https://img.shields.io/github/stars/Abdullah1012-prog/CabLedger?style=for-the-badge&color=gold" alt="GitHub stars" /></a>
    <a href="https://github.com/Abdullah1012-prog/CabLedger/network/members"><img src="https://img.shields.io/github/forks/Abdullah1012-prog/CabLedger?style=for-the-badge" alt="GitHub forks" /></a>
    <a href="https://github.com/Abdullah1012-prog/CabLedger/issues"><img src="https://img.shields.io/github/issues/Abdullah1012-prog/CabLedger?style=for-the-badge" alt="GitHub issues" /></a>
    <img src="https://img.shields.io/badge/Flutter-app-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Built with Flutter" />
    <img src="https://img.shields.io/badge/Dart-SDK%20%5E3.13.7-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart SDK ^3.13.7" />
  </p>
</div>

---

## About CabLedger

CabLedger is a cab driver earnings and vehicle investment tracker. Keep a practical record of daily sales, fuel, and other expenses, then use clear summaries to see how your work is adding up over time. Vehicle purchase details help you compare cumulative operating profit with the original investment.

Designed as a Flutter application, CabLedger stores records locally with SQLite and includes tools to export and back up your data.

## Highlights

- **Daily bookkeeping:** Record sales, fuel, and other expenses by date; see daily net profit.
- **At-a-glance dashboard:** Review today's figures and current-month totals.
- **History and reporting:** Find past entries and explore monthly summaries, averages, best and lowest earning days, and charts.
- **Investment tracking:** Save vehicle purchase details and monitor cumulative operating profit and investment recovery.
- **Shareable exports:** Export monthly reports as CSV or PDF.
- **Local data and backup:** Keep records in a local SQLite database and use the app's backup and restore options.
- **Personal preferences:** Choose light or dark appearance and a supported currency display style.

## Screenshots

App screenshots are not included in the repository yet. Add genuine captures under `docs/screenshots/` and replace this note with image links when they are available. For example:

```md
![CabLedger dashboard](docs/screenshots/dashboard.png)
```

## App-store description

### Short description

Track cab earnings, daily costs, monthly performance, and vehicle investment recovery.

### Full description

Make it easier to understand where your cab business stands. CabLedger helps you log daily sales, fuel costs, and other expenses, then calculates your net profit and organizes your records into useful monthly summaries.

Use the dashboard to check today's and this month's figures, browse your entry history, and explore charts and reports. Add your vehicle's purchase details to follow operating profit against its purchase price. When you need to keep or share your information, export reports to CSV or PDF and use the built-in database backup and restore options.

CabLedger is built with Flutter and stores its records locally on your device. It is a tracking tool and does not provide tax, accounting, or financial advice.

## Getting started

### Requirements

- Flutter SDK and the Dart SDK version allowed by `pubspec.yaml` (`^3.13.7`).
- A device, emulator, or desktop target configured for Flutter.

### Run locally

```bash
git clone https://github.com/Abdullah1012-prog/CabLedger.git
cd CabLedger
flutter pub get
flutter run
```

To choose a particular connected device, run `flutter devices`, then use `flutter run -d <device-id>`.

### Run checks

```bash
flutter analyze
flutter test
```

## Technology

- [Flutter](https://flutter.dev/) and Dart
- SQLite via `sqflite` (with `sqflite_common_ffi` for desktop and tests)
- [Provider](https://pub.dev/packages/provider) for state management
- [`fl_chart`](https://pub.dev/packages/fl_chart) for charts
- [`pdf`](https://pub.dev/packages/pdf) and [`printing`](https://pub.dev/packages/printing) for PDF output

## Contributing

Bug reports and pull requests are welcome. If you plan a larger change, please open an issue first so the proposal can be discussed. When reporting a bug, include the steps to reproduce it, the target platform, and relevant error output; do not attach private financial data.

## License

No license file is currently included. Until a license is added, the project should be treated as copyrighted and reuse is not granted by default.
