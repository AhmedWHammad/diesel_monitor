import 'dart:async';
import 'dart:io';
import 'package:udp/udp.dart';
import '../constants/api_constants.dart';

class UdpDiscovery {
  static Future<List<String>> discoverESP32({Duration timeout = const Duration(seconds: 5)}) async {
    final List<String> discoveredDevices = [];

    try {
      final sender = await UDP.bind(Endpoint.any(port: const Port(0)));
      final receiver = await UDP.bind(Endpoint.any(port: Port(ApiConstants.udpDiscoveryPort)));

      final completer = Completer<List<String>>();

      receiver.asStream(timeout: timeout).listen(
        (datagram) {
          if (datagram != null) {
            final data = String.fromCharCodes(datagram.data);
            if (data.contains('ESP32')) {
              final ip = datagram.address.address;
              if (!discoveredDevices.contains(ip)) {
                discoveredDevices.add(ip);
              }
            }
          }
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete(discoveredDevices);
          }
        },
        onError: (error) {
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
      );

      await sender.send(
        ApiConstants.udpDiscoveryMessage.codeUnits,
        Endpoint.broadcast(port: Port(ApiConstants.udpDiscoveryPort)),
      );

      await Future.delayed(timeout);

      sender.close();
      receiver.close();

      if (!completer.isCompleted) {
        completer.complete(discoveredDevices);
      }

      return await completer.future;
    } catch (e) {
      print('UDP Discovery error: $e');
      return discoveredDevices;
    }
  }
}
