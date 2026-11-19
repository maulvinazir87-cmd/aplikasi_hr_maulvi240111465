import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'latihan61_provider/daftar_karyawan_page.dart';
import 'latihan62_riverpod/penggajian_page.dart';
import 'latihan63_bloc/auth_cubit.dart';
import 'latihan63_bloc/auth_state.dart';
import 'latihan63_bloc/home_bloc_page.dart';
import 'latihan63_bloc/login_bloc_page.dart';
import 'models/karyawan.dart';
import 'pages/dashboard_hr.dart';
import 'theme/app_theme.dart';
import 'widgets/header_gelombang.dart';
import 'widgets/komponen_umum.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _hari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  static const _bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  String _sapaan() {
    final jam = DateTime.now().hour;
    if (jam < 11) return 'Selamat Pagi';
    if (jam < 15) return 'Selamat Siang';
    if (jam < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  String _tanggal() {
    final n = DateTime.now();
    return '${_hari[n.weekday - 1]}, ${n.day} ${_bulan[n.month - 1]} ${n.year}';
  }

  void _buka(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }

  void _toggleTema(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    themeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.badge_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('Aplikasi HR'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'Mode terang' : 'Mode gelap',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: () => _toggleTema(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        children: [
          HeaderGelombang(
            warnaAwal: AppColors.gradient.colors.first,
            warnaAkhir: AppColors.gradient.colors.last,
            warnaTeks: Colors.white,
            sapaan: '${_sapaan()}, Admin!',
            tanggal: _tanggal(),
            aksi: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const StatPill(icon: Icons.layers_rounded, label: '4 Modul'),
                const SizedBox(width: 8),
                StatPill(
                  icon: Icons.groups_rounded,
                  label: '${dummyKaryawan.length} Karyawan',
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const SectionHeading(
            title: 'Latihan Manajemen State',
            subtitle: 'Empat pendekatan, satu aplikasi HR.',
          ),
          const SizedBox(height: 14),
          _KartuMenu(
            icon: Icons.beach_access_rounded,
            warna: const Color(0xFFEA580C),
            judul: 'Pengajuan Cuti',
            label: 'Latihan 6.1',
            deskripsi: 'Daftar karyawan, badge AppBar, dan ringkasan cuti.',
            teknologi: 'Provider',
            onTap: () => _buka(context, const DaftarKaryawanPage()),
          ),
          const SizedBox(height: 12),
          _KartuMenu(
            icon: Icons.payments_rounded,
            warna: const Color(0xFF059669),
            judul: 'Penggajian',
            label: 'Latihan 6.2',
            deskripsi: 'Data async dari API simulasi, proses semua, detail.',
            teknologi: 'Riverpod 3',
            onTap: () => _buka(context, const PenggajianPage()),
          ),
          const SizedBox(height: 12),
          _KartuMenu(
            icon: Icons.lock_rounded,
            warna: const Color(0xFF4F46E5),
            judul: 'Login',
            label: 'Latihan 6.3',
            deskripsi: 'Form login dengan loading, error, dan logout.',
            teknologi: 'Cubit (flutter_bloc)',
            onTap: () {
              // Jika sesi sudah aktif, langsung ke beranda.
              final sudahLogin =
                  context.read<AuthCubit>().state is Authenticated;
              _buka(
                context,
                sudahLogin ? const HomeBlocPage() : const LoginBlocPage(),
              );
            },
          ),
          const SizedBox(height: 12),
          _KartuMenu(
            icon: Icons.dashboard_customize_rounded,
            warna: const Color(0xFF7C3AED),
            judul: 'Dashboard HR',
            label: 'Bonus',
            deskripsi: 'Ringkasan statistik, kehadiran, dan aktivitas tim.',
            teknologi: 'Responsive Layout',
            onTap: () => _buka(
              context,
              DashboardHR(
                onToggleTheme: () => _toggleTema(context),
                headerGelombang: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuMenu extends StatelessWidget {
  const _KartuMenu({
    required this.icon,
    required this.warna,
    required this.judul,
    required this.label,
    required this.deskripsi,
    required this.teknologi,
    required this.onTap,
  });

  final IconData icon;
  final Color warna;
  final String judul;
  final String label;
  final String deskripsi;
  final String teknologi;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  warna.withValues(alpha: 0.22),
                  warna.withValues(alpha: 0.10),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: warna, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      judul,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15.5),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  deskripsi,
                  style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 13,
                      height: 1.35),
                ),
                const SizedBox(height: 10),
                ChipStatus(label: teknologi, warna: warna),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.chevron_right_rounded, color: scheme.outline),
        ],
      ),
    );
  }
}
