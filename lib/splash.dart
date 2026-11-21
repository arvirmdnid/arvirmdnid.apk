import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 6500));

  @override
  void initState() {
    super.initState();
    c.forward().whenComplete(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A1929), Color(0xFF0D3B66)],
            ),
          ),
          child: AnimatedBuilder(
            animation: c,
            builder: (_, __) => CustomPaint(
              size: Size.infinite,
              painter: FillPainter(c.value),
            ),
          ),
        ),
      );
}

class FillPainter extends CustomPainter {
  final double t;
  FillPainter(this.t);

  static const double W = 360, H = 640;
  static const Offset mouth = Offset(180, 205);
  static const double cx = 180, by = 470, bTop = 255;
  static const water = Color(0xFF29B6F6);

  double seg(double a, double b, [Curve cv = Curves.linear]) =>
      cv.transform(((t - a) / (b - a)).clamp(0.0, 1.0));

  Path gallonPath() => Path()
    ..moveTo(-20, 0)
    ..lineTo(20, 0)
    ..lineTo(20, 28)
    ..quadraticBezierTo(62, 34, 62, 80)
    ..lineTo(62, 170)
    ..quadraticBezierTo(62, 192, 40, 192)
    ..lineTo(-40, 192)
    ..quadraticBezierTo(-62, 192, -62, 170)
    ..lineTo(-62, 80)
    ..quadraticBezierTo(-62, 34, -20, 28)
    ..close();

  Path bottlePath() => Path()
    ..moveTo(cx - 35, by)
    ..lineTo(cx + 35, by)
    ..quadraticBezierTo(cx + 45, by, cx + 45, by - 10)
    ..lineTo(cx + 45, by - 150)
    ..quadraticBezierTo(cx + 45, by - 175, cx + 20, by - 185)
    ..lineTo(cx + 18, by - 215)
    ..lineTo(cx - 18, by - 215)
    ..lineTo(cx - 20, by - 185)
    ..quadraticBezierTo(cx - 45, by - 175, cx - 45, by - 150)
    ..lineTo(cx - 45, by - 10)
    ..quadraticBezierTo(cx - 45, by, cx - 35, by)
    ..close();

  Path wave(Rect r, double y, double amp) {
    final p = Path()..moveTo(r.left - 5, y);
    for (double x = r.left - 5; x <= r.right + 5; x += 4) {
      p.lineTo(x, y + math.sin(x / 14 + t * 45) * amp);
    }
    return p
      ..lineTo(r.right + 5, r.bottom + 5)
      ..lineTo(r.left - 5, r.bottom + 5)
      ..close();
  }

  void label(Canvas c, String s, double cy, double size, double op,
      {double ls = 0}) {
    if (op <= 0) return;
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          color: Colors.white.withOpacity(op.clamp(0.0, 1.0)),
          fontSize: size,
          fontWeight: FontWeight.w700,
          letterSpacing: ls,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, Offset(180 - tp.width / 2, cy - tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.min(size.width / W, size.height / H);
    canvas.translate((size.width - W * s) / 2, (size.height - H * s) / 2);
    canvas.scale(s);

    final tilt = seg(0, 0.22, Curves.easeInOut);
    final pour = seg(0.22, 0.85, Curves.easeInOut);
    final fin = seg(0.85, 1.0, Curves.easeOut);

    final fill = Paint()..style = PaintingStyle.fill;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round;

    // ---------- Botol ----------
    final bp = bottlePath();
    canvas.drawPath(bp, fill..color = const Color(0x1AFFFFFF));
    final surfaceB = by - 5 - pour * (by - 5 - (bTop + 8));
    if (pour > 0) {
      canvas.save();
      canvas.clipPath(bp);
      canvas.drawPath(
        wave(bp.getBounds(), surfaceB, 3 * (1 - pour * 0.7)),
        fill..color = water.withOpacity(0.85),
      );
      canvas.restore();
    }
    canvas.drawPath(bp, line..color = Colors.white70);
    canvas.drawLine(
      const Offset(cx - 33, by - 140),
      const Offset(cx - 33, by - 30),
      Paint()
        ..color = Colors.white24
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    // ---------- Galon ----------
    final op = 1 - fin;
    if (op > 0) {
      final theta = tilt * 150 * math.pi / 180;
      final off = Offset(
        (1 - tilt) * 150 + fin * 200,
        -(1 - tilt) * 60 - fin * 80,
      );
      final m = Matrix4.identity()
        ..translate(mouth.dx + off.dx, mouth.dy + off.dy)
        ..rotateZ(theta);
      final gp = gallonPath().transform(m.storage);
      final gb = gp.getBounds();

      canvas.saveLayer(null, Paint()..color = Color.fromRGBO(255, 255, 255, op));
      canvas.drawPath(gp, fill..color = const Color(0x2229B6F6));

      final level = 1 - 0.9 * pour;
      canvas.save();
      canvas.clipPath(gp);
      canvas.drawPath(
        wave(gb, gb.bottom - level * gb.height, 2.5),
        fill..color = water.withOpacity(0.8),
      );
      canvas.restore();

      canvas.drawPath(gp, line..color = const Color(0xFF81D4FA));
      canvas.save();
      canvas.transform(m.storage);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(-24, -8, 48, 12), const Radius.circular(4)),
        fill..color = const Color(0xFF1565C0),
      );
      canvas.restore();
      canvas.restore();
    }

    // ---------- Aliran air ----------
    if (pour > 0 && pour < 1) {
      final w = 7 * math.min(1.0, math.min(pour * 10, (1 - pour) * 10));
      final stream = Path()..moveTo(mouth.dx, mouth.dy);
      for (double y = mouth.dy; y <= surfaceB; y += 4) {
        stream.lineTo(mouth.dx + math.sin(y / 10 + t * 60) * 1.5, y);
      }
      canvas.drawPath(
        stream,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = w
          ..color = water.withOpacity(0.9),
      );
      for (var i = 0; i < 5; i++) {
        final dx = math.sin(t * 50 + i * 2) * 12;
        final dy = (math.sin(t * 35 + i * 1.7)).abs() * 8;
        canvas.drawCircle(Offset(cx + dx, surfaceB - 3 - dy), 2,
            Paint()..color = water.withOpacity(0.8));
      }
    }

    // ---------- Tutup botol ----------
    if (fin > 0) {
      final cy = bTop - 14 - (1 - fin) * 40;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 22, cy, 44, 16), const Radius.circular(5)),
        Paint()..color = const Color(0xFF1565C0).withOpacity(fin),
      );
    }

    // ---------- Teks ----------
    label(canvas, '${(pour * 100).round()}%', 515, 22, 1 - fin);
    label(canvas, 'arvirmdnid', 515, 32, fin, ls: 2);
  }

  @override
  bool shouldRepaint(FillPainter old) => old.t != t;
}
