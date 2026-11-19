import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/header_gelombang.dart';
import '../widgets/komponen_umum.dart';

class DashboardHR extends StatelessWidget {
  const DashboardHR({
    super.key,
    required this.onToggleTheme,
    this.headerGelombang = false,
  });

  /// Callback untuk berpindah light/dark mode.
  final VoidCallback onToggleTheme;

  /// true = pakai header bergelombang, false = banner biasa.
  final bool headerGelombang;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;
        return _buildDashboard(context, isTablet);
      },
    );
  }

  Widget _buildDashboard(BuildContext context, bool isTablet) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color warnaAwal =
        isDark ? colors.primaryContainer : AppColors.gradient.colors.first;
    final Color warnaAkhir =
        isDark ? colors.tertiaryContainer : AppColors.gradient.colors.last;
    final Color warnaTeks = isDark ? colors.onPrimaryContainer : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.apartment_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text('PT Maju Bersama', overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'Mode terang' : 'Mode gelap',
            icon:
                Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: onToggleTheme,
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: AppColors.bahaya,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          const CircleAvatar(radius: 16, child: Icon(Icons.person_rounded, size: 20)),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (headerGelombang)
              HeaderGelombang(
                warnaAwal: warnaAwal,
                warnaAkhir: warnaAkhir,
                warnaTeks: warnaTeks,
                sapaan: 'Selamat Pagi, Admin!',
                tanggal: 'Senin, 7 Oktober 2024',
              )
            else
              _bannerSapaan(warnaAwal, warnaAkhir, warnaTeks),
            const SizedBox(height: 22),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isTablet ? 1.4 : 1.25,
              children: [
                _kartuStat(context, '248', 'Karyawan',
                    Icons.people_alt_rounded, colors.primary),
                _kartuStat(context, '95%', 'Hadir',
                    Icons.check_circle_rounded, AppColors.sukses),
                _kartuStat(context, '12', 'Cuti',
                    Icons.beach_access_rounded, AppColors.peringatan),
                _kartuStat(context, '3', 'Rekrut',
                    Icons.person_add_rounded, AppColors.accent),
              ],
            ),
            const SizedBox(height: 24),
            const SectionHeading(
              title: 'Kehadiran per Divisi',
              subtitle: 'Persentase bulan ini',
            ),
            const SizedBox(height: 14),
            SoftCard(
              child: Column(
                children:
                    _divisi.map((d) => _barDivisi(colors, d.nama, d.persen)).toList(),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: SectionHeading(title: 'Aktivitas Terkini'),
                ),
                TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
              ],
            ),
            const SizedBox(height: 10),
            ...List.generate(
              _aktivitas.length,
              (i) => _kartuAktivitas(_aktivitas[i]),
            ),
            const SizedBox(height: 16),
            if (isTablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _kartuDaftar(context, 'Terbaru Absen',
                        Icons.login_rounded, _absenTerbaru, colors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _kartuDaftar(context, 'Terbaru Cuti',
                        Icons.beach_access_rounded, _cutiTerbaru, AppColors.peringatan),
                  ),
                ],
              )
            else ...[
              _kartuDaftar(context, 'Terbaru Absen', Icons.login_rounded,
                  _absenTerbaru, colors.primary),
              const SizedBox(height: 12),
              _kartuDaftar(context, 'Terbaru Cuti', Icons.beach_access_rounded,
                  _cutiTerbaru, AppColors.peringatan),
            ],
          ],
        ),
      ),
    );
  }

  Widget _bannerSapaan(Color awal, Color akhir, Color teks) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 128,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [awal, akhir],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          left: 22,
          top: 0,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selamat Pagi, Admin!',
                style: TextStyle(
                    color: teks, fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Senin, 7 Oktober 2024',
                style: TextStyle(color: teks.withValues(alpha: 0.75)),
              ),
            ],
          ),
        ),
        Positioned(
          right: 22,
          top: 0,
          bottom: 0,
          child: Center(
            child: Icon(Icons.waving_hand_rounded,
                color: teks.withValues(alpha: 0.5), size: 60),
          ),
        ),
      ],
    );
  }

  Widget _kartuStat(
      BuildContext context, String nilai, String label, IconData icon, Color warna) {
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: warna.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: warna, size: 19),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nilai,
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800, color: warna)),
              Text(label,
                  style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }

  static const List<({String nama, int persen})> _divisi = [
    (nama: 'Engineering', persen: 92),
    (nama: 'Sales', persen: 85),
    (nama: 'HR', persen: 97),
    (nama: 'Finance', persen: 90),
  ];

  Widget _barDivisi(ColorScheme colors, String nama, int persen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          SizedBox(width: 92, child: Text(nama, overflow: TextOverflow.ellipsis)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Expanded(
                    flex: persen,
                    child: Container(
                      height: 14,
                      decoration: const BoxDecoration(gradient: AppColors.gradient),
                    ),
                  ),
                  Expanded(
                    flex: 100 - persen,
                    child: Container(height: 14, color: colors.surfaceContainerHighest),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 42,
            child: Text('$persen%',
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  static const List<
      ({String nama, String aksi, String waktu, IconData icon, Color warna})> _aktivitas = [
    (
      nama: 'Budi Santoso',
      aksi: 'Mengajukan cuti',
      waktu: '09:14',
      icon: Icons.beach_access_rounded,
      warna: AppColors.peringatan,
    ),
    (
      nama: 'Citra Dewi',
      aksi: 'Check-in absensi',
      waktu: '08:02',
      icon: Icons.check_circle_rounded,
      warna: AppColors.sukses,
    ),
    (
      nama: 'Eko Wahyudi',
      aksi: 'Upload kontrak baru',
      waktu: '07:45',
      icon: Icons.description_rounded,
      warna: AppColors.info,
    ),
  ];

  Widget _kartuAktivitas(
      ({String nama, String aksi, String waktu, IconData icon, Color warna}) d) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: d.warna.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(d.icon, color: d.warna, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.nama,
                      style:
                          const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text(d.aksi, style: const TextStyle(fontSize: 12.5)),
                ],
              ),
            ),
            Text(d.waktu, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  static const List<({String nama, String info})> _absenTerbaru = [
    (nama: 'Citra Dewi', info: '08:02'),
    (nama: 'Fajar Nugroho', info: '07:58'),
    (nama: 'Gita Lestari', info: '07:51'),
  ];

  static const List<({String nama, String info})> _cutiTerbaru = [
    (nama: 'Budi Santoso', info: '3 hari'),
    (nama: 'Hana Putri', info: '1 hari'),
    (nama: 'Indra Wijaya', info: '5 hari'),
  ];

  Widget _kartuDaftar(BuildContext context, String judul, IconData icon,
      List<({String nama, String info})> data, Color warna) {
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: warna),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(judul,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const Divider(height: 24),
          for (final d in data)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(d.nama, overflow: TextOverflow.ellipsis)),
                  Text(
                    d.info,
                    style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
