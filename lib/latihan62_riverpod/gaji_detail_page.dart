import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/karyawan.dart';
import '../theme/app_theme.dart';
import '../widgets/komponen_umum.dart';
import 'gaji_providers.dart';

class GajiDetailPage extends ConsumerWidget {
  const GajiDetailPage({required this.nik, super.key});

  final String nik;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(gajiDetailProvider(nik));
    // Hanya rebuild bila status karyawan INI berubah
    final sudahDiproses = ref.watch(
      penggajianProvider.select((state) => state.diproses.contains(nik)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Gaji')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => PesanError(
          pesan: '$error',
          onRetry: () => ref.invalidate(gajiDetailProvider(nik)),
        ),
        data: (karyawan) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            _KartuProfil(karyawan: karyawan, sudahDiproses: sudahDiproses),
            const SizedBox(height: 16),
            _KartuGaji(gaji: karyawan.gajiPokok),
            const SizedBox(height: 16),
            SoftCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  _DetailBaris(
                    icon: Icons.badge_outlined,
                    label: 'NIK',
                    value: karyawan.nik,
                  ),
                  const Divider(),
                  _DetailBaris(
                    icon: Icons.apartment_rounded,
                    label: 'Divisi',
                    value: karyawan.divisi,
                  ),
                  const Divider(),
                  _DetailBaris(
                    icon: Icons.fact_check_outlined,
                    label: 'Status proses',
                    value: sudahDiproses ? 'Sudah diproses' : 'Belum diproses',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KartuProfil extends StatelessWidget {
  const _KartuProfil({required this.karyawan, required this.sudahDiproses});

  final Karyawan karyawan;
  final bool sudahDiproses;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      child: Center(
        child: Column(
          children: [
            AvatarKaryawan(karyawan: karyawan, radius: 42),
            const SizedBox(height: 16),
            Text(
              karyawan.nama,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            ChipStatus(
              label: sudahDiproses ? 'Sudah diproses' : 'Belum diproses',
              warna: sudahDiproses ? AppColors.sukses : AppColors.peringatan,
              icon: sudahDiproses
                  ? Icons.check_circle_rounded
                  : Icons.schedule_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _KartuGaji extends StatelessWidget {
  const _KartuGaji({required this.gaji});

  final double gaji;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      gradient: AppColors.gradient,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gaji Pokok',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            formatRupiah(gaji),
            style: const TextStyle(
                color: Colors.white, fontSize: 31, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _DetailBaris extends StatelessWidget {
  const _DetailBaris({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: scheme.primary),
          ),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
