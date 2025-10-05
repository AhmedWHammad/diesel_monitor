class RealtimeData {
  final double flowRateIn;
  final double totalIn;
  final int activeSecondsIn;
  final double flowRateOut;
  final double totalOut;
  final int activeSecondsOut;

  RealtimeData({
    required this.flowRateIn,
    required this.totalIn,
    required this.activeSecondsIn,
    required this.flowRateOut,
    required this.totalOut,
    required this.activeSecondsOut,
  });

  factory RealtimeData.fromJson(Map<String, dynamic> json) {
    return RealtimeData(
      flowRateIn: (json['flowRateIn'] ?? 0).toDouble(),
      totalIn: (json['totalIn'] ?? 0).toDouble(),
      activeSecondsIn: (json['activeSecondsIn'] ?? 0).toInt(),
      flowRateOut: (json['flowRateOut'] ?? 0).toDouble(),
      totalOut: (json['totalOut'] ?? 0).toDouble(),
      activeSecondsOut: (json['activeSecondsOut'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flowRateIn': flowRateIn,
      'totalIn': totalIn,
      'activeSecondsIn': activeSecondsIn,
      'flowRateOut': flowRateOut,
      'totalOut': totalOut,
      'activeSecondsOut': activeSecondsOut,
    };
  }

  RealtimeData copyWith({
    double? flowRateIn,
    double? totalIn,
    int? activeSecondsIn,
    double? flowRateOut,
    double? totalOut,
    int? activeSecondsOut,
  }) {
    return RealtimeData(
      flowRateIn: flowRateIn ?? this.flowRateIn,
      totalIn: totalIn ?? this.totalIn,
      activeSecondsIn: activeSecondsIn ?? this.activeSecondsIn,
      flowRateOut: flowRateOut ?? this.flowRateOut,
      totalOut: totalOut ?? this.totalOut,
      activeSecondsOut: activeSecondsOut ?? this.activeSecondsOut,
    );
  }
}
