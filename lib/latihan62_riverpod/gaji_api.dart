import 'dart:math';

import '../models/karyawan.dart';

class GajiApi {
  GajiApi({Random? random}) : _random = random ?? Random();

  final Random _random;

  Future<List<Karyawan>> fetchDaftarGaji() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (_random.nextDouble() < 0.25) {
      throw Exception('Gagal terhubung ke server penggajian');
    }
    return dummyKaryawan;
  }

  Future<Karyawan> fetchDetail(String nik) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final karyawan = cariKaryawan(nik);
    if (karyawan == null) {
      throw Exception('Data karyawan dengan NIK $nik tidak ditemukan');
    }
    return karyawan;
  }
}
