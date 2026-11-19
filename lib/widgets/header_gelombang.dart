import 'package:flutter/material.dart';

class HeaderGelombang extends StatelessWidget {
  const HeaderGelombang({
    super.key,
    required this.warnaAwal,
    required this.warnaAkhir,
    required this.warnaTeks,
    required this.sapaan,
    required this.tanggal,
    this.aksi,
  });

  final Color warnaAwal;
  final Color warnaAkhir;
  final Color warnaTeks;
  final String sapaan;
  final String tanggal;

  /// Slot opsional di pojok kanan atas (mis. pil statistik / tombol).
  final Widget? aksi;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: ClipPath(
        clipper: const _HeaderGelombangClipper(),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 168),
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 36),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [warnaAwal, warnaAkhir],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Dekorasi "blob" transparan untuk kedalaman visual.
              Positioned(
                right: -30,
                top: -40,
                child: _blob(120, Colors.white.withValues(alpha: 0.10)),
              ),
              Positioned(
                right: 60,
                bottom: -50,
                child: _blob(90, Colors.white.withValues(alpha: 0.08)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                        ),
                        child: Icon(
                          Icons.waving_hand_rounded,
                          color: warnaTeks,
                          size: 24,
                        ),
                      ),
                      const Spacer(),
                      if (aksi != null) aksi!,
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    sapaan,
                    style: TextStyle(
                      color: warnaTeks,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tanggal,
                    style: TextStyle(
                      color: warnaTeks.withValues(alpha: 0.78),
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blob(double size, Color warna) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
    );
  }
}

class _HeaderGelombangClipper extends CustomClipper<Path> {
  const _HeaderGelombangClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.84)
      ..cubicTo(
        size.width * 0.72,
        size.height * 1.08,
        size.width * 0.30,
        size.height * 0.66,
        0,
        size.height * 0.92,
      )
      ..close();
  }

  @override
  bool shouldReclip(covariant _HeaderGelombangClipper oldClipper) => false;
}
