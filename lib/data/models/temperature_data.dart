class TemperatureData {
  final double temp1;
  final double temp2;

  TemperatureData({
    required this.temp1,
    required this.temp2,
  });

  factory TemperatureData.fromJson(Map<String, dynamic> json) {
    return TemperatureData(
      temp1: (json['temp1'] ?? 0).toDouble(),
      temp2: (json['temp2'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp1': temp1,
      'temp2': temp2,
    };
  }

  TemperatureData copyWith({
    double? temp1,
    double? temp2,
  }) {
    return TemperatureData(
      temp1: temp1 ?? this.temp1,
      temp2: temp2 ?? this.temp2,
    );
  }

  double toFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  double getTemp1InFahrenheit() => toFahrenheit(temp1);
  double getTemp2InFahrenheit() => toFahrenheit(temp2);
}
