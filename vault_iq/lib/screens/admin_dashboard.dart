import 'package:flutter/material.dart';

import '../models/broker_model.dart';
import '../models/inventory_item.dart';
import '../services/mock_vault_service.dart';
import '../widgets/broker_custody_card.dart';
import '../widgets/dashboard_top_bar.dart';
import '../widgets/inventory_card.dart';
import '../widgets/metric_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MockVaultService _service = MockVaultService.instance;

  List<InventoryItem> get _inventory => _service.inventory;
  List<BrokerModel> get _brokers => _service.brokers;

  int get _grandTotalFullStock => _inventory.fold(
        0,
        (sum, item) => sum + item.fullContainers,
      );

  int get _grandTotalEmptyContainers => _inventory.fold(
        0,
        (sum, item) => sum + item.emptyContainers,
      );

  double get _totalPendingBrokerDues => _brokers.fold(
        0.0,
        (sum, broker) => sum + broker.currentBalance,
      );

  int get _totalUnaccountedCylinders => _brokers.fold(
        0,
        (sum, broker) => sum + broker.unaccounted,
      );

  void _recordRefillSwap(String itemId) {
    _service.recordRefillSwap(itemId, 1);
    setState(() {});

    final item = _service.inventory.firstWhere(
      (inventoryItem) => inventoryItem.id == itemId,
      orElse: () => const InventoryItem(
        id: '',
        name: 'Cylinder',
        fullContainers: 0,
        emptyContainers: 0,
        unitPrice: 0,
      ),
    );

    if (item.id.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} refill swap recorded.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: DashboardTopBar(
        title: 'VaultIQ',
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
        onNotificationTap: () {},
        userName: 'Keith',
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 700;
            final int crossAxisCount = isWide ? 4 : 2;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Good morning, Keith',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sokomat Gas Depot Overview',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: isWide ? 1.9 : 1.2,
                    children: [
                      MetricCard(
                        title: 'Grand Total Full Stock',
                        value: '$_grandTotalFullStock',
                        icon: Icons.inventory_2_outlined,
                        accentColor: Colors.blue.shade700,
                      ),
                      MetricCard(
                        title: 'Grand Total Empty Containers',
                        value: '$_grandTotalEmptyContainers',
                        icon: Icons.assignment_return_outlined,
                        accentColor: Colors.green.shade600,
                      ),
                      MetricCard(
                        title: 'Pending Broker Dues',
                        value: 'K $_totalPendingBrokerDues',
                        icon: Icons.account_balance_wallet_outlined,
                        accentColor: Colors.blue.shade700,
                      ),
                      MetricCard(
                        title: 'Unaccounted Cylinders',
                        value: '$_totalUnaccountedCylinders',
                        icon: Icons.warning_amber_rounded,
                        accentColor: Colors.red.shade600,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Inventory Overview',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._inventory.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InventoryCard(
                        item: item,
                        onRecordSwap: () => _recordRefillSwap(item.id),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Broker Custody Overview',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    itemCount: _brokers.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final broker = _brokers[index];
                      return BrokerCustodyCard(broker: broker);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Transaction'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
    );
  }
}