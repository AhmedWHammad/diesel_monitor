import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'dio_client.dart';

class ApiService {
  late Dio _dio;
  String _baseUrl = '';

  void initialize(String baseUrl) {
    _baseUrl = baseUrl.startsWith('http') ? baseUrl : 'http://$baseUrl';
    _dio = DioClient.createDio(_baseUrl);
  }

  String get baseUrl => _baseUrl;

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'user': username,
          'pass': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getRealtimeData() async {
    try {
      final response = await _dio.get(ApiConstants.realtimeEndpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getSummaryData() async {
    try {
      final response = await _dio.get(ApiConstants.summaryEndpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getTemperatureData() async {
    try {
      final response = await _dio.get(ApiConstants.temperatureEndpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> getIpAddress() async {
    try {
      final response = await _dio.get(ApiConstants.ipEndpoint);
      return response.data['ip'] ?? '';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> controlPump({
    required String mode,
    double? target,
  }) async {
    try {
      final data = <String, dynamic>{'mode': mode};
      if (target != null) {
        data['target'] = target;
      }
      final response = await _dio.post(
        ApiConstants.pumpEndpoint,
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> controlStepper(int position) async {
    try {
      final response = await _dio.post(
        ApiConstants.stepperEndpoint,
        data: {'position': position},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Bad response: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error: ${error.message}';
    }
  }
}
