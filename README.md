# Shoe Store App

A feature-rich Flutter application for managing and browsing a shoe store inventory with shopping cart functionality.

## Features

- 📦 **Product Management**: Browse through an extensive catalog of shoes
- 🛒 **Shopping Cart**: Add items to cart with quantity management
- 🔍 **Filter & Search**: Filter shoes by brand, size, and price range
- 💾 **SQLite Database**: Local database for persistent storage
- 👨‍💼 **Admin Panel**: Manage inventory, add/edit/delete products
- 📱 **Responsive UI**: Clean Material Design 3 interface
- 🎨 **State Management**: Provider pattern for efficient state handling

## Technologies Used

- **Flutter** 3.24.5
- **Dart** 3.5.4
- **SQLite** (via sqflite package)
- **Provider** for state management
- **Material Design 3**

## Dependencies

Key packages used:
- `sqflite`: ^2.3.0 - Local database
- `provider`: ^6.1.1 - State management
- `file_picker`: ^6.0.0 - File operations
- `permission_handler`: ^11.0.0 - Android permissions
- `cached_network_image`: ^3.3.0 - Image caching
- `flutter_staggered_grid_view`: ^0.7.0 - Grid layouts

## Getting Started

### Prerequisites
- Flutter SDK 3.24.5 or higher
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android builds)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/shoe_store_app.git
cd shoe_store_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building APK

For debug APK:
```bash
flutter build apk --debug
```

For release APK:
```bash
flutter build apk --release
```

APK will be generated at: `build/app/outputs/flutter-apk/`

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── shoe.dart
│   └── cart_item.dart
├── providers/                # State management
│   ├── shoe_provider.dart
│   └── cart_provider.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── shoe_detail_screen.dart
│   ├── cart_screen.dart
│   ├── filter_screen.dart
│   └── admin_screen.dart
├── widgets/                  # Reusable widgets
│   └── shoe_card.dart
├── database/                 # Database operations
│   └── database_helper.dart
└── utils/                    # Utilities
    └── sample_data_generator.dart
```

## License

This project is open source and available under the MIT License.

## Contact

For questions or support, please open an issue in the repository.
