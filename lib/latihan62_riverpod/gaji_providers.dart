import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/karyawan.dart';
import 'gaji_api.dart';

final gajiApiProvider = Provider<GajiApi>((ref) => GajiApi());

final daftarGajiProvider = FutureProvider<List<Karyawan>>(
  (ref) => ref.watch(gajiApiProvider).fetchDaftarGaji(),
);

final gajiDetailProvider = FutureProvider.family<Karyawan, String>(
  (ref, nik) => ref.watch(gajiApiProvider).fetchDetail(nik),
);

class PenggajianState {
  PenggajianState({List<String> diproses = const [], this.isProcessing = false})
      : diproses = List.unmodifiable(diproses);

  final List<String> diproses;
  final bool isProcessing;

  int get totalDiproses => diproses.length;

  PenggajianState copyWith({List<String>? diproses, bool? isProcessing}) {
    return PenggajianState(
      diproses: diproses ?? this.diproses,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class PenggajianNotifier extends Notifier<PenggajianState> {
  @override
  PenggajianState build() => PenggajianState();

  Future<void> prosesSemua(List<Karyawan> daftar) async {
    if (state.isProcessing) return;
    state = state.copyWith(isProcessing: true);

    final diproses = [...state.diproses];
    for (final karyawan in daftar) {
      if (diproses.contains(karyawan.nik)) continue;
      await Future<void>.delayed(const Duration(milliseconds: 250));
      diproses.add(karyawan.nik);
      state = state.copyWith(diproses: diproses);
    }
    state = state.copyWith(isProcessing: false);
  }

  void reset() {
    state = PenggajianState();
  }
}

final penggajianProvider =
    NotifierProvider<PenggajianNotifier, PenggajianState>(
  PenggajianNotifier.new,
);
