import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/realtime_data.dart';
import '../../data/models/temperature_data.dart';
import '../../data/repositories/diesel_repository.dart';

enum ViewState { initial, loading, success, error }

class DashboardProvider extends ChangeNotifier {
  final DieselRepository _repository;
  Timer? _timer;

  ViewState _state = ViewState.initial;
  String? _errorMessage;
  RealtimeData? _realtimeData;
  TemperatureData? _temperatureData;
  bool _isConnected = false;

  DashboardProvider(this._repository);

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  RealtimeData? get realtimeData => _realtimeData;
  TemperatureData? get temperatureData => _temperatureData;
  bool get isConnected => _isConnected;

  void startAutoRefresh() {
    stopAutoRefresh();
    final interval = _repository.getUpdateInterval();
    _timer = Timer.periodic(Duration(seconds: interval), (_) {
      fetchData();
    });
    fetchData();
  }

  void stopAutoRefresh() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> fetchData() async {
    try {
      if (_state == ViewState.initial) {
        _state = ViewState.loading;
        notifyListeners();
      }

      final realtime = await _repository.getRealtimeData();
      final temperature = await _repository.getTemperatureData();

      _realtimeData = realtime;
      _temperatureData = temperature;
      _isConnected = true;
      _state = ViewState.success;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _isConnected = false;
      if (_state == ViewState.initial) {
        _state = ViewState.error;
      }
    }
    notifyListeners();
  }

  Future<void> retry() async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();
    await fetchData();
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }
}
