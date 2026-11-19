class Karyawan {
  const Karyawan({
    required this.nik,
    required this.nama,
    required this.divisi,
    required this.gajiPokok,
  });

  final String nik;
  final String nama;
  final String divisi;
  final double gajiPokok;
}

const List<Karyawan> dummyKaryawan = [
  Karyawan(
    nik: 'ENG-001',
    nama: 'Budi Santoso',
    divisi: 'Engineering',
    gajiPokok: 9500000,
  ),
  Karyawan(
    nik: 'ENG-002',
    nama: 'Siti Aminah',
    divisi: 'Engineering',
    gajiPokok: 9000000,
  ),
  Karyawan(
    nik: 'ENG-003',
    nama: 'Andi Pratama',
    divisi: 'Engineering',
    gajiPokok: 8500000,
  ),
  Karyawan(
    nik: 'HR-004',
    nama: 'Dewi Lestari',
    divisi: 'Human Resources',
    gajiPokok: 8000000,
  ),
  Karyawan(
    nik: 'HR-005',
    nama: 'Rina Marlina',
    divisi: 'Human Resources',
    gajiPokok: 7800000,
  ),
  Karyawan(
    nik: 'FIN-006',
    nama: 'Agus Wijaya',
    divisi: 'Finance',
    gajiPokok: 8200000,
  ),
  Karyawan(
    nik: 'FIN-007',
    nama: 'Maya Putri',
    divisi: 'Finance',
    gajiPokok: 8100000,
  ),
  Karyawan(
    nik: 'MKT-008',
    nama: 'Rudi Hartono',
    divisi: 'Marketing',
    gajiPokok: 7500000,
  ),
  Karyawan(
    nik: 'SAL-009',
    nama: 'Lina Aprilia',
    divisi: 'Sales',
    gajiPokok: 7200000,
  ),
  Karyawan(
    nik: 'SAL-010',
    nama: 'Kartika Sari',
    divisi: 'Sales',
    gajiPokok: 7000000,
  ),
];

Karyawan? cariKaryawan(String nik) {
  for (final karyawan in dummyKaryawan) {
    if (karyawan.nik == nik) return karyawan;
  }
  return null;
}

String formatRupiah(double value) {
  final angka = value.round().toString();
  final hasil = StringBuffer();
  for (var index = 0; index < angka.length; index++) {
    if (index > 0 && (angka.length - index) % 3 == 0) {
      hasil.write('.');
    }
    hasil.write(angka[index]);
  }
  return 'Rp $hasil';
}
