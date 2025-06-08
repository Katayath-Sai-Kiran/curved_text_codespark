import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:curved_text_codespark/curved_text_codespark.dart';

void main() {
  group('CurvedText widget tests', () {
    testWidgets('renders text along curve', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurvedText(
              text: 'TEST CURVE',
              options: CurvedTextOptions(
                curveType: CurveType.circular,
                radius: 100,
              ),
            ),
          ),
        ),
      );

      expect(find.text('T'), findsOneWidget);
      expect(find.text('E'), findsWidgets); // multiple 'E's in "TEST CURVE"
    });

    testWidgets('calls onCharTap when tapped', (WidgetTester tester) async {
      String tappedChar = '';
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurvedText(
              text: 'HELLO',
              options: CurvedTextOptions(curveType: CurveType.circular),
              onCharTap: (index, char) {
                tappedChar = char;
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      final hFinder = find.text('H');
      expect(hFinder, findsOneWidget);

      await tester.tap(hFinder);
      expect(tappedChar, 'H');
      expect(tappedIndex, 0);
    });

    testWidgets('applies custom style via styleBuilder',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurvedText(
              text: 'STYLE',
              options: CurvedTextOptions(curveType: CurveType.circular),
              styleBuilder: (i, char) => TextStyle(
                color: Colors.pink,
                fontSize: 16 + i.toDouble(),
              ),
            ),
          ),
        ),
      );

      final textWidgets = tester.widgetList<Text>(find.byType(Text)).toList();
      expect(textWidgets.length, 5);

      // Check if styles were applied
      expect(textWidgets[0].style?.color, Colors.pink);
      expect(textWidgets[1].style?.fontSize, greaterThan(16));
    });
  });
}
