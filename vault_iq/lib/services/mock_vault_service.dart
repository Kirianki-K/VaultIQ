import '../models/broker_model.dart';
import '../models/inventory_item.dart';
import '../models/transaction_model.dart';

class MockVaultService {
  MockVaultService._internal();

  static final MockVaultService instance = MockVaultService._internal();

  final List<InventoryItem> _inventory = [
    const InventoryItem(
      id: 'inv_6kg',
      name: '6kg',
      fullContainers: 18,
      emptyContainers: 6,
      unitPrice: 1400,
    ),
    const InventoryItem(
      id: 'inv_13kg',
      name: '13kg',
      fullContainers: 12,
      emptyContainers: 5,
      unitPrice: 1900,
    ),
  ];

  final List<BrokerModel> _brokers = [
    const BrokerModel(
      id: 'broker_1',
      name: 'Aisha Njeri',
      userId: 'user_1',
      issuedStock: 30,
      salesCount: 22,
      emptyReturned: 4,
      fullReturned: 2,
      commissionRate: 0.12,
      currentBalance: 4800,
    ),
    const BrokerModel(
      id: 'broker_2',
      name: 'Daniel Kariuki',
      userId: 'user_2',
      issuedStock: 26,
      salesCount: 15,
      emptyReturned: 3,
      fullReturned: 1,
      commissionRate: 0.1,
      currentBalance: 3300,
    ),
  ];

  final List<TransactionModel> _recentTransactions = [
    TransactionModel(
      id: 'txn_1',
      brokerId: 'broker_1',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'sale',
      fullCount: 5,
      emptyCount: 0,
      totalAmount: 7200,
    ),
    TransactionModel(
      id: 'txn_2',
      brokerId: 'broker_2',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: 'refill_swap',
      fullCount: 2,
      emptyCount: 2,
      totalAmount: 0.0,
    ),
  ];

  List<InventoryItem> get inventory => List.unmodifiable(_inventory);
  List<BrokerModel> get brokers => List.unmodifiable(_brokers);
  List<TransactionModel> get recentTransactions =>
      List.unmodifiable(_recentTransactions);

  void recordRefillSwap(String itemId, int qty) {
    final index = _inventory.indexWhere((item) => item.id == itemId);
    if (index == -1 || qty <= 0) {
      return;
    }

    final updated = _inventory[index];
    if (updated.fullContainers <= 0) {
      return;
    }

    _inventory[index] = updated.copyWith(
      fullContainers: updated.fullContainers - qty,
      emptyContainers: updated.emptyContainers + qty,
    );

    _recentTransactions.insert(
      0,
      TransactionModel(
        id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        brokerId: 'system',
        timestamp: DateTime.now(),
        type: 'refill_swap',
        fullCount: qty,
        emptyCount: qty,
        totalAmount: 0.0,
      ),
    );
  }

  void issueStockToBroker(String brokerId, int qty) {
    final brokerIndex = _brokers.indexWhere((broker) => broker.id == brokerId);
    if (brokerIndex == -1 || qty <= 0) {
      return;
    }

    final broker = _brokers[brokerIndex];
    _brokers[brokerIndex] = broker.copyWith(
      issuedStock: broker.issuedStock + qty,
    );

    _recentTransactions.insert(
      0,
      TransactionModel(
        id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        brokerId: brokerId,
        timestamp: DateTime.now(),
        type: 'stock_issue',
        fullCount: qty,
        emptyCount: 0,
        totalAmount: 0.0,
      ),
    );
  }

  void logBrokerSale(String brokerId, int qty) {
    final brokerIndex = _brokers.indexWhere((broker) => broker.id == brokerId);
    if (brokerIndex == -1 || qty <= 0) {
      return;
    }

    final broker = _brokers[brokerIndex];
    final double saleAmount = qty * 1400.0;

    _brokers[brokerIndex] = broker.copyWith(
      salesCount: broker.salesCount + qty,
      currentBalance: broker.currentBalance + (saleAmount * broker.commissionRate),
    );

    _recentTransactions.insert(
      0,
      TransactionModel(
        id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        brokerId: brokerId,
        timestamp: DateTime.now(),
        type: 'sale',
        fullCount: qty,
        emptyCount: 0,
        totalAmount: saleAmount,
      ),
    );
  }

  void reconcileBrokerStock(String brokerId) {
    final brokerIndex = _brokers.indexWhere((broker) => broker.id == brokerId);
    if (brokerIndex == -1) {
      return;
    }

    final broker = _brokers[brokerIndex];
    final unaccounted = broker.issuedStock -
        (broker.salesCount + broker.emptyReturned + broker.fullReturned);

    _brokers[brokerIndex] = broker.copyWith(
      currentBalance:
          broker.currentBalance + (unaccounted * broker.commissionRate * 0.1).toDouble(),
    );
  }

  int getUnaccountedStock(BrokerModel broker) {
    return broker.issuedStock -
        (broker.salesCount + broker.emptyReturned + broker.fullReturned);
  }
}
