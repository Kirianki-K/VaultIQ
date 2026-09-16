class BrokerModel {
  const BrokerModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.issuedStock,
    required this.salesCount,
    required this.emptyReturned,
    required this.fullReturned,
    required this.commissionRate,
    required this.currentBalance,
  });

  final String id;
  final String name;
  final String userId;
  final int issuedStock;
  final int salesCount;
  final int emptyReturned;
  final int fullReturned;
  final double commissionRate;
  final double currentBalance;

  int get unaccounted =>
      issuedStock - (salesCount + emptyReturned + fullReturned);

  factory BrokerModel.fromJson(Map<String, dynamic> json) {
    return BrokerModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      issuedStock: json['issuedStock'] as int? ?? 0,
      salesCount: json['salesCount'] as int? ?? 0,
      emptyReturned: json['emptyReturned'] as int? ?? 0,
      fullReturned: json['fullReturned'] as int? ?? 0,
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.0,
      currentBalance: (json['currentBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'issuedStock': issuedStock,
      'salesCount': salesCount,
      'emptyReturned': emptyReturned,
      'fullReturned': fullReturned,
      'commissionRate': commissionRate,
      'currentBalance': currentBalance,
    };
  }

  BrokerModel copyWith({
    String? id,
    String? name,
    String? userId,
    int? issuedStock,
    int? salesCount,
    int? emptyReturned,
    int? fullReturned,
    double? commissionRate,
    double? currentBalance,
  }) {
    return BrokerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      issuedStock: issuedStock ?? this.issuedStock,
      salesCount: salesCount ?? this.salesCount,
      emptyReturned: emptyReturned ?? this.emptyReturned,
      fullReturned: fullReturned ?? this.fullReturned,
      commissionRate: commissionRate ?? this.commissionRate,
      currentBalance: currentBalance ?? this.currentBalance,
    );
  }
}
