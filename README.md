# SensorLab - Sensor Box, Sensor Data Logger, GPS Speedometer, Decibel Meter & Physics Toolbox

<div align="center">

<a href="https://play.google.com/store/apps/details?id=com.darahat.sensorlab&pcampaignid=web_share" target="_blank" rel="noopener noreferrer">
    <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Get SensorLab on Google Play" width="250"/>
</a>

### 📥 [Click Here To Download SensorLab on the Google Play Store](https://play.google.com/store/apps/details?id=com.darahat.sensorlab&pcampaignid=web_share)

---

### 📺 [Watch the SensorLab App Demo on YouTube Shorts](https://youtube.com/shorts/Cg61mOv7f5E?si=MJH5xqOO18PsVV)

<a href="https://youtube.com/shorts/Cg61mOv7f5E?si=MJH5xqOO18PsVV" target="_blank" rel="noopener noreferrer">
    <img src="SensorLab (3).png" alt="SensorLab Sensor Box GPS Speedometer Decibel Meter Physics Toolbox Demo" width="100%" />
</a>

---

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

_An advanced all-in-one Sensor Box and raw sensor data logger built with Flutter. Turn your smartphone into a comprehensive physics experiment lab with a GPS Speedometer, Decibel Meter, Accelerometer, Gyroscope Tester, and more._

[🚀 App Features](#-features) • [📋 Requirements](#-requirements) • [⚙️ Setup](#️-setup) • [🏗️ Architecture](#️-architecture) • [📚 Sensor Modules](#-modules) • [🤝 Contributing](#-contributing)

</div>

---

## 🚀 Features

### 🧪 **Custom Sensor Lab Builder & Data Logger**

- **Create Your Own Lab:** Easily stack multiple device hardware sensors together inside a custom user dashboard.
- **Raw Sensor Data Recording:** Start and stop real-time background recording sessions seamlessly.
- **CSV Data Export:** Instantly download or share full session logs via `.csv` file format for advanced physics experiments, vehicle diagnostics, and environmental monitoring in Excel or MATLAB.

### 📦 **Pre-Built Physics & Engineering Templates**

- **🏎️ Vehicle Dynamics Lab:** Live telemetry tracking using the Accelerometer Sensor App, Gyroscope, GPS Speedometer, and Magnetometer Sensor to monitor cornering velocity, braking power, and G-force.
- **🏔️ Outdoor Explorer Lab:** Essential offline tracking using the GPS Speedometer, Altimeter (altitude meter), Speedometer, and Compass.

### 🌐 **Multi-Language Support (Global Localization)**

- **4 Languages Out-of-the-Box**: English, Spanish, Japanese, and Khmer.
- **500+ Localized Strings**: Complete internationalization setup.
- **Dynamic Language Switching**: Toggle system languages instantly on-the-fly.

### 📊 **Comprehensive All-In-One Sensor Box Suite**

- **Motion & Acceleration Sensors**: 3-Axis Accelerometer sensor, Gyroscope calibration monitor, Magnetometer sensor (magnetic field detector).
- **Environmental Instruments**: Lux Light Meter (with custom indoor plant light meter capabilities), Humidity sensor, Noise Meter (Decibel measurement tool), and Proximity detection.
- **Location & Navigation**: Galileo GPS Speedometer, live location tracker, and mobile compass.
- **Health & Fitness Tools**: Heart rate monitor via device camera, step tracker, activity tracker, and calorie counter.
- **Utility Shortcuts**: QR/Barcode scanner and high-powered flashlight toggles.

### 🎨 **Modern UI/UX**

- **Material Design 3**: Fully optimized visual components.
- **Dark/Light Themes**: System-adaptive automatic theming.
- **Responsive Layout**: Optimized layout structure for both budget Android phones and premium iOS tablets.

---

## Popular Use Cases

- **Sensor Data Logger** for research and engineering projects.
- **GPS Speedometer App** for vehicle testing, cycling, running, and hiking.
- **Speed Meter** and **G-Force Meter** for automotive and motorsport diagnostics.
- **Decibel Meter** and **Noise Meter** for classroom experiments, workplace safety, and motorcycle exhaust testing.
- **Accelerometer Sensor App** and **Gyroscope Tester** for motion analysis and device hardware checks.
- **Magnetometer Sensor** and **Magnetic Field Detector** for metal detection and magnetic field mapping.
- **Physics Toolbox Alternative** for STEM education and student projects.
- **Lux Light Meter** and **Plant Light Meter** for monitoring indoor lighting and plant growth environments.
- **Altimeter Offline** and **Barometer and Altimeter App** for hiking, trekking, climbing, and outdoor exploration.
- **Mobile Sensor Checker** for testing device hardware functionality.
- **Engineering Tools** and **Environmental Monitoring** for professional and hobbyist use.

---

## 📋 Requirements

### **System Requirements**

- **Flutter SDK**: `>=3.0.0`
- **Dart SDK**: `>=3.0.0`
- **Android Studio**: Latest version (for Android app builds)
- **Xcode**: Latest version (for iOS development, macOS only)

### **Platform Support**

| Platform    | Minimum Version            | Recommended Target          |
| ----------- | -------------------------- | --------------------------- |
| **Android** | API Level 21 (Android 5.0) | API Level 33+ (Android 13+) |
| **iOS**     | iOS 11.0                   | iOS 15.0+                   |
| **Web**     | Modern browsers            | Chrome 90+                  |

### **Hardware Requirements**

- **RAM**: 8GB minimum for compilation, 16GB recommended
- **Storage**: 10GB free space
- **Processor**: Intel i5 / AMD Ryzen 5 or better

---

## ⚙️ Setup & Installation

### **1. Prerequisites Setup**

#### Install Flutter SDK

```bash
# Add Flutter to your PATH environment variables
export PATH="$PATH:`pwd`/flutter/bin"

# Verify your framework installation
flutter doctor
```
