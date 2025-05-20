import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meetdigest/screens/navbar.dart';

void main() {
  testWidgets('Main page renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Navbar()),
    );
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Beranda'), findsNWidgets(2));
  });
}