<!-- Video: YouTube Short (autoplay not supported on GitHub-rendered markdown; opens in YouTube) -->
<div align="center">
    <a href="https://youtube.com/shorts/Cg61mOv7f5E?si=MJH5kBxqOO18PsVV" target="_blank" rel="noopener noreferrer">
        <img src="SensorLab (3).png" alt="SensorLab demo video" width="720" />
    </a>
</div>

# 📱 SensorLab - All-in-One Sensor Toolkit

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue?style=for-the-badge)

_A comprehensive Flutter application that provides access to all device sensors with an intuitive, multi-language interface_

[🚀 Features](#-features) • [📋 Requirements](#-requirements) • [⚙️ Setup](#️-setup) • [🏗️ Architecture](#️-architecture) • [📚 Modules](#-modules) • [🤝 Contributing](#-contributing)

</div>

---

## 🚀 Features

### 🌐 **Multi-Language Support**

- **4 Languages**: English, Spanish, Japanese, Khmer
- **500+ Localized Strings**: Complete internationalization
- **Dynamic Language Switching**: Change language on-the-fly

### 📊 **Comprehensive Sensor Suite**

- **Motion Sensors**: Accelerometer, Gyroscope, Magnetometer
- **Environmental**: Light, Humidity, Noise, Proximity
- **Location & Navigation**: GPS, Compass
- **Health & Fitness**: Heart Rate, Activity Tracking, Calorie Counter
- **Utility**: QR/Barcode Scanner, Flashlight

### 🎨 **Modern UI/UX**

- **Material Design 3**: Latest design system
- **Dark/Light Themes**: System-adaptive theming
- **Responsive Layout**: Optimized for all screen sizes
- **Accessibility**: Full screen reader support

---

## 📋 Requirements

### **System Requirements**

- **Flutter SDK**: `>=3.0.0`
- **Dart SDK**: `>=3.0.0`
- **Android Studio**: Latest version (for Android development)
- **Xcode**: Latest version (for iOS development, macOS only)

### **Platform Support**

| Platform    | Minimum Version    | Recommended   |
| ----------- | ------------------ | ------------- |
| **Android** | API Level 21 (5.0) | API Level 33+ |
| **iOS**     | iOS 11.0           | iOS 15.0+     |
| **Web**     | Modern browsers    | Chrome 90+    |

### **Hardware Requirements**

- **RAM**: 8GB minimum, 16GB recommended
- **Storage**: 10GB free space
- **Processor**: Intel i5 / AMD Ryzen 5 or better

---

## ⚙️ Setup & Installation

### **1. Prerequisites Setup**

#### Install Flutter SDK

```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install
# Add Flutter to your PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

#### Install Android Studio

```bash
# Download from https://developer.android.com/studio
# Install Android SDK and Android SDK Command-line Tools
# Setup Android emulator or connect physical device
```

#### Configure Development Environment

```bash
# Accept Android licenses
flutter doctor --android-licenses

# Install required dependencies
flutter pub global activate flutterfire_cli
```

### **2. Project Setup**

#### Clone Repository

```bash
git clone https://github.com/Darahat/All-in-One-Sensor-Toolkit.git
cd All-in-One-Sensor-Toolkit
```

#### Install Dependencies

```bash
# Install Flutter dependencies
flutter pub get

# Generate platform-specific files
flutter packages pub run build_runner build
```

#### Configure Gradle (Android)

Ensure your `android/build.gradle` has:

```gradle
buildscript {
    ext.kotlin_version = '1.8.22'
    dependencies {
        classpath 'org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version'
        classpath 'com.android.tools.build:gradle:8.1.0'
    }
}
```

#### Generate Localization Files

```bash
# Generate localization classes
flutter gen-l10n
```

### **3. Running the Application**

#### Development Mode

```bash
# Run on connected device/emulator
flutter run

# Run with specific flavor
flutter run --flavor development

# Run with hot reload enabled (default)
flutter run --hot
```

#### Build for Production

```bash
# Build Android APK
flutter build apk --release

# Build Android App Bundle (recommended)
flutter build appbundle --release

# Build iOS (requires macOS)
flutter build ios --release

# Build for Web
flutter build web --release
```

### **4. Environment Configuration**

#### 🔐 Android Signing Setup

For building release APKs, you need to configure Android app signing:

```bash
# Copy the template file
cp android/key.properties.example android/key.properties

# Generate a keystore (replace with your details)
keytool -genkey -v -keystore android/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Edit android/key.properties with your actual values
```

**⚠️ Security Note**: Never commit `key.properties` or keystore files to version control!

For detailed setup instructions, see: **[Android Setup Guide](ANDROID_SETUP.md)**

#### 🔑 Environment Variables Setup

For optional features (AdMob, API keys), configure environment variables:

```bash
# Copy the template file
cp .env.example .env

# Edit .env with your actual values (optional)
```

**⚠️ Security Note**: Never commit `.env` files to version control!

#### Configuration Overview

The app uses a two-file configuration system:

1. **`android/key.properties`** - Android signing and AdMob App ID
2. **`.env`** - AdMob ad unit IDs and API keys (optional)

Both files are excluded from version control for security.

---

## 🏗️ Architecture

### **Clean Architecture Pattern**

```
📁 lib/
├── 📁 src/
│   ├── 📁 core/                    # Core functionality
│   │   ├── 📁 constants/           # App constants
│   │   ├── 📁 errors/              # Error handling
│   │   ├── 📁 services/            # Core services
│   │   └── 📁 utils/               # Utility functions
│   │
│   └── 📁 features/                # Feature modules
│       ├── 📁 health/              # Health & fitness tracking
│       │   ├── 📁 domain/          # Business logic
│       │   │   ├── 📁 entities/    # Core entities
│       │   │   ├── 📁 repositories/ # Repository interfaces
│       │   │   └── 📁 usecases/    # Business use cases
│       │   ├── 📁 infrastructure/  # External data sources
│       │   ├── 📁 application/     # Application services
│       │   └── 📁 presentation/    # UI components
│       │       ├── 📁 screens/     # Screen widgets
│       │       ├── 📁 widgets/     # Reusable widgets
│       │       └── 📁 providers/   # State management
│       │
│       ├── 📁 accelerometer/       # Motion sensor
│       ├── 📁 gyroscope/          # Rotation sensor
│       ├── 📁 compass/            # Navigation
│       ├── 📁 geolocator/         # GPS tracking
│       ├── 📁 light_meter/        # Ambient light
│       ├── 📁 noise_meter/        # Sound level
│       ├── 📁 humidity/           # Humidity sensor
│       ├── 📁 proximity/          # Proximity detection
│       ├── 📁 heart_beat/         # Heart rate monitor
│       ├── 📁 qr_scanner/         # QR/Barcode scanner
│       ├── 📁 flashlight/         # Device flashlight
│       └── 📁 app_settings/       # Application settings
│
├── 📁 l10n/                       # Localization files
│   ├── 📄 app_en.arb             # English translations
│   ├── 📄 app_es.arb             # Spanish translations
│   ├── 📄 app_ja.arb             # Japanese translations
│   └── 📄 app_km.arb             # Khmer translations
│
└── 📄 main.dart                   # Application entry point
```

---

## 📚 Modules Documentation

### **Core Modules**

| Module               | Description                                        | Documentation                                                      |
| -------------------- | -------------------------------------------------- | ------------------------------------------------------------------ |
| 🏥 **Health**        | Activity tracking, calorie counter, health metrics | [📖 Health Module](docs/modules/health.md)                         |
| 📊 **Accelerometer** | 3-axis acceleration measurement                    | [📖 Accelerometer Module](docs/modules/accelerometer.md)           |
| 🌀 **Gyroscope**     | Device rotation and angular velocity               | [📖 Gyroscope Module](docs/modules/gyroscope.md)                   |
| 🧭 **Compass**       | Magnetic field and navigation                      | [📖 Compass Module](docs/modules/compass.md)                       |
| 📍 **Geolocator**    | GPS positioning and location services              | [📖 Geolocator Module](docs/modules/geolocator.md)                 |
| 💡 **Light Meter**   | Ambient light measurement                          | [📖 Light Meter Module](docs/modules/light_meter.md)               |
| 🔊 **Noise Meter**   | Sound level monitoring                             | [📖 Noise Meter Docs](lib/src/features/noise_meter/docs/README.md) |
| 💧 **Humidity**      | Environmental humidity sensing                     | [📖 Humidity Module](docs/modules/humidity.md)                     |
| 📏 **Proximity**     | Distance detection sensor                          | [📖 Proximity Module](docs/modules/proximity.md)                   |
| ❤️ **Heart Beat**    | Heart rate monitoring via camera                   | [📖 Heart Beat Module](docs/modules/heart_beat.md)                 |
| 📱 **QR Scanner**    | QR code and barcode scanning                       | [📖 QR Scanner Module](docs/modules/qr_scanner.md)                 |
| 🔦 **Flashlight**    | Device flashlight control                          | [📖 Flashlight Module](docs/modules/flashlight.md)                 |
| ⚙️ **App Settings**  | Application configuration                          | [📖 Settings Module](docs/modules/app_settings.md)                 |

---

## 🔧 Integration & Usage

### **For Developers**

Want to use SensorLab features in your own app? We've got you covered!

| Guide                                                  | Description                        | Best For                     |
| ------------------------------------------------------ | ---------------------------------- | ---------------------------- |
| **[🚀 Quick Start Template](QUICK_START_TEMPLATE.md)** | Ready-to-use health app template   | Beginners, rapid prototyping |
| **[📖 Integration Guide](INTEGRATION_GUIDE.md)**       | Complete feature integration guide | Custom implementations       |
| **[📚 Module Documentation](docs/modules/)**           | Individual module guides           | Specific feature integration |

### **Popular Use Cases**

- **Health & Fitness Apps** - Activity tracking, user profiles, settings
- **IoT Sensor Dashboards** - Real-time sensor data visualization
- **Educational Projects** - Learning Flutter, sensors, localization
- **Prototype Development** - Quick sensor integration testing

---

## 🤝 Contributing

### **Development Setup**

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### **Coding Standards**

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use [Flutter Linting](https://pub.dev/packages/flutter_lints)
- Write tests for new features
- Update documentation

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with ❤️ using Flutter**
**Made with ❤️ by darahat**
⭐ **Star this repository if you find it helpful!** ⭐

</div>
flutter dart mobile sensors accelerometer gyroscope compass gps health tracker qr scanner internationalization cross platform android ios real time data clean architecture material design riverpod sensor toolkit measurement app
