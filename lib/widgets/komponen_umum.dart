import 'package:flutter/material.dart';

import '../models/karyawan.dart';
import '../theme/app_theme.dart';

/// Warna khas tiap divisi, dipakai pada avatar karyawan.
Color warnaDivisi(String divisi) {
  switch (divisi) {
    case 'Engineering':
      return const Color(0xFF4F46E5);
    case 'Human Resources':
    case 'HR':
      return const Color(0xFFDB2777);
    case 'Finance':
      return const Color(0xFF059669);
    case 'Marketing':
      return const Color(0xFFEA580C);
    case 'Sales':
      return const Color(0xFF0891B2);
    default:
      return const Color(0xFF64748B);
  }
}

/// "Budi Santoso" -> "BS"
String inisial(String nama) {
  final bagian = nama.trim().split(RegExp(r'\s+'));
  if (bagian.isEmpty || bagian.first.isEmpty) return '?';
  if (bagian.length == 1) return bagian.first[0].toUpperCase();
  return (bagian.first[0] + bagian.last[0]).toUpperCase();
}

/// Kartu serbaguna dengan bayangan lembut & sudut membulat — pengganti
/// `Card` bawaan agar tampilan lebih "didesain" dan konsisten di seluruh
/// aplikasi.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.borderRadius = 24,
    this.gradient,
    this.border = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final Gradient? gradient;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(borderRadius);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: gradient,
        color: gradient == null
            ? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
            : null,
        border: (gradient == null && border)
            ? Border.all(
                color:
                    scheme.outlineVariant.withValues(alpha: isDark ? 0.3 : 0.55),
              )
            : null,
        boxShadow:
            bayanganLembut(context, opacity: gradient != null ? 1.4 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: onTap == null
            ? Padding(padding: padding, child: child)
            : InkWell(
                onTap: onTap,
                child: Padding(padding: padding, child: child),
              ),
      ),
    );
  }
}

/// Tombol utama bergradien dengan bayangan — untuk aksi penting (CTA).
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.gradient = AppColors.gradient,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: disabled ? 0.55 : 1,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: disabled
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF4338CA).withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Judul seksi konsisten (judul + subjudul opsional + aksi opsional).
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style:
                      TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Pil statistik kecil (dipakai pada header beranda).
class StatPill extends StatelessWidget {
  const StatPill({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar bulat berisi inisial, berwarna sesuai divisi, dengan cincin halus.
class AvatarKaryawan extends StatelessWidget {
  const AvatarKaryawan({super.key, required this.karyawan, this.radius = 24});

  final Karyawan karyawan;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final warna = warnaDivisi(karyawan.divisi);
    return Container(
      padding: EdgeInsets.all(radius * 0.08),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: warna.withValues(alpha: 0.35), width: 1.4),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: warna.withValues(alpha: 0.15),
        child: Text(
          inisial(karyawan.nama),
          style: TextStyle(
            color: warna,
            fontWeight: FontWeight.w800,
            fontSize: radius * 0.72,
          ),
        ),
      ),
    );
  }
}

/// Label kecil berbentuk pil (status, nama teknologi, dll).
class ChipStatus extends StatelessWidget {
  const ChipStatus({
    super.key,
    required this.label,
    required this.warna,
    this.icon,
  });

  final String label;
  final Color warna;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: warna.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: warna),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: warna,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tampilan kosong (belum ada data).
class PesanKosong extends StatelessWidget {
  const PesanKosong({
    super.key,
    required this.icon,
    required this.judul,
    required this.pesan,
  });

  final IconData icon;
  final String judul;
  final String pesan;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.primary.withValues(alpha: 0.18),
                    scheme.primary.withValues(alpha: 0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: scheme.primary),
            ),
            const SizedBox(height: 22),
            Text(
              judul,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              pesan,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tampilan error dengan tombol coba lagi.
class PesanError extends StatelessWidget {
  const PesanError({super.key, required this.pesan, required this.onRetry});

  final String pesan;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bersih = pesan.replaceFirst('Exception: ', '');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.error.withValues(alpha: 0.2),
                    scheme.error.withValues(alpha: 0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.cloud_off_rounded, size: 40, color: scheme.error),
            ),
            const SizedBox(height: 22),
            Text(
              'Gagal memuat data',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              bersih,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
            ),
            const SizedBox(height: 22),
            GradientButton(
              label: 'Coba Lagi',
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
              gradient: LinearGradient(
                colors: [scheme.error, scheme.error.withValues(alpha: 0.75)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
