// In-Class Activity 06 — Drawing with Flutter
// Student: Greena Nisheethkumar Patel
// Date: September 30, 2026

import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const SmileyApp());

enum FaceType {
  classic,
  sleepy,
  surprised,
}

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  double mood = 0.8;

  FaceType selectedFace = FaceType.classic;

  final Random random = Random();

  String get moodText {
    if (mood < 0.35) {
      return 'Sad';
    } else if (mood <= 0.70) {
      return 'Neutral';
    } else {
      return 'Happy';
    }
  }

  String get faceText {
    switch (selectedFace) {
      case FaceType.classic:
        return 'Classic';
      case FaceType.sleepy:
        return 'Sleepy';
      case FaceType.surprised:
        return 'Surprised';
    }
  }

  // ------------------------------------------------
  // LEVEL 4: TAP TO CYCLE FACES
  // ------------------------------------------------

  void cycleFace() {
    setState(() {
      switch (selectedFace) {
        case FaceType.classic:
          selectedFace = FaceType.sleepy;
          break;

        case FaceType.sleepy:
          selectedFace = FaceType.surprised;
          break;

        case FaceType.surprised:
          selectedFace = FaceType.classic;
          break;
      }
    });

    showMessage('Face changed to $faceText');
  }

  // ------------------------------------------------
  // LEVEL 4: LONG PRESS TO RANDOMIZE
  // ------------------------------------------------

  void randomizeFace() {
    setState(() {
      mood = random.nextDouble();

      selectedFace =
          FaceType.values[random.nextInt(FaceType.values.length)];
    });

    showMessage(
      'Randomized: $faceText — $moodText',
    );
  }

  // ------------------------------------------------
  // SNACKBAR
  // ------------------------------------------------

  void showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void selectFace(FaceType type) {
    setState(() {
      selectedFace = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPainter Smiley Lab'),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ----------------------------------------
            // INTERACTIVE DRAWING
            // ----------------------------------------

            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: cycleFace,
                  onLongPress: randomizeFace,

                  child: CustomPaint(
                    size: const Size(300, 300),

                    painter: SmileyPainter(
                      mood: mood,
                      faceType: selectedFace,
                    ),
                  ),
                ),
              ),
            ),

            // ----------------------------------------
            // CURRENT FACE
            // ----------------------------------------

            Text(
              faceText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ----------------------------------------
            // FACE BUTTONS
            // ----------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,

                children: [
                  ElevatedButton(
                    onPressed: () {
                      selectFace(FaceType.classic);
                    },
                    child: const Text('Classic'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      selectFace(FaceType.sleepy);
                    },
                    child: const Text('Sleepy'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      selectFace(FaceType.surprised);
                    },
                    child: const Text('Surprised'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ----------------------------------------
            // MOOD LABEL
            // ----------------------------------------

            Text(
              '$moodText — Mood: ${mood.toStringAsFixed(2)}',

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            // ----------------------------------------
            // MOOD SLIDER
            // ----------------------------------------

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(20, 5, 20, 20),

              child: Slider(
                value: mood,
                min: 0.0,
                max: 1.0,

                onChanged: (double value) {
                  setState(() {
                    mood = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// CUSTOM PAINTER
// ====================================================

class SmileyPainter extends CustomPainter {
  SmileyPainter({
    required this.mood,
    required this.faceType,
  });

  final double mood;
  final FaceType faceType;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.shortestSide * 0.40;

    // ------------------------------------------------
    // FACE COLOR
    // ------------------------------------------------

    Color faceColor;

    if (mood < 0.35) {
      faceColor = Colors.lightBlue.shade300;
    } else if (mood <= 0.70) {
      faceColor = Colors.yellow.shade600;
    } else {
      faceColor = Colors.orange.shade300;
    }

    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius,
      facePaint,
    );

    // ------------------------------------------------
    // BORDER
    // ------------------------------------------------

    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(
      center,
      radius,
      borderPaint,
    );

    // ------------------------------------------------
    // FACE TYPE
    // ------------------------------------------------

    switch (faceType) {
      case FaceType.classic:
        drawClassicFace(
          canvas,
          center,
          radius,
        );
        break;

      case FaceType.sleepy:
        drawSleepyFace(
          canvas,
          center,
          radius,
        );
        break;

      case FaceType.surprised:
        drawSurprisedFace(
          canvas,
          center,
          radius,
        );
        break;
    }
  }

  // ==================================================
  // CLASSIC
  // ==================================================

  void drawClassicFace(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final eyeY =
        center.dy - radius * 0.20;

    final eyeDx =
        radius * 0.35;

    final eyeRadius =
        radius * 0.08;

    // Left eye
    canvas.drawCircle(
      Offset(
        center.dx - eyeDx,
        eyeY,
      ),
      eyeRadius,
      eyePaint,
    );

    // Right eye
    canvas.drawCircle(
      Offset(
        center.dx + eyeDx,
        eyeY,
      ),
      eyeRadius,
      eyePaint,
    );

    drawMoodMouth(
      canvas,
      center,
      radius,
    );
  }

  // ==================================================
  // SLEEPY
  // ==================================================

  void drawSleepyFace(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final eyeY =
        center.dy - radius * 0.20;

    final eyeDx =
        radius * 0.35;

    // Left closed eye
    canvas.drawLine(
      Offset(
        center.dx - eyeDx - radius * 0.10,
        eyeY,
      ),
      Offset(
        center.dx - eyeDx + radius * 0.10,
        eyeY,
      ),
      eyePaint,
    );

    // Right closed eye
    canvas.drawLine(
      Offset(
        center.dx + eyeDx - radius * 0.10,
        eyeY,
      ),
      Offset(
        center.dx + eyeDx + radius * 0.10,
        eyeY,
      ),
      eyePaint,
    );

    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy + radius * 0.25,
      ),
      width: radius * 0.60,
      height: radius * 0.25,
    );

    canvas.drawArc(
      mouthRect,
      0.15 * pi,
      0.70 * pi,
      false,
      mouthPaint,
    );
  }

  // ==================================================
  // SURPRISED
  // ==================================================

  void drawSurprisedFace(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final eyeY =
        center.dy - radius * 0.22;

    final eyeDx =
        radius * 0.35;

    final eyeRadius =
        radius * 0.12;

    // Left eye
    canvas.drawCircle(
      Offset(
        center.dx - eyeDx,
        eyeY,
      ),
      eyeRadius,
      eyePaint,
    );

    // Right eye
    canvas.drawCircle(
      Offset(
        center.dx + eyeDx,
        eyeY,
      ),
      eyeRadius,
      eyePaint,
    );

    // Open mouth
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.30,
        ),
        width: radius * 0.38,
        height: radius * 0.50,
      ),
      mouthPaint,
    );
  }

  // ==================================================
  // CLASSIC MOOD MOUTH
  // ==================================================

  void drawMoodMouth(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // SAD
    if (mood < 0.35) {
      final frownRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.45,
        ),
        width: radius * 1.0,
        height: radius * 0.55,
      );

      canvas.drawArc(
        frownRect,
        1.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    }

    // NEUTRAL
    else if (mood <= 0.70) {
      final neutralRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.15,
        ),
        width: radius * 0.90,
        height: radius * 0.30,
      );

      canvas.drawArc(
        neutralRect,
        0.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    }

    // HAPPY
    else {
      final happyRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.10,
        ),
        width: radius * 1.15,
        height: radius * 0.90,
      );

      canvas.drawArc(
        happyRect,
        0.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    }
  }

  // ==================================================
  // SHOULD REPAINT
  // ==================================================

  @override
  bool shouldRepaint(
    covariant SmileyPainter oldDelegate,
  ) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceType != faceType;
  }
}