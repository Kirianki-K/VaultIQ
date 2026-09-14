import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:vault_iq/main.dart';

void main() {
  testWidgets('shows the VaultIQ dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const VaultIqApp());

    expect(find.text('VaultIQ'), findsOneWidget);
    expect(find.text('Good morning, Keith'), findsOneWidget);
    expect(find.text('Inventory overview'), findsOneWidget);
    expect(find.text('6kg Cylinder'), findsOneWidget);
    expect(find.text('13kg Cylinder'), findsOneWidget);
  });

  testWidgets('quick swap updates the inventory', (WidgetTester tester) async {
    await tester.pumpWidget(const VaultIqApp());

    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Refill swap').last);
    await tester.pump();

    expect(find.text('6kg Cylinder swap recorded.'), findsOneWidget);
  });
}
