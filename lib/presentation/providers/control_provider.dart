import 'package:flutter/material.dart';
import '../../data/repositories/diesel_repository.dart';

class ControlProvider extends ChangeNotifier {
  final DieselRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  String _pumpMode = 'off';
  int _stepperPosition = 0;
  double _targetLiters = 0;
  bool _isAutoFilling = false;

  ControlProvider(this._repository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get pumpMode => _pumpMode;
  int get stepperPosition => _stepperPosition;
  double get targetLiters => _targetLiters;
  bool get isAutoFilling => _isAutoFilling;

  void setTargetLiters(double value) {
    _targetLiters = value;
    notifyListeners();
  }

  Future<bool> turnPumpOn() async {
    return await _controlPump('on');
  }

  Future<bool> turnPumpOff() async {
    return await _controlPump('off');
  }

  Future<bool> startAutoFill() async {
    if (_targetLiters <= 0) {
      _errorMessage = 'Please set target liters';
      notifyListeners();
      return false;
    }

    final success = await _controlPump('auto', target: _targetLiters);
    if (success) {
      _isAutoFilling = true;
    }
    return success;
  }

  Future<bool> stopAutoFill() async {
    final success = await _controlPump('off');
    if (success) {
      _isAutoFilling = false;
    }
    return success;
  }

  Future<bool> _controlPump(String mode, {double? target}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.controlPump(mode, target: target);
      if (success) {
        _pumpMode = mode;
      } else {
        _errorMessage = 'Failed to control pump';
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> setStepperPosition(int position) async {
    if (position < 0 || position > 100) {
      _errorMessage = 'Position must be between 0 and 100';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.controlStepper(position);
      if (success) {
        _stepperPosition = position;
      } else {
        _errorMessage = 'Failed to control stepper';
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
