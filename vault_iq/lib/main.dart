import 'package:flutter/material.dart';

void main() => runApp(const VaultIqApp());

class VaultIqApp extends StatelessWidget {
  const VaultIqApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'VaultIQ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Arial',
          scaffoldBackgroundColor: const Color(0xFFF5F7F8),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0D8B82),
            brightness: Brightness.light,
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFE4E9EA)),
            ),
          ),
        ),
        home: const VaultHomePage(),
      );
}

class InventoryItem {
  InventoryItem({
    required this.name,
    required this.category,
    required this.filled,
    required this.empty,
    required this.reorderLevel,
    required this.price,
  });

  final String name;
  final String category;
  int filled;
  int empty;
  final int reorderLevel;
  final double price;

  bool get isLow => filled <= reorderLevel;
}

class LedgerEntry {
  LedgerEntry(this.type, this.item, this.quantity, this.detail);

  final String type;
  final String item;
  final String quantity;
  final String detail;
}

class VaultHomePage extends StatefulWidget {
  const VaultHomePage({super.key});

  @override
  State<VaultHomePage> createState() => _VaultHomePageState();
}

class _VaultHomePageState extends State<VaultHomePage> {
  int _selectedIndex = 0;
  bool _isDark = false;
  int _todaySwaps = 24;
  final List<InventoryItem> _items = [
    InventoryItem(name: '6kg Cylinder', category: 'Gas Cylinders', filled: 186, empty: 42, reorderLevel: 80, price: 18),
    InventoryItem(name: '13kg Cylinder', category: 'Gas Cylinders', filled: 74, empty: 31, reorderLevel: 90, price: 34),
    InventoryItem(name: '45kg Cylinder', category: 'Gas Cylinders', filled: 28, empty: 16, reorderLevel: 25, price: 92),
    InventoryItem(name: 'Regulator Kit', category: 'Hardware', filled: 42, empty: 0, reorderLevel: 12, price: 14),
  ];
  final List<LedgerEntry> _ledger = [
    LedgerEntry('Swap', '6kg Cylinder', '-1 full / +1 empty', 'Staff KM'),
    LedgerEntry('Outright', '13kg Cylinder', '-2 full', 'Staff AN'),
    LedgerEntry('Intake', '45kg Cylinder', '+20 full / -8 empty', 'Staff KM'),
  ];

  int get _filledTotal => _items.fold(0, (sum, item) => sum + item.filled);
  int get _emptyTotal => _items.fold(0, (sum, item) => sum + item.empty);
  int get _lowStock => _items.where((item) => item.isLow).length;
  int get _stockValue => _items.fold(0, (sum, item) => sum + item.filled * item.price.toInt());

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 900;
    return Theme(
      data: _isDark ? _darkTheme : Theme.of(context),
      child: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              if (!isCompact) _buildSidebar(context),
              Expanded(child: _buildContent(context, isCompact)),
            ],
          ),
        ),
        bottomNavigationBar: isCompact ? _buildBottomNav() : null,
      ),
    );
  }

  ThemeData get _darkTheme => ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF101819),
        cardTheme: CardThemeData(
          color: const Color(0xFF182123),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF30B5A7), brightness: Brightness.dark),
      );

  Widget _buildSidebar(BuildContext context) => Container(
        width: 236,
        color: _isDark ? const Color(0xFF0D1314) : Colors.white,
        padding: const EdgeInsets.fromLTRB(18, 26, 14, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _brand(),
            const SizedBox(height: 40),
            _navItem(0, Icons.grid_view_rounded, 'Dashboard'),
            _navItem(1, Icons.inventory_2_outlined, 'Inventory / Stock Ledger'),
            _navItem(2, Icons.bolt_rounded, 'Quick POS / Transaction'),
            _navItem(3, Icons.receipt_long_outlined, 'Audit Logs'),
            _navItem(4, Icons.tune_rounded, 'Settings'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: _isDark ? const Color(0xFF182B2A) : const Color(0xFFEAF7F4), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const CircleAvatar(radius: 16, backgroundColor: Color(0xFFBCE9E1), child: Text('KM', style: TextStyle(fontSize: 10, color: Color(0xFF14645C), fontWeight: FontWeight.bold))),
                const SizedBox(width: 9),
                const Expanded(child: Text('Keith Miller\nAdministrator', style: TextStyle(fontSize: 11, height: 1.5, fontWeight: FontWeight.w600))),
                Icon(Icons.more_horiz, size: 18, color: Colors.grey.shade600),
              ]),
            ),
          ],
        ),
      );

  Widget _brand() => Row(children: [
        Container(width: 34, height: 34, decoration: BoxDecoration(color: const Color(0xFF0C8C80), borderRadius: BorderRadius.circular(9)), child: const Icon(Icons.hexagon_rounded, color: Colors.white, size: 22)),
        const SizedBox(width: 9),
        const Text('VaultIQ', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
      ]);

  Widget _navItem(int index, IconData icon, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: ListTile(
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          selected: _selectedIndex == index,
          selectedTileColor: const Color(0xFFE2F5F1),
          leading: Icon(icon, size: 19, color: _selectedIndex == index ? const Color(0xFF087E74) : Colors.grey.shade600),
          title: Text(label, style: TextStyle(fontSize: 12, fontWeight: _selectedIndex == index ? FontWeight.w700 : FontWeight.w500, color: _selectedIndex == index ? const Color(0xFF087E74) : null)),
          onTap: () => setState(() => _selectedIndex = index),
        ),
      );

  Widget _buildBottomNav() => NavigationBar(
        selectedIndex: _selectedIndex > 2 ? 0 : _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'Inventory'),
          NavigationDestination(icon: Icon(Icons.bolt_outlined), selectedIcon: Icon(Icons.bolt), label: 'Quick POS'),
        ],
      );

  Widget _buildContent(BuildContext context, bool isCompact) => Column(
        children: [
          _buildTopBar(context, isCompact),
          Expanded(child: _selectedIndex == 2 ? _buildPosView() : _buildDashboard(isCompact)),
        ],
      );

  Widget _buildTopBar(BuildContext context, bool isCompact) => Padding(
        padding: EdgeInsets.fromLTRB(isCompact ? 18 : 34, 18, isCompact ? 18 : 34, 8),
        child: Row(children: [
          if (isCompact) ...[_brand(), const Spacer()],
          if (!isCompact) const Spacer(),
          IconButton(
            onPressed: _showAddItem,
            tooltip: 'Add inventory item',
            icon: const Icon(Icons.add_box_outlined, size: 20),
          ),
          IconButton(onPressed: () => setState(() => _isDark = !_isDark), tooltip: 'Toggle theme', icon: Icon(_isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, size: 20)),
          IconButton(onPressed: () {}, tooltip: 'Notifications', icon: const Icon(Icons.notifications_none_rounded, size: 20)),
          const SizedBox(width: 8),
          const CircleAvatar(radius: 16, backgroundColor: Color(0xFFBCE9E1), child: Text('KM', style: TextStyle(fontSize: 10, color: Color(0xFF14645C), fontWeight: FontWeight.bold))),
        ]),
      );

  Widget _buildDashboard(bool isCompact) => SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(isCompact ? 18 : 34, 18, isCompact ? 18 : 34, 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Good morning, Keith', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          const SizedBox(height: 5),
          Text('Here is what is happening with your inventory today.', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 8),
          Text('Total stock value  •  \$${_stockValue.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: Color(0xFF168276), fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          _buildMetrics(isCompact),
          const SizedBox(height: 20),
          if (isCompact) ...[_buildChart(), const SizedBox(height: 20)],
          if (!isCompact) Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 5, child: _buildInventoryTable()), const SizedBox(width: 18), Expanded(flex: 3, child: _buildChart())]) else _buildInventoryTable(),
          const SizedBox(height: 20),
          _buildLedger(),
        ]),
      );

  Widget _buildMetrics(bool compact) {
    final metrics = [
      ('Available filled', _filledTotal.toString(), 'Across ${_items.length} SKUs', Icons.inventory_2_outlined, const Color(0xFFE1F6F1)),
      ('Empties on hand', _emptyTotal.toString(), 'Pending refill', Icons.autorenew_rounded, const Color(0xFFFFF0DA)),
      ('Low stock warnings', _lowStock.toString(), 'Requires attention', Icons.warning_amber_rounded, const Color(0xFFFFE3E0)),
      ("Today's swaps", '$_todaySwaps', 'Since opening today', Icons.swap_horiz_rounded, const Color(0xFFE7F0FF)),
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: compact ? 2 : 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: compact ? 1.45 : 1.8,
      children: metrics.map((metric) {
        final isWarning = metric.$1 == 'Low stock warnings';
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(metric.$1, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(color: metric.$5, borderRadius: BorderRadius.circular(8)),
                      child: Icon(metric.$4, size: 16, color: const Color(0xFF167A70)),
                    ),
                  ],
                ),
                Text(metric.$2, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                Text(metric.$3, style: TextStyle(fontSize: 10, color: isWarning ? const Color(0xFFE06455) : const Color(0xFF2B9A78), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInventoryTable() => Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Inventory overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), TextButton(onPressed: () => setState(() => _selectedIndex = 1), child: const Text('View ledger'))]),
            const SizedBox(height: 7),
            ..._items.map(_inventoryRow),
          ]),
        ),
      );

  Widget _inventoryRow(InventoryItem item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFFE7F4F1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.propane_tank_outlined, color: Color(0xFF108278), size: 18)),
          const SizedBox(width: 9),
          Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)), Text(item.category, style: TextStyle(fontSize: 10, color: Colors.grey.shade600))])),
          Expanded(child: _stockNumber('${item.filled}', 'full', const Color(0xFF187E70))),
          Expanded(child: _stockNumber('${item.empty}', 'empty', const Color(0xFFDA9540))),
          if (MediaQuery.sizeOf(context).width > 650) Expanded(child: Text('${item.reorderLevel}', style: const TextStyle(fontSize: 12))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: item.isLow ? const Color(0xFFFFE4E0) : const Color(0xFFE2F5ED), borderRadius: BorderRadius.circular(20)), child: Text(item.isLow ? 'Low stock' : 'Healthy', style: TextStyle(fontSize: 9, color: item.isLow ? const Color(0xFFC94D43) : const Color(0xFF278265), fontWeight: FontWeight.w700))),
          PopupMenuButton<String>(padding: EdgeInsets.zero, iconSize: 18, onSelected: (action) => _applyAction(item, action), itemBuilder: (context) => const [PopupMenuItem(value: 'swap', child: Text('Refill swap')), PopupMenuItem(value: 'sale', child: Text('Outright sale'))]),
        ]),
      );

  Widget _stockNumber(String number, String label, Color color) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(number, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: color)), Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade500))]);

  Widget _buildChart() => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Stock movement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), Text('Last 7 days', style: TextStyle(fontSize: 10, color: Colors.grey.shade600))]), const SizedBox(height: 15), SizedBox(height: 150, child: CustomPaint(painter: _ChartPainter(_isDark))), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.center, children: [_chartLegend(const Color(0xFF0E8F83), 'Inflow'), const SizedBox(width: 20), _chartLegend(const Color(0xFFF0A34B), 'Outflow')])])));

  Widget _chartLegend(Color color, String label) => Row(children: [Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 10))]);

  Widget _buildLedger() => Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  TextButton(onPressed: () => setState(() => _selectedIndex = 3), child: const Text('View audit log')),
                ],
              ),
              ..._ledger.map((entry) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: CircleAvatar(
                      radius: 15,
                      backgroundColor: entry.type == 'Swap' ? const Color(0xFFE2F5F1) : const Color(0xFFFFF0DC),
                      child: Icon(entry.type == 'Swap' ? Icons.swap_horiz_rounded : Icons.call_received_rounded, size: 16, color: const Color(0xFF258477)),
                    ),
                    title: Text(entry.item, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    subtitle: Text('${entry.type} · ${entry.detail}', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                    trailing: Text(entry.quantity, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  )),
            ],
          ),
        ),
      );

  Widget _buildPosView() => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Quick transaction', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Log a stock movement in a few seconds.', style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 22),
          ..._items.map((item) => Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  leading: const CircleAvatar(backgroundColor: Color(0xFFE2F5F1), child: Icon(Icons.propane_tank_outlined, color: Color(0xFF108278))),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${item.filled} full · ${item.empty} empty'),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      IconButton(tooltip: 'Refill swap', onPressed: () => _applyAction(item, 'swap'), icon: const Icon(Icons.swap_horiz_rounded)),
                      IconButton(tooltip: 'Outright sale', onPressed: () => _applyAction(item, 'sale'), icon: const Icon(Icons.remove_circle_outline_rounded)),
                    ],
                  ),
                ),
              )),
        ],
      );

  void _applyAction(InventoryItem item, String action) {
    if (action == 'swap' && item.filled > 0) { item.filled--; item.empty++; _todaySwaps++; }
    if (action == 'sale' && item.filled > 0) item.filled--;
    setState(() => _ledger.insert(0, LedgerEntry(action == 'swap' ? 'Swap' : 'Outright', item.name, action == 'swap' ? '-1 full / +1 empty' : '-1 full', 'Staff KM')));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(action == 'swap' ? '${item.name} swap recorded.' : '${item.name} sale recorded.')));
  }

  void _showAddItem() async {
    final nameController = TextEditingController();
    final result = await showDialog<String>(context: context, builder: (context) => AlertDialog(title: const Text('Add inventory item'), content: TextField(controller: nameController, autofocus: true, decoration: const InputDecoration(labelText: 'Product name', hintText: 'e.g. 9kg Cylinder')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, nameController.text), child: const Text('Add item'))]));
    if (!mounted || result == null || result.trim().isEmpty) return;
    setState(() => _items.add(InventoryItem(name: result.trim(), category: 'General', filled: 0, empty: 0, reorderLevel: 10, price: 0)));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inventory item added.')));
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter(this.dark);
  final bool dark;
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = dark ? Colors.white12 : const Color(0xFFE8EEEE)..strokeWidth = 1;
    for (var i = 0; i < 4; i++) { final y = i * size.height / 3; canvas.drawLine(Offset(0, y), Offset(size.width, y), grid); }
    final inflow = [0.5, 0.62, 0.42, 0.75, 0.63, 0.88, 0.78];
    final outflow = [0.38, 0.48, 0.3, 0.57, 0.52, 0.7, 0.58];
    _drawLine(canvas, size, inflow, const Color(0xFF0E8F83));
    _drawLine(canvas, size, outflow, const Color(0xFFF0A34B));
  }
  void _drawLine(Canvas canvas, Size size, List<double> values, Color color) { final path = Path(); for (var i = 0; i < values.length; i++) { final point = Offset(i * size.width / (values.length - 1), size.height * (1 - values[i])); i == 0 ? path.moveTo(point.dx, point.dy) : path.lineTo(point.dx, point.dy); } canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round); for (var i = 0; i < values.length; i++) { canvas.drawCircle(Offset(i * size.width / (values.length - 1), size.height * (1 - values[i])), 3, Paint()..color = color); } }
  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) => oldDelegate.dark != dark;
}
