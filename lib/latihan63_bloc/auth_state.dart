import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class Authenticated extends AuthState {
  const Authenticated({required this.nama, required this.email});

  final String nama;
  final String email;

  @override
  List<Object?> get props => [nama, email];
}

final class AuthError extends AuthState {
  const AuthError(this.pesan);

  final String pesan;

  @override
  List<Object?> get props => [pesan];
}
