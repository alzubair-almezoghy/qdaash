# قدّاش · qdaash

An offline-first personal finance app built with Flutter for Android.

## Features

- Arabic and English interface with RTL support and a persistent language choice
- Transactions, savings goals, monthly budget, wallet labels, categories and reports backed by local SQLite
- A custom radial navigation wheel with a central Add button
- Light, dark and system themes; accent colors; motion and haptic preferences
- Local daily, weekly and monthly reminders, budget threshold alerts and savings goal milestones
- PIN lock with an encrypted, salted PIN verifier; optional device biometrics; hidden Home amounts and secure app previews
- CSV, PDF and JSON backup export, validated backup restore, and confirmed data deletion

Financial records are stored in LYD. Other display currencies require a rate entered by the user; changing the display currency does not change stored amounts. No sample transactions or balances are seeded.

## Run

Connect a physical Android phone, then select its ID from `flutter devices`:

```sh
flutter pub get
flutter run -d <device-id>
```

The Android minimum is API 23. The local database is `masar_finance.db`. Goal contributions update goals without changing transaction balances. Backups intentionally exclude the PIN verifier and biometric enrollment.
