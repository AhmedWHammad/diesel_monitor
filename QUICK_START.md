# 🚀 Quick Start Guide - Diesel Monitor App

## ⚡ Super Fast Setup (5 Minutes)

### Step 1: Prerequisites ✓
- [ ] Flutter SDK installed ([Get Flutter](https://flutter.dev/docs/get-started/install))
- [ ] Android Studio installed ([Get Android Studio](https://developer.android.com/studio))
- [ ] Android device/emulator available

### Step 2: Open Project 📂
```bash
cd diesel_monitor
```

### Step 3: Install Dependencies 📦
```bash
flutter pub get
flutter gen-l10n
```

### Step 4: Build APK 🔨
```bash
# Quick build (recommended)
flutter build apk --release

# Or optimized build (smaller size)
flutter build apk --release --split-per-abi
```

### Step 5: Install 📱
```bash
# If device is connected
flutter install

# Or manually transfer APK from:
# build/app/outputs/flutter-apk/app-release.apk
```

### Step 6: Configure App ⚙️
1. Open Diesel Monitor app
2. Go to Settings tab (bottom-right)
3. Enter ESP32 IP address or tap "Auto Discover"
4. Enter credentials (default: admin / 1234)
5. Tap "Save"
6. Go to Dashboard tab to view data!

---

## 📋 Command Cheat Sheet

### Build Commands
```bash
# Debug build (for testing)
flutter build apk --debug

# Release build (for production)
flutter build apk --release

# Optimized build (smaller size)
flutter build apk --release --split-per-abi

# Clean build (if issues occur)
flutter clean && flutter pub get && flutter build apk --release
```

### Development Commands
```bash
# Run in development mode
flutter run

# Check Flutter setup
flutter doctor

# Update Flutter
flutter upgrade

# See device logs
flutter logs
```

### Troubleshooting Commands
```bash
# Clean project
flutter clean

# Reinstall dependencies
flutter pub get

# Accept Android licenses
flutter doctor --android-licenses

# Check devices
flutter devices
```

---

## 🎯 APK Locations

After building, find your APK here:

**Release APK**:
```
diesel_monitor/build/app/outputs/flutter-apk/app-release.apk
```

**Split APKs** (choose one based on device):
```
app-arm64-v8a-release.apk    # Most modern phones (2017+)
app-armeabi-v7a-release.apk  # Older phones
app-x86_64-release.apk       # Emulators/Intel devices
```

💡 **Tip**: Use `arm64-v8a` for 99% of modern Android devices

---

## 🔧 Default Configuration

| Setting | Default Value |
|---------|--------------|
| Username | admin |
| Password | 1234 |
| Language | Arabic (العربية) |
| Theme | Light |
| Update Interval | 3 seconds |
| Temperature Unit | Celsius |

---

## 📱 First Run Checklist

After installing the app:

1. **Settings Tab**:
   - [ ] Enter ESP32 IP address
   - [ ] Enter username and password
   - [ ] Tap "Save"
   - [ ] Wait for "Connected successfully!" message

2. **Dashboard Tab**:
   - [ ] Verify connection status shows "Connected"
   - [ ] Check flow rates are updating
   - [ ] Confirm temperature readings appear

3. **Consumption Tab**:
   - [ ] View daily/weekly/monthly data
   - [ ] Check bar charts display

4. **Control Tab**:
   - [ ] Test pump ON/OFF (if safe to do so)
   - [ ] Adjust stepper motor position
   - [ ] Verify controls respond

---

## 🆘 Quick Troubleshooting

### Build fails?
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Can't install APK?
- Enable "Install from Unknown Sources" in Android settings
- Check device has Android 7.0 or higher

### App crashes?
```bash
flutter logs
```
Check the error messages

### Can't connect to ESP32?
- Verify ESP32 is powered on
- Check both devices on same WiFi network
- Try "Auto Discover" in Settings
- Ping ESP32 IP from phone browser

### No data showing?
- Check connection status at top-right of Dashboard
- Verify ESP32 is responding to API requests
- Try pulling down to refresh

---

## 🌐 Network Setup

### ESP32 Requirements:
- Connected to WiFi network
- HTTP server running
- API endpoints responding
- Same network as Android device

### Test ESP32 Connection:
1. Open browser on phone
2. Go to: `http://[ESP32_IP]/ip`
3. Should return ESP32's IP address

---

## 📸 Screenshots Expected

After successful setup, you should see:

**Dashboard**:
- Animated tank with liquid level
- Flow rate indicators (inlet/outlet)
- Temperature gauges (box & motor)
- Green "Connected" badge

**Consumption**:
- Daily/Weekly/Monthly summary cards
- Bar chart comparing inlet vs outlet
- Efficiency percentages

**Control**:
- Pump ON/OFF buttons
- Auto-fill section with target input
- Stepper motor slider (0-100%)
- Quick position buttons

**Settings**:
- IP address input field
- Auto Discover button
- Username/Password fields
- Theme and language toggles

---

## 💡 Pro Tips

1. **Update Interval**: Adjust in Settings for faster/slower data refresh
2. **Dark Mode**: Perfect for nighttime monitoring
3. **Language**: Switch between Arabic and English anytime
4. **Auto-Fill**: Set target liters and let pump fill automatically
5. **Pull to Refresh**: Swipe down on any screen to refresh data

---

## 📞 Need Help?

### Check These First:
1. Run `flutter doctor` - all green?
2. Android device API 24+ (Android 7.0+)?
3. ESP32 on same WiFi network?
4. ESP32 API endpoints responding?

### Useful Commands:
```bash
# Check Flutter installation
flutter doctor -v

# Check connected devices
flutter devices

# See detailed logs
flutter logs

# Check APK info
aapt dump badging app-release.apk
```

---

## ✅ Success Criteria

Your setup is successful when:
- ✅ APK builds without errors
- ✅ APK installs on device
- ✅ App launches without crashing
- ✅ Settings screen allows IP entry
- ✅ Dashboard shows "Connected" status
- ✅ Real-time data updates automatically
- ✅ All tabs are accessible
- ✅ Language and theme changes work

---

## 🎉 You're Done!

If you can see real-time flow rates and temperature data on the Dashboard, congratulations! Your Diesel Monitor app is working perfectly.

**Next Steps**:
- Explore all features
- Customize settings to your preference
- Monitor your diesel tank with confidence

---

**Build Time**: ~3-5 minutes (first build)
**Total Setup**: ~5-10 minutes
**Difficulty**: ⭐⭐☆☆☆ (Easy)

Happy Monitoring! 🛢️📊
