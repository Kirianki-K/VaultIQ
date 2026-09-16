class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.brokerId,
    required this.timestamp,
    required this.type,
    required this.fullCount,
    required this.emptyCount,
    required this.totalAmount,
  });

  final String id;
  final String brokerId;
  final DateTime timestamp;
  final String type; // sale, refill_swap, stock_issue, return
  final int fullCount;
  final int emptyCount;
  final double totalAmount;

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      brokerId: json['brokerId'] as String? ?? '',
      timestamp: json['timestamp'] is String
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : (json['timestamp'] as DateTime?) ?? DateTime.now(),
      type: json['type'] as String? ?? 'sale',
      fullCount: json['fullCount'] as int? ?? 0,
      emptyCount: json['emptyCount'] as int? ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brokerId': brokerId,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'fullCount': fullCount,
      'emptyCount': emptyCount,
      'totalAmount': totalAmount,
    };
  }

  TransactionModel copyWith({
    String? id,
    String? brokerId,
    DateTime? timestamp,
    String? type,
    int? fullCount,
    int? emptyCount,
    double? totalAmount,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      brokerId: brokerId ?? this.brokerId,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      fullCount: fullCount ?? this.fullCount,
      emptyCount: emptyCount ?? this.emptyCount,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
