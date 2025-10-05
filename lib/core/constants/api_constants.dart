class ApiConstants {
  static const String loginEndpoint = '/login';
  static const String realtimeEndpoint = '/realtime';
  static const String summaryEndpoint = '/summary';
  static const String temperatureEndpoint = '/temperature';
  static const String ipEndpoint = '/ip';
  static const String pumpEndpoint = '/pump';
  static const String stepperEndpoint = '/stepper';

  static const int defaultTimeout = 5;
  static const int udpDiscoveryPort = 4210;
  static const String udpDiscoveryMessage = 'DISCOVER_ESP32';

  static const Duration defaultConnectTimeout = Duration(seconds: 5);
  static const Duration defaultReceiveTimeout = Duration(seconds: 3);
}
