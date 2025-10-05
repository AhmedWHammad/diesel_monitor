class SummaryData {
  final double totalLitersIn;
  final double dailyIn;
  final double weeklyIn;
  final double monthlyIn;
  final double totalLitersOut;
  final double dailyOut;
  final double weeklyOut;
  final double monthlyOut;

  SummaryData({
    required this.totalLitersIn,
    required this.dailyIn,
    required this.weeklyIn,
    required this.monthlyIn,
    required this.totalLitersOut,
    required this.dailyOut,
    required this.weeklyOut,
    required this.monthlyOut,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      totalLitersIn: (json['totalLitersIn'] ?? 0).toDouble(),
      dailyIn: (json['dailyIn'] ?? 0).toDouble(),
      weeklyIn: (json['weeklyIn'] ?? 0).toDouble(),
      monthlyIn: (json['monthlyIn'] ?? 0).toDouble(),
      totalLitersOut: (json['totalLitersOut'] ?? 0).toDouble(),
      dailyOut: (json['dailyOut'] ?? 0).toDouble(),
      weeklyOut: (json['weeklyOut'] ?? 0).toDouble(),
      monthlyOut: (json['monthlyOut'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalLitersIn': totalLitersIn,
      'dailyIn': dailyIn,
      'weeklyIn': weeklyIn,
      'monthlyIn': monthlyIn,
      'totalLitersOut': totalLitersOut,
      'dailyOut': dailyOut,
      'weeklyOut': weeklyOut,
      'monthlyOut': monthlyOut,
    };
  }

  double get dailyEfficiency {
    if (dailyIn == 0) return 0;
    return (dailyOut / dailyIn) * 100;
  }

  double get weeklyEfficiency {
    if (weeklyIn == 0) return 0;
    return (weeklyOut / weeklyIn) * 100;
  }

  double get monthlyEfficiency {
    if (monthlyIn == 0) return 0;
    return (monthlyOut / monthlyIn) * 100;
  }

  SummaryData copyWith({
    double? totalLitersIn,
    double? dailyIn,
    double? weeklyIn,
    double? monthlyIn,
    double? totalLitersOut,
    double? dailyOut,
    double? weeklyOut,
    double? monthlyOut,
  }) {
    return SummaryData(
      totalLitersIn: totalLitersIn ?? this.totalLitersIn,
      dailyIn: dailyIn ?? this.dailyIn,
      weeklyIn: weeklyIn ?? this.weeklyIn,
      monthlyIn: monthlyIn ?? this.monthlyIn,
      totalLitersOut: totalLitersOut ?? this.totalLitersOut,
      dailyOut: dailyOut ?? this.dailyOut,
      weeklyOut: weeklyOut ?? this.weeklyOut,
      monthlyOut: monthlyOut ?? this.monthlyOut,
    );
  }
}
