import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class DioClient {
  static Dio createDio(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.defaultConnectTimeout,
        receiveTimeout: ApiConstants.defaultReceiveTimeout,
        contentType: 'application/json',
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        error: true,
        logPrint: (obj) => print('[DIO] $obj'),
      ),
    );

    return dio;
  }
}
