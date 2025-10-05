import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_service.dart';
import '../models/realtime_data.dart';
import '../models/summary_data.dart';
import '../models/temperature_data.dart';

class DieselRepository {
  final ApiService _apiService;
  final SharedPreferences _prefs;

  DieselRepository(this._apiService, this._prefs);

  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiService.login(username, password);
      final success = response['status'] == 'ok';

      if (success) {
        await _prefs.setString('username', username);
        await _prefs.setString('password', password);
        await _prefs.setBool('is_logged_in', true);
      }

      return success;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<RealtimeData> getRealtimeData() async {
    final data = await _apiService.getRealtimeData();
    return RealtimeData.fromJson(data);
  }

  Future<SummaryData> getSummaryData() async {
    final data = await _apiService.getSummaryData();
    return SummaryData.fromJson(data);
  }

  Future<TemperatureData> getTemperatureData() async {
    final data = await _apiService.getTemperatureData();
    return TemperatureData.fromJson(data);
  }

  Future<String> getIpAddress() async {
    return await _apiService.getIpAddress();
  }

  Future<bool> controlPump(String mode, {double? target}) async {
    try {
      final response = await _apiService.controlPump(mode: mode, target: target);
      return response['status'] == 'ok';
    } catch (e) {
      print('Pump control error: $e');
      return false;
    }
  }

  Future<bool> controlStepper(int position) async {
    try {
      final response = await _apiService.controlStepper(position);
      return response['status'] == 'ok';
    } catch (e) {
      print('Stepper control error: $e');
      return false;
    }
  }

  String? getSavedIpAddress() {
    return _prefs.getString('esp32_ip');
  }

  Future<void> saveIpAddress(String ip) async {
    await _prefs.setString('esp32_ip', ip);
  }

  bool isLoggedIn() {
    return _prefs.getBool('is_logged_in') ?? false;
  }

  String? getSavedUsername() {
    return _prefs.getString('username');
  }

  String? getSavedPassword() {
    return _prefs.getString('password');
  }

  Future<void> logout() async {
    await _prefs.setBool('is_logged_in', false);
  }

  int getUpdateInterval() {
    return _prefs.getInt('update_interval') ?? 3;
  }

  Future<void> setUpdateInterval(int seconds) async {
    await _prefs.setInt('update_interval', seconds);
  }

  bool isCelsius() {
    return _prefs.getBool('use_celsius') ?? true;
  }

  Future<void> setTemperatureUnit(bool celsius) async {
    await _prefs.setBool('use_celsius', celsius);
  }

  bool isDarkMode() {
    return _prefs.getBool('dark_mode') ?? false;
  }

  Future<void> setDarkMode(bool dark) async {
    await _prefs.setBool('dark_mode', dark);
  }

  String getLanguage() {
    return _prefs.getString('language') ?? 'ar';
  }

  Future<void> setLanguage(String language) async {
    await _prefs.setString('language', language);
  }

  bool getRememberMe() {
    return _prefs.getBool('remember_me') ?? false;
  }

  Future<void> setRememberMe(bool remember) async {
    await _prefs.setBool('remember_me', remember);
  }
}
