import 'package:flutter/material.dart';
import 'package:curved_text_codespark/curved_text_codespark.dart';

void main() {
  runApp(const CurvedTextExampleApp());
}

class CurvedTextExampleApp extends StatelessWidget {
  const CurvedTextExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curved Text Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const CurvedTextHome(),
    );
  }
}

class CurvedTextHome extends StatelessWidget {
  const CurvedTextHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌀 Curved Text Demo')),
      body: Center(
        child: CurvedText(
          text: 'CURVED TEXT CODESPARK',
          options: CurvedTextOptions(
            curveType: CurveType.circular,
            radius: 120,
            spacing: 8,
            clockwise: true,
            rtl: false,
            defaultTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
              letterSpacing: 1.2,
            ),
          ),
          onCharTap: (index, char) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped: "$char" at index $index')),
            );
          },
          animationDuration: const Duration(milliseconds: 1000),
          styleBuilder: (index, char) {
            return TextStyle(
              fontSize: 20 + (index % 4) * 2,
              color: index.isEven ? Colors.tealAccent : Colors.orangeAccent,
              fontWeight: FontWeight.w600,
            );
          },
        ),
      ),
    );
  }
}
