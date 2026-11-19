import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/karyawan.dart';
import '../theme/app_theme.dart';
import '../widgets/komponen_umum.dart';
import 'cuti_notifier.dart';

class RingkasanCutiPage extends StatelessWidget {
  const RingkasanCutiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pengajuan = context.watch<CutiNotifier>().pengajuan;
    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Cuti')),
      body: pengajuan.isEmpty
          ? const PesanKosong(
              icon: Icons.event_available_rounded,
              judul: 'Belum ada pengajuan cuti',
              pesan: 'Kembali ke daftar karyawan lalu ketuk "Ajukan" '
                  'untuk menambahkan pengajuan.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                _KartuTotal(jumlah: pengajuan.length),
                const SizedBox(height: 22),
                SectionHeading(
                  title: 'Daftar pengajuan',
                  subtitle: '${pengajuan.length} karyawan',
                ),
                const SizedBox(height: 14),
                for (final nik in pengajuan) _BarisPengajuan(nik: nik),
              ],
            ),
    );
  }
}

class _KartuTotal extends StatelessWidget {
  const _KartuTotal({required this.jumlah});

  final int jumlah;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      gradient: AppColors.gradient,
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.beach_access_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$jumlah karyawan',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  'mengajukan cuti',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarisPengajuan extends StatelessWidget {
  const _BarisPengajuan({required this.nik});

  final String nik;

  @override
  Widget build(BuildContext context) {
    final karyawan = cariKaryawan(nik);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        child: Row(
          children: [
            if (karyawan != null) AvatarKaryawan(karyawan: karyawan),
            if (karyawan != null) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    karyawan?.nama ?? nik,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  if (karyawan != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      '${karyawan.nik} • ${karyawan.divisi}',
                      style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
            IconButton.filledTonal(
              tooltip: 'Batalkan pengajuan',
              icon: const Icon(Icons.close_rounded),
              onPressed: () => context.read<CutiNotifier>().batalkan(nik),
            ),
          ],
        ),
      ),
    );
  }
}
