import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/app_theme.dart';
import '../widgets/komponen_umum.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';
import 'home_bloc_page.dart';

class LoginBlocPage extends StatefulWidget {
  const LoginBlocPage({super.key});

  @override
  State<LoginBlocPage> createState() => _LoginBlocPageState();
}

class _LoginBlocPageState extends State<LoginBlocPage> {
  final _emailController = TextEditingController(text: 'admin@company.com');
  final _passwordController = TextEditingController();
  bool _sembunyikanPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _kirim(BuildContext context) {
    context.read<AuthCubit>().login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        // listener: efek samping, dipanggil sekali per perubahan state
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(builder: (_) => const HomeBlocPage()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.pesan),
                  backgroundColor: scheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
        },
        // builder: membangun UI sesuai state
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Stack(
            children: [
              // Latar gradien melengkung di bagian atas, dengan dekorasi blob.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 340,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.gradient,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(44)),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        top: -20,
                        child: _blob(130, Colors.white.withValues(alpha: 0.10)),
                      ),
                      Positioned(
                        left: -40,
                        bottom: 20,
                        child: _blob(110, Colors.white.withValues(alpha: 0.08)),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: SafeArea(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.26)),
                          ),
                          child: const Icon(Icons.groups_rounded, color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Selamat Datang',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 29,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Masuk untuk mengelola data karyawan.',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 15),
                        ),
                        const SizedBox(height: 32),
                        SoftCard(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: _emailController,
                                enabled: !isLoading,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.mail_outline_rounded),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                enabled: !isLoading,
                                obscureText: _sembunyikanPassword,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) {
                                  if (!isLoading) _kirim(context);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    tooltip: _sembunyikanPassword
                                        ? 'Tampilkan password'
                                        : 'Sembunyikan password',
                                    icon: Icon(
                                      _sembunyikanPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () => setState(() {
                                      _sembunyikanPassword = !_sembunyikanPassword;
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              GradientButton(
                                label: isLoading ? 'Memproses...' : 'Masuk',
                                icon: isLoading ? null : Icons.login_rounded,
                                isLoading: isLoading,
                                onPressed: isLoading ? null : () => _kirim(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded, color: scheme.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Akun uji: admin@company.com / admin123',
                                  style: TextStyle(
                                    color: scheme.onPrimaryContainer,
                                    fontSize: 13,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        _emailController.text = 'admin@company.com';
                                        _passwordController.text = 'admin123';
                                      },
                                child: const Text('Isi'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
