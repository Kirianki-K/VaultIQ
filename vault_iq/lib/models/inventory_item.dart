class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.fullContainers,
    required this.emptyContainers,
    required this.unitPrice,
  });

  final String id;
  final String name;
  final int fullContainers;
  final int emptyContainers;
  final double unitPrice;

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      fullContainers: json['fullContainers'] as int? ?? 0,
      emptyContainers: json['emptyContainers'] as int? ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fullContainers': fullContainers,
      'emptyContainers': emptyContainers,
      'unitPrice': unitPrice,
    };
  }

  InventoryItem copyWith({
    String? id,
    String? name,
    int? fullContainers,
    int? emptyContainers,
    double? unitPrice,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      fullContainers: fullContainers ?? this.fullContainers,
      emptyContainers: emptyContainers ?? this.emptyContainers,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}