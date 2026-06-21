# 🧪 SensorLab — Your Personal Sensor Box, Data Logger & Physics Toolbox

<div align="center">

<a href="https://play.google.com/store/apps/details?id=com.darahat.sensorlab&pcampaignid=web_share" target="_blank" rel="noopener noreferrer">
    <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Get SensorLab on Google Play" width="240"/>
</a>

### 📥 [Download SensorLab on the Google Play Store](https://play.google.com/store/apps/details?id=com.darahat.sensorlab&pcampaignid=web_share)

---

### 📺 [Watch the SensorLab App Demo on YouTube Shorts](https://youtube.com/shorts/Cg61mOv7f5E?si=MJH5xqOO18PsVV)

<a href="https://youtube.com/shorts/Cg61mOv7f5E?si=MJH5xqOO18PsVV" target="_blank" rel="noopener noreferrer">
    <img src="https://raw.githubusercontent.com/darahat-dev-Solutions/SensorLab/main/SensorLab%20(3).png" alt="SensorLab UI Overview" width="100%" />
</a>

---

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

<p align="center">
  <b>Unlock the full hardware potential of your smartphone.</b><br>
  SensorLab is an advanced, production-ready raw sensor data logger and physics toolbox built with Flutter. It seamlessly transforms consumer mobile devices into highly precise scientific tools for diagnostics, tracking, environmental logging, and STEM education.
</p>

[🚀 Key Features](#-key-features) • [📊 Use Cases](#-popular-use-cases) • [🏗️ Architecture](#️-architecture) • [📚 Hardware Modules](#-sensor-modules) • [⚙️ Setup](#️-quick-start) • [🤝 Contributing](#-contributing)

</div>

---

## 📱 Visual Interface

Below is an overview of the core application layouts, highlighting the modern Material Design 3 configuration, live telemetry recording sessions, and real-time visualization dashboards.

<div align="center">
  <table border="0">
    <tr>
      <td width="33%" align="center">
        <b>Dashboard</b><br>
        <img src="https://github.com/darahat-dev-Solutions/SensorLab/blob/main/blob/Dashboard.jpeg" width="100%" alt="SensorLab Dashboard View"/><br>
        <em>SensorLab Dashboard</em>
      </td>
      <td width="33%" align="center">
        <b>Sensor Multiplexing</b><br>
        <img src="https://github.com/darahat-dev-Solutions/SensorLab/blob/main/blob/create-lab.jpeg" width="100%" alt="Sensor Selection"/><br>
        <em>Toggle Active Hardware</em>
      </td>
      <td width="33%" align="center">
        <b>Lab Configuration</b><br>
        <img src="https://github.com/darahat-dev-Solutions/SensorLab/blob/main/blob/custom-lab-details.jpeg" width="100%" alt="Lab Details"/><br>
        <em>Sampling Interval Controls</em>
      </td>
    </tr>
    <tr>
      <td width="33%" align="center">
        <b>Real-Time Execution</b><br>
        <img src="https://github.com/darahat-dev-Solutions/SensorLab/blob/main/blob/monitor-custom-lab.jpeg" width="100%" alt="Active Recording Graph"/><br>
        <em>Waveform & Lux Metrics</em>
      </td>
      <td width="33%" align="center">
        <b>Session Analytics</b><br>
        <img src="https://github.com/darahat-dev-Solutions/SensorLab/blob/main/blob/session-details.jpeg" width="100%" alt="Session Breakdown"/><br>
        <em>Historical Log Details</em>
      </td>
      <td width="33%" align="center">
        <b>Speed & Kinematics</b><br>
        <img src="https://github.com/darahat-dev-Solutions/SensorLab/blob/main/blob/session-list.jpeg" width="100%" alt="Speedometer Dashboard"/><br>
        <em>Live GPS Speed Metrics</em>
      </td>
    </tr>
  </table>
</div>

---

## 🚀 Key Features

- **Modular Lab Builder:** Custom-stack multiple hardware sensors inside an adaptive dashboard panel. Customize sampling frequencies down to the millisecond layer.
- **Background Synchronous Logging:** Write multiple stream outputs sequentially with complete pipeline background persistence.
- **Clean Data Ingestion:** Export entire tracking sessions instantly into cleanly formatted `.csv` sheets or local SQLite dumps for instant processing in MATLAB, Python (Pandas), or Microsoft Excel.
- **Pre-Configured Environments:** Includes ready-to-go environment packages such as the **Vehicle Dynamics Lab** (G-Force, acceleration, velocity) and **Outdoor Explorer Lab** (altimeter, compass, position).
- **Dynamic Internationalization:** Fully configured with over 500+ localized tracking strings supporting English, Spanish, Japanese, and Khmer out-of-the-box.

---

## 📊 Popular Use Cases

> 💡 **Whether you're an engineer, automotive hobbyist, or research scientist, SensorLab simplifies raw hardware data acquisition.**

- **Automotive & Motorsports Testing:** Leverage high-frequency accelerometer and gyroscope telemetry alongside GPS tracking to analyze braking, cornering thresholds, and real-time vehicle velocity vectors.
- **Acoustic & Noise Pollution Mapping:** Use the Decibel Noise Meter for environmental inspections, classroom noise leveling, and industrial safety compliance checks.
- **Horticulture & Light Level Auditing:** Track exact ambient lumens via the Lux Plant Light Meter to determine ideal growing positions for interior greenhouse setups.
- **Academic STEM Research:** An ideal open-source **Physics Toolbox** alternative for universities and high schools to perform kinematics, magnetic field detection, and location tracking experiments without expensive custom instrumentation.

---

## 📚 Sensor Modules

| Hardware Target         | Core Package Dependency              | Primary Technical Application Target                                                  |
| :---------------------- | :----------------------------------- | :------------------------------------------------------------------------------------ |
| **Motion / Kinematics** | `sensors_plus`, `flutter_sensors`    | 3-Axis Accelerometer, Gyroscope angular rate, and Orientation matrices.               |
| **Location / Velocity** | `geolocator`, `location`             | Galileo / GLONASS GPS coordinates, speed vectors, and offline altimeter readings.     |
| **Environment**         | `light_sensor`, Native Streams       | Real-time ambient light monitoring (Lux) and proximity bounds detection.              |
| **Acoustic Sound**      | `flutter_sound`, `sound_level_meter` | Sound pressure monitoring, waveform calculation, and $dB$ analysis.                   |
| **Navigation**          | `sensors_plus`                       | Magnetometer-driven digital compass heading vectors and flux density.                 |
| **Biometrics**          | `camera` + Image Processing          | Frame-by-frame color variation monitoring via camera flash for heart-rate estimation. |

---

## 🏗️ Architecture

SensorLab leverages a highly decoupled, clean architecture built on **Provider / Riverpod** state management mechanics to ensure high-frequency UI updates don't compromise background data collection performance.

```text
SensorLab/
├── lib/
│   ├── main.dart                 # App initialization & routing gate
│   ├── models/                   # Pure immutable data payloads
│   │   ├── sensor_data.dart
│   │   └── session.dart
│   ├── providers/                # State management and UI dispatchers
│   │   ├── sensor_provider.dart
│   │   └── settings_provider.dart
│   ├── screens/                  # Modular view layout layer
│   │   ├── home_screen.dart
│   │   └── dashboard_screen.dart
│   ├── services/                 # Hardware access & business logic layer
│   │   ├── sensor_service.dart
│   │   └── csv_export_service.dart
│   └── widgets/                  # Reusable, atomic UI elements
└── assets/
    └── translations/             # Global localization maps (EN, ES, JA, KM)

```

---

## ⚙️ Quick Start

### System Prerequisites

- **Framework:** Flutter SDK `>=3.0.0` | Dart SDK `>=3.0.0`
- **Development Environment:** Android Studio (latest) or Xcode (for iOS targets)

### 1. Local Environment Cloned Setup

```bash
# Clone the repository
git clone [https://github.com/darahat-dev-Solutions/SensorLab.git](https://github.com/darahat-dev-Solutions/SensorLab.git)

# Navigate into the project root directory
cd SensorLab

# Install and link runtime dependencies
flutter pub get

```

### 2. Runtime Execution

Ensure your real hardware device or simulator target is properly mapped via `flutter devices`, then execute:

```bash
flutter run

```

---

## 🤝 Contributing

We highly encourage contributions from developers, researchers, and localization experts!

1. **Fork** the repository layer.
2. Setup a feature branch: `git checkout -b feature/AmazingPerformanceUpgrade`.
3. Keep logic clean, self-contained, and ensure all changes follow the [Official Flutter Code Style Guide](https://www.google.com/search?q=https://flutter.dev/docs/development/tools/formatting).
4. Issue a **Pull Request** explaining the structural modification.

---

## 📄 License

This framework codebase is distributed under the open-source **MIT License**. Check out the local `LICENSE` file for full compliance details.

---

⭐ **If SensorLab made your research workflow easier, consider leaving us a GitHub Star!**

_Crafted with precision by Darahat Dev Solutions._
