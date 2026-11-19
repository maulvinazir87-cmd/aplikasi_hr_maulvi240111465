import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/karyawan.dart';
import '../theme/app_theme.dart';
import '../widgets/komponen_umum.dart';
import 'gaji_detail_page.dart';
import 'gaji_providers.dart';

class PenggajianPage extends ConsumerWidget {
  const PenggajianPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daftarAsync = ref.watch(daftarGajiProvider);
    final penggajian = ref.watch(penggajianProvider);
    final dataGaji = daftarAsync.asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Penggajian (${penggajian.totalDiproses} diproses)'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            // Dimatikan saat proses berjalan agar status tidak bentrok
            onPressed: penggajian.isProcessing
                ? null
                : () {
                    ref.read(penggajianProvider.notifier).reset();
                    ref.invalidate(daftarGajiProvider);
                  },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: daftarAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Mengambil data penggajian...'),
            ],
          ),
        ),
        error: (error, stackTrace) => PesanError(
          pesan: '$error',
          onRetry: () => ref.invalidate(daftarGajiProvider),
        ),
        data: (daftar) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          itemCount: daftar.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _KartuRingkasan(
                  daftar: daftar,
                  diproses: penggajian.totalDiproses,
                ),
              );
            }
            final karyawan = daftar[index - 1];
            return _BarisGaji(
              karyawan: karyawan,
              sudahDiproses: penggajian.diproses.contains(karyawan.nik),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: GradientButton(
          label: penggajian.isProcessing ? 'Memproses...' : 'Proses Semua',
          icon: Icons.payments_rounded,
          isLoading: penggajian.isProcessing,
          onPressed: penggajian.isProcessing || dataGaji == null
              ? null
              : () => ref.read(penggajianProvider.notifier).prosesSemua(dataGaji),
        ),
      ),
    );
  }
}

class _KartuRingkasan extends StatelessWidget {
  const _KartuRingkasan({required this.daftar, required this.diproses});

  final List<Karyawan> daftar;
  final int diproses;

  @override
  Widget build(BuildContext context) {
    final total = daftar.fold<double>(0, (jumlah, k) => jumlah + k.gajiPokok);
    final progres = daftar.isEmpty ? 0.0 : diproses / daftar.length;

    return SoftCard(
      gradient: AppColors.gradient,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total gaji pokok',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            formatRupiah(total),
            style: const TextStyle(
                color: Colors.white, fontSize: 29, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progres),
            duration: const Duration(milliseconds: 300),
            builder: (context, nilai, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: nilai,
                  minHeight: 10,
                  backgroundColor: Colors.white.withValues(alpha: 0.22),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            '$diproses dari ${daftar.length} karyawan sudah diproses',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _BarisGaji extends StatelessWidget {
  const _BarisGaji({required this.karyawan, required this.sudahDiproses});

  final Karyawan karyawan;
  final bool sudahDiproses;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => GajiDetailPage(nik: karyawan.nik),
            ),
          );
        },
        child: Row(
          children: [
            AvatarKaryawan(karyawan: karyawan),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    karyawan.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${karyawan.nik} • ${karyawan.divisi}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatRupiah(karyawan.gajiPokok),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: sudahDiproses
                  ? const ChipStatus(
                      key: ValueKey('selesai'),
                      label: 'Diproses',
                      warna: AppColors.sukses,
                      icon: Icons.check_circle_rounded,
                    )
                  : const ChipStatus(
                      key: ValueKey('menunggu'),
                      label: 'Menunggu',
                      warna: AppColors.peringatan,
                      icon: Icons.schedule_rounded,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
