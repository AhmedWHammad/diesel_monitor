# Diesel Tank Monitor - Flutter App

A complete, production-ready Flutter application for monitoring and controlling a Smart Diesel Tank Monitoring System via ESP32 WiFi connection.

## Features

- **Real-time Dashboard**: Monitor flow rates, tank levels, and temperatures with animated widgets
- **Consumption Tracking**: View daily, weekly, and monthly consumption statistics with charts
- **Remote Control**: Control pump operations and stepper motor positioning
- **Auto-Fill Mode**: Automatic pump control to reach target fuel levels
- **Multi-language Support**: Arabic (RTL) and English
- **Dark/Light Theme**: User-selectable themes
- **Auto-Discovery**: UDP broadcast discovery for ESP32 devices
- **Offline Mode**: Cached data display when disconnected

## Prerequisites

Before building the app, ensure you have:

- Flutter SDK 3.16 or newer ([Installation Guide](https://flutter.dev/docs/get-started/install))
- Android Studio or VS Code with Flutter extensions
- Android SDK with API level 34
- Java Development Kit (JDK) 8 or higher
- An Android device or emulator (API 24+)

## Installation & Setup

### 1. Extract the Project

Extract the `diesel_monitor` folder to your desired location.

### 2. Install Flutter Dependencies

Open a terminal in the project directory and run:

```bash
cd diesel_monitor
flutter pub get
```

This will download all required packages specified in `pubspec.yaml`.

### 3. Generate Localization Files

Run the following command to generate localization files:

```bash
flutter gen-l10n
```

### 4. Verify Flutter Installation

Check that Flutter is properly configured:

```bash
flutter doctor
```

Address any issues reported by Flutter Doctor before proceeding.

## Building the APK

### Debug Build (for testing)

```bash
flutter build apk --debug
```

The APK will be located at: `build/app/outputs/flutter-apk/app-debug.apk`

### Release Build (for production)

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

### Split APKs by ABI (smaller file size)

```bash
flutter build apk --split-per-abi --release
```

This creates separate APKs for different CPU architectures in:
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

## Installing the APK

### Install on Connected Device

```bash
flutter install
```

Or manually transfer the APK to your device and install it.

### Enable Unknown Sources

On your Android device:
1. Go to Settings → Security
2. Enable "Install from Unknown Sources" or "Install Unknown Apps"
3. Navigate to the APK file and install

## Running in Development Mode

To run the app in development mode with hot reload:

```bash
flutter run
```

Or press F5 in VS Code / Android Studio.

## First-Time Configuration

1. **Launch the App**: Open the Diesel Monitor app on your device

2. **Navigate to Settings**: Tap the Settings icon in the bottom navigation

3. **Configure Connection**:
   - **Option A - Manual Entry**: Enter your ESP32 IP address (e.g., 192.168.1.100)
   - **Option B - Auto-Discovery**: Tap "Auto Discover" to scan for ESP32 devices on your network

4. **Enter Credentials**:
   - Username: `admin` (default)
   - Password: `1234` (default)
   - Enable "Remember Me" to save credentials

5. **Save Configuration**: Tap the "Save" button

6. **Navigate to Dashboard**: Once connected, switch to the Dashboard tab to view real-time data

## App Structure

```
diesel_monitor/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── core/                              # Core functionality
│   │   ├── constants/                     # App constants
│   │   ├── network/                       # API service & Dio client
│   │   └── utils/                         # UDP discovery
│   ├── data/                              # Data layer
│   │   ├── models/                        # Data models
│   │   └── repositories/                  # Repository pattern
│   ├── presentation/                      # UI layer
│   │   ├── providers/                     # State management
│   │   ├── screens/                       # App screens
│   │   └── widgets/                       # Reusable widgets
│   └── l10n/                              # Localization files
├── android/                               # Android configuration
└── assets/                                # Static assets
```

## API Endpoints

The app connects to the following ESP32 endpoints:

| Endpoint        | Method | Description                    |
|----------------|--------|--------------------------------|
| `/login`       | POST   | Authenticate user              |
| `/realtime`    | GET    | Get real-time sensor data      |
| `/summary`     | GET    | Get consumption summaries      |
| `/temperature` | GET    | Get temperature readings       |
| `/pump`        | POST   | Control pump (on/off/auto)     |
| `/stepper`     | POST   | Control stepper motor position |
| `/ip`          | GET    | Get ESP32 IP address           |

## Screens Overview

### Dashboard Screen
- Real-time flow rates (inlet/outlet)
- Animated tank level visualization
- Temperature gauges with color-coded status
- Connection status indicator
- Pull-to-refresh support

### Consumption Screen
- Daily/weekly/monthly consumption cards
- Bar charts comparing inlet vs outlet
- Efficiency percentage calculations
- Historical data visualization

### Control Screen
- Pump control (ON/OFF buttons)
- Auto-fill mode with target liter input
- Stepper motor slider control (0-100%)
- Quick position buttons (0%, 25%, 50%, 75%, 100%)
- Confirmation dialogs for safety

### Settings Screen
- ESP32 IP address configuration
- UDP auto-discovery
- Authentication credentials
- Update interval adjustment
- Temperature unit selection (°C/°F)
- Theme selection (Light/Dark)
- Language selection (Arabic/English)

## Troubleshooting

### APK Won't Install
- Ensure "Install from Unknown Sources" is enabled
- Check that your device meets minimum requirements (Android 7.0+)
- Try uninstalling any previous version

### Connection Issues
- Verify ESP32 is powered on and connected to the same WiFi network
- Check the IP address is correct
- Ensure firewall isn't blocking connections
- Try auto-discovery to find the device

### Build Errors
- Run `flutter clean` then `flutter pub get`
- Update Flutter: `flutter upgrade`
- Check `flutter doctor` for configuration issues

### App Crashes
- Check logcat: `flutter logs` or `adb logcat`
- Ensure ESP32 API responses match expected JSON format
- Verify network permissions in AndroidManifest.xml

## Network Requirements

- ESP32 and Android device must be on the same local network
- HTTP traffic must be allowed (cleartext traffic enabled in manifest)
- UDP port 4210 must be accessible for auto-discovery
- No firewall blocking ports used by ESP32

## Permissions

The app requires the following Android permissions:
- `INTERNET` - Network communication
- `ACCESS_NETWORK_STATE` - Check network connectivity
- `ACCESS_WIFI_STATE` - WiFi information
- `CHANGE_WIFI_MULTICAST_STATE` - UDP discovery

## Customization

### Change App Name
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
android:label="Your App Name"
```

### Change App Icon
Replace icon files in:
- `android/app/src/main/res/mipmap-*/ic_launcher.png`

### Change App Package
1. Update `android/app/build.gradle`: `applicationId "com.yourcompany.yourapp"`
2. Rename package directories and update imports

### Modify Theme Colors
Edit `lib/core/constants/app_colors.dart` to change color scheme.

## Performance Optimization

- Auto-refresh interval is configurable (1-10 seconds)
- Charts are optimized for smooth rendering
- Images and assets are properly compressed
- Network requests include timeout handling

## Security Considerations

- HTTPS should be used in production (currently HTTP for local network)
- Credentials are stored in SharedPreferences (encrypted on device)
- Consider implementing proper authentication tokens
- Validate all user inputs before sending to ESP32

## Support

For issues, questions, or feature requests:
1. Check the troubleshooting section above
2. Review ESP32 API documentation
3. Verify network connectivity and configuration
4. Check Flutter logs for detailed error messages

## Version Information

- **App Version**: 1.0.0
- **Build Number**: 1
- **Minimum Android**: 7.0 (API 24)
- **Target Android**: 14 (API 34)
- **Flutter SDK**: 3.16+
- **Dart SDK**: 3.1.0+

## License

This project is provided as-is for use with the Smart Diesel Tank Monitoring System.

---

**Built with Flutter** - For any technical support, ensure your Flutter installation is up-to-date and properly configured.
