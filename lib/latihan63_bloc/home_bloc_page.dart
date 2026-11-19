import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/app_theme.dart';
import '../widgets/komponen_umum.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';
import 'login_bloc_page.dart';

class HomeBlocPage extends StatelessWidget {
  const HomeBlocPage({super.key});

  void _logout(BuildContext context) {
    context.read<AuthCubit>().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const LoginBlocPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda HR'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _logout(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        // Setelah logout, tampilan lama dipertahankan selama transisi halaman
        buildWhen: (sebelum, sesudah) => sesudah is Authenticated,
        builder: (context, state) {
          if (state is! Authenticated) {
            return const PesanKosong(
              icon: Icons.lock_outline_rounded,
              judul: 'Tidak ada sesi aktif',
              pesan: 'Silakan login terlebih dahulu.',
            );
          }
          final scheme = Theme.of(context).colorScheme;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              SoftCard(
                gradient: AppColors.gradient,
                padding: const EdgeInsets.all(26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: Text(
                          inisial(state.nama),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Selamat datang,',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.nama,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 27, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SoftCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.mail_outline_rounded, color: scheme.primary),
                        const SizedBox(width: 12),
                        Text('Email', style: TextStyle(color: scheme.onSurfaceVariant)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.email,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    Row(
                      children: [
                        Icon(Icons.verified_user_outlined, color: scheme.primary),
                        const SizedBox(width: 12),
                        Text('Status', style: TextStyle(color: scheme.onSurfaceVariant)),
                        const Spacer(),
                        const ChipStatus(
                          label: 'Sesi aktif',
                          warna: AppColors.sukses,
                          icon: Icons.check_circle_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              OutlinedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
              ),
            ],
          );
        },
      ),
    );
  }
}
