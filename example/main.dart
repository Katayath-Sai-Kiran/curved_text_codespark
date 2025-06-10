import 'package:curved_text_codespark/curved_text_codespark.dart';
import 'package:flutter/material.dart';

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

class CurvedTextHome extends StatefulWidget {
  const CurvedTextHome({super.key});

  @override
  State<CurvedTextHome> createState() => _CurvedTextHomeState();
}

class _CurvedTextHomeState extends State<CurvedTextHome> {
  double radius = 80;
  double spacing = 36;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('🌀 Curved Text Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: CurvedText(
                  text: 'CURVEDTEXT',
                  animationCurve: Curves.bounceIn,
                  options: CurvedTextOptions(
                    curveType: CurveType.circular,
                    radius: radius,
                    spacing: spacing,
                    clockwise: true,
                    rtl: false,
                    defaultTextStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                      letterSpacing: 1.2,
                    ),
                    spiralTurns: 9,
                    waveAmplitude: 90,
                  ),
                  onCharTap: (index, char) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tapped: "$char" at index $index'),
                      ),
                    );
                  },
                  animationDuration: const Duration(milliseconds: 1000),
                  styleBuilder: (index, char) {
                    return TextStyle(
                      fontSize: 20,
                      color: index.isEven
                          ? Colors.tealAccent
                          : Colors.orangeAccent,
                      fontWeight: FontWeight.w600,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Radius: ${radius.toInt()}",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            Slider(
              value: radius,
              onChanged: (value) {
                setState(() {
                  radius = value;
                });
              },
              min: 0,
              max: MediaQuery.of(context).size.width / 3,
              label: 'Radius: ${radius.toInt()}',
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Spacing: ${spacing.toInt()}",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            Slider(
              value: spacing,
              onChanged: (value) {
                setState(() {
                  spacing = value;
                });
              },
              min: 0,
              max: MediaQuery.of(context).size.width / 3,
              label: 'Spacing: ${spacing.toInt()}',
            ),
          ],
        ),
      ),
    );
  }
}
