import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/karyawan.dart';
import '../theme/app_theme.dart';
import '../widgets/komponen_umum.dart';
import 'badge_cuti.dart';
import 'cuti_notifier.dart';
import 'ringkasan_cuti_page.dart';

class DaftarKaryawanPage extends StatefulWidget {
  const DaftarKaryawanPage({super.key});

  @override
  State<DaftarKaryawanPage> createState() => _DaftarKaryawanPageState();
}

class _DaftarKaryawanPageState extends State<DaftarKaryawanPage> {
  final _cariController = TextEditingController();
  String _kueri = '';

  @override
  void dispose() {
    _cariController.dispose();
    super.dispose();
  }

  void _bukaRingkasan() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const RingkasanCutiPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kueri = _kueri.trim().toLowerCase();
    final daftar = kueri.isEmpty
        ? dummyKaryawan
        : dummyKaryawan
            .where(
              (k) =>
                  k.nama.toLowerCase().contains(kueri) ||
                  k.nik.toLowerCase().contains(kueri) ||
                  k.divisi.toLowerCase().contains(kueri),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan Cuti'),
        actions: [
          IconButton(
            tooltip: 'Ringkasan cuti',
            icon: const BadgeCuti(),
            onPressed: _bukaRingkasan,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Column(
              children: [
                _RingkasanMini(onTap: _bukaRingkasan),
                const SizedBox(height: 14),
                TextField(
                  controller: _cariController,
                  onChanged: (v) => setState(() => _kueri = v),
                  decoration: InputDecoration(
                    hintText: 'Cari nama, NIK, atau divisi...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _kueri.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => setState(() {
                              _cariController.clear();
                              _kueri = '';
                            }),
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: daftar.isEmpty
                ? const PesanKosong(
                    icon: Icons.search_off_rounded,
                    judul: 'Tidak ditemukan',
                    pesan: 'Coba kata kunci lain untuk mencari karyawan.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: daftar.length,
                    itemBuilder: (context, index) =>
                        KaryawanCutiTile(karyawan: daftar[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _RingkasanMini extends StatelessWidget {
  const _RingkasanMini({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final jumlah = context.select<CutiNotifier, int>((n) => n.jumlah);
    return SoftCard(
      onTap: onTap,
      gradient: AppColors.gradient,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.beach_access_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$jumlah pengajuan cuti aktif',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ketuk untuk lihat ringkasan',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8), fontSize: 12.5),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white),
        ],
      ),
    );
  }
}

class KaryawanCutiTile extends StatelessWidget {
  const KaryawanCutiTile({required this.karyawan, super.key});

  final Karyawan karyawan;

  @override
  Widget build(BuildContext context) {
    // Tile hanya rebuild jika status cuti karyawan INI berubah
    final sudahMengajukan = context.select<CutiNotifier, bool>(
      (n) => n.sudahMengajukan(karyawan.nik),
    );
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: sudahMengajukan
              ? Color.alphaBlend(
                  scheme.primary.withValues(alpha: 0.08),
                  Theme.of(context).cardTheme.color ?? scheme.surface,
                )
              : (Theme.of(context).cardTheme.color ?? scheme.surface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: sudahMengajukan
                ? scheme.primary.withValues(alpha: 0.5)
                : scheme.outlineVariant.withValues(alpha: 0.55),
            width: sudahMengajukan ? 1.6 : 1,
          ),
          boxShadow: bayanganLembut(context, opacity: 0.6),
        ),
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
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: sudahMengajukan
                  ? OutlinedButton(
                      key: const ValueKey('batal'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(84, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      onPressed: () =>
                          context.read<CutiNotifier>().batalkan(karyawan.nik),
                      child: const Text('Batal'),
                    )
                  : FilledButton(
                      key: const ValueKey('ajukan'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(84, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      onPressed: () {
                        context.read<CutiNotifier>().ajukan(karyawan.nik);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              duration: const Duration(milliseconds: 1400),
                              content: Text('Cuti ${karyawan.nama} diajukan'),
                            ),
                          );
                      },
                      child: const Text('Ajukan'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
