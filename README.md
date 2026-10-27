# 📱 QR Code Scanner & Generator

<p align="center">
  <img src="screenshots/app_logo.png" alt="QR Scanner Logo" width="180" />
</p>

<p align="center">
  <b>A high-performance Flutter mobile application for scanning, generating, styling, and managing QR codes.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge" alt="Platforms" />
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License" />
</p>

---

## ✨ Key Features

- ⚡ **Instant Camera Scanning**: High-speed real-time barcode & QR recognition with flash toggle and camera flip.
- 🎨 **Custom QR Code Generator**: Generate customized QR codes for multiple data formats:
  - 🌐 Websites & URLs
  - 📶 Wi-Fi Networks (SSID, Password, Encryption)
  - 📞 Phone Numbers & SMS
  - 📧 Emails & Contact Cards (vCard)
  - 📝 Plain Text & Clipboard content
- 💾 **Scan History & Favorites**: Auto-saves past scans locally for quick offline access and re-sharing.
- ✨ **Fluid Lottie Animations**: Integrated micro-animations for interactive user feedback.

---

## 🛠️ Architecture & Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Null-safe Dart)
- **Scanning Engine**: `mobile_scanner` / `qr_code_scanner`
- **QR Generation**: `qr_flutter`
- **Animations**: `lottie` animations
- **Local Storage**: `shared_preferences` / SQLite for scan logs

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.0.0`)
- Camera permissions enabled on device/emulator

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/bscs1190-max/Qr_scanner_and_generator_app.git
   cd Qr_scanner_and_generator_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

---

## 📜 License

This project is licensed under the MIT License.
