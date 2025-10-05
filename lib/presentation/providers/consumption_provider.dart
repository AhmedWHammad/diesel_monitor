import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/summary_data.dart';
import '../../data/repositories/diesel_repository.dart';

enum ViewState { initial, loading, success, error }

class ConsumptionProvider extends ChangeNotifier {
  final DieselRepository _repository;
  Timer? _timer;

  ViewState _state = ViewState.initial;
  String? _errorMessage;
  SummaryData? _summaryData;

  ConsumptionProvider(this._repository);

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  SummaryData? get summaryData => _summaryData;

  void startAutoRefresh() {
    stopAutoRefresh();
    final interval = _repository.getUpdateInterval();
    _timer = Timer.periodic(Duration(seconds: interval * 2), (_) {
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

      final summary = await _repository.getSummaryData();
      _summaryData = summary;
      _state = ViewState.success;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
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
