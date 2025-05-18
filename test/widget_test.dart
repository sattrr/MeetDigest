import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meetdigest/screens/main_page.dart';

void main() {
  testWidgets('Main page renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: MainPage()),
    );
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Beranda'), findsNWidgets(2));
  });
}