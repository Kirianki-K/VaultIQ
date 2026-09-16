import 'package:flutter/material.dart';

import '../models/inventory_item.dart';

class InventoryCard extends StatelessWidget {
  const InventoryCard({
    super.key,
    required this.item,
    required this.onRecordSwap,
  });

  final InventoryItem item;
  final VoidCallback onRecordSwap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '${item.name} Cylinder',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Text(
                    'In Stock',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _InfoBlock(
                    label: 'Full',
                    value: '${item.fullContainers}',
                    accentColor: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoBlock(
                    label: 'Empty',
                    value: '${item.emptyContainers}',
                    accentColor: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onRecordSwap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Record Refill Swap'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
