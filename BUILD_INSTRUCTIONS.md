# Complete Build Instructions for Diesel Monitor App

## Quick Start Guide

This guide will walk you through building the Diesel Monitor Flutter app from scratch, even if you've never used Flutter before.

## Step 1: Install Flutter

### Windows

1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/windows
2. Extract the zip file to `C:\src\flutter`
3. Add Flutter to your PATH:
   - Search for "Environment Variables" in Windows
   - Click "Environment Variables"
   - Under "User variables", find "Path"
   - Click "Edit" and add: `C:\src\flutter\bin`
4. Open a new Command Prompt and run: `flutter doctor`

### macOS

1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/macos
2. Extract the file to desired location
3. Add to PATH by editing `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export PATH="$PATH:[PATH_TO_FLUTTER_DIRECTORY]/flutter/bin"
   ```
4. Run: `flutter doctor`

### Linux

1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/linux
2. Extract and add to PATH
3. Run: `flutter doctor`

## Step 2: Install Android Studio

1. Download Android Studio from: https://developer.android.com/studio
2. Install Android Studio
3. Open Android Studio
4. Go to: Settings → Plugins → Install "Flutter" and "Dart" plugins
5. Go to: Settings → Appearance & Behavior → System Settings → Android SDK
6. Install:
   - Android SDK Platform 34 (Android 14)
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   - Android SDK Tools

## Step 3: Accept Android Licenses

Open a terminal and run:
```bash
flutter doctor --android-licenses
```

Accept all licenses by typing 'y' when prompted.

## Step 4: Verify Installation

Run:
```bash
flutter doctor
```

You should see green checkmarks for:
- Flutter
- Android toolchain
- Android Studio

## Step 5: Open the Project

1. Open Android Studio
2. Click "Open"
3. Navigate to the `diesel_monitor` folder
4. Click "OK"

## Step 6: Get Dependencies

### Option A - Via Terminal:
```bash
cd diesel_monitor
flutter pub get
```

### Option B - Via Android Studio:
- Open `pubspec.yaml`
- Click "Pub get" in the top bar

## Step 7: Generate Localization Files

Run:
```bash
flutter gen-l10n
```

## Step 8: Connect Your Android Device

### Using Physical Device:
1. Enable Developer Options on your Android device:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
2. Enable USB Debugging:
   - Go to Settings → Developer Options
   - Enable "USB Debugging"
3. Connect your device via USB
4. Authorize the computer on your device

### Using Android Emulator:
1. In Android Studio, click the Device Manager icon
2. Click "Create Device"
3. Select a device (e.g., Pixel 5)
4. Select a system image (API 34 recommended)
5. Click "Finish"
6. Start the emulator

## Step 9: Build the APK

### Method 1: Debug APK (for testing)

Via Terminal:
```bash
flutter build apk --debug
```

Via Android Studio:
- Go to: Build → Flutter → Build APK

### Method 2: Release APK (for production)

Via Terminal:
```bash
flutter build apk --release
```

### Method 3: Optimized APK (recommended)

Via Terminal:
```bash
flutter build apk --release --split-per-abi
```

This creates smaller APKs for each processor type.

## Step 10: Locate Your APK

After building, find your APK at:

**Debug:**
```
diesel_monitor/build/app/outputs/flutter-apk/app-debug.apk
```

**Release:**
```
diesel_monitor/build/app/outputs/flutter-apk/app-release.apk
```

**Split APKs:**
```
diesel_monitor/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
diesel_monitor/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
diesel_monitor/build/app/outputs/flutter-apk/app-x86_64-release.apk
```

For most modern Android phones, use `app-arm64-v8a-release.apk`.

## Step 11: Install the APK

### Method 1: Direct Installation (if device is connected)
```bash
flutter install
```

### Method 2: Manual Installation
1. Transfer the APK to your Android device
2. On the device, use a File Manager to locate the APK
3. Tap the APK file
4. If prompted, allow installation from unknown sources
5. Tap "Install"

## Common Issues and Solutions

### Issue: "Flutter not found"
**Solution:** Make sure Flutter is added to your system PATH and restart your terminal.

### Issue: "Android SDK not found"
**Solution:**
1. Open Android Studio
2. Go to Settings → Android SDK
3. Note the "Android SDK Location"
4. Set ANDROID_HOME environment variable to this location

### Issue: "License not accepted"
**Solution:** Run `flutter doctor --android-licenses` and accept all.

### Issue: Build fails with "Gradle error"
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

### Issue: "No connected devices"
**Solution:**
- For physical device: Check USB debugging is enabled and device is authorized
- For emulator: Start the emulator from Android Studio Device Manager

### Issue: App crashes on launch
**Solution:**
- Ensure minimum Android version is 7.0 (API 24) or higher
- Check device has sufficient storage
- Review logs: `flutter logs`

## Build Verification Checklist

Before distributing your APK, verify:

- [ ] APK builds without errors
- [ ] APK installs on test device
- [ ] App launches successfully
- [ ] All screens load correctly
- [ ] Settings screen opens and saves
- [ ] Network permissions are working
- [ ] App doesn't crash on startup
- [ ] Arabic and English languages work
- [ ] Dark/Light themes work

## APK Size Optimization

Your APK sizes should be approximately:
- **Debug APK**: ~50-60 MB
- **Release APK**: ~20-25 MB
- **Split APKs**: ~15-18 MB each

If significantly larger, try:
```bash
flutter build apk --release --shrink
```

## Testing the App

### Test Without ESP32 Connection:
1. Install the APK
2. Open the app
3. Navigate to Settings
4. Enter a dummy IP (e.g., 192.168.1.100)
5. Enter credentials: admin / 1234
6. Tap Save (will fail to connect, but UI should work)

### Test With ESP32 Connection:
1. Ensure ESP32 is powered and connected to WiFi
2. Note the ESP32's IP address
3. Open the app → Settings
4. Use Auto Discover or enter IP manually
5. Enter correct credentials
6. Tap Save
7. Navigate to Dashboard to see real-time data

## Advanced: Signing the APK

For production release with your own signature:

1. Create a keystore:
```bash
keytool -genkey -v -keystore diesel-monitor.keystore -alias dieselmonitor -keyalg RSA -keysize 2048 -validity 10000
```

2. Create `android/key.properties`:
```properties
storePassword=<your-password>
keyPassword=<your-password>
keyAlias=dieselmonitor
storeFile=<path-to-keystore>
```

3. Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

4. Build:
```bash
flutter build apk --release
```

## Next Steps

After successfully building and installing:

1. **Configure ESP32 Connection**:
   - Open app → Settings
   - Enter ESP32 IP or use Auto Discover
   - Enter credentials and save

2. **Test All Features**:
   - Dashboard real-time monitoring
   - Consumption statistics
   - Pump control
   - Stepper motor control

3. **Customize if Needed**:
   - Change app colors in `lib/core/constants/app_colors.dart`
   - Modify update intervals in Settings
   - Adjust theme preferences

## Support Resources

- Flutter Documentation: https://docs.flutter.dev
- Android Studio Guide: https://developer.android.com/studio/intro
- Flutter Community: https://flutter.dev/community

## Build Time Expectations

- **First build**: 5-15 minutes (downloads dependencies)
- **Subsequent builds**: 1-3 minutes
- **Hot reload (development)**: < 1 second

---

**Congratulations!** You should now have a working APK ready to install on Android devices.

For any issues, refer to the troubleshooting section or run `flutter doctor -v` for detailed diagnostics.
