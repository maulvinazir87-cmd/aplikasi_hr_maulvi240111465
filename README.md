# Aplikasi HR

Aplikasi demo manajemen sumber daya manusia (HR) yang dibuat dengan Flutter.
Proyek ini menampilkan beberapa pendekatan pengelolaan state melalui modul cuti,
penggajian, login, dan dashboard HR.

## Identitas

- Nama: **Maulvi Nazir Rahmat**
- NIM: **240111465**

## Repository

[maulvinazir87-cmd/aplikasi_hr_maulvi240111465](https://github.com/maulvinazir87-cmd/aplikasi_hr_maulvi240111465)

## Fitur

- Beranda HR dengan empat modul dan pilihan tema terang/gelap.
- **Pengajuan cuti:** pencarian karyawan, pengajuan dan pembatalan cuti, badge, serta ringkasan dengan Provider.
- **Penggajian:** daftar dan detail gaji, status pemuatan/kesalahan, serta simulasi pemrosesan dengan Riverpod.
- **Login:** status login, pemuatan, pesan kesalahan, dan logout menggunakan Cubit (`flutter_bloc`).
- **Dashboard HR:** ringkasan statistik, kehadiran per divisi, dan aktivitas dengan tata letak responsif.

## Teknologi

- Flutter dan Dart
- Provider
- Riverpod (`flutter_riverpod`)
- Cubit / `flutter_bloc`
- Equatable
- Material 3

## Menjalankan aplikasi di web

Pastikan Flutter SDK dan Google Chrome telah tersedia. Dari direktori utama
proyek, jalankan:

```bash
flutter pub get
flutter run -d chrome
```

## Struktur proyek

```text
lib/
  latihan61_provider/  Pengajuan dan ringkasan cuti
  latihan62_riverpod/  Penggajian dan pengelolaan state Riverpod
  latihan63_bloc/      Login dan sesi dengan Cubit
  models/              Model dan data contoh karyawan
  pages/               Dashboard HR
  theme/               Tema, warna, dan mode tampilan
  widgets/             Komponen UI bersama
  home_page.dart       Beranda dan navigasi ke modul
  main.dart            Titik masuk aplikasi dan penyedia state
```

## Catatan

Aplikasi ini masih berupa demo: data karyawan dan statistik menggunakan data
contoh, data cuti hanya disimpan selama aplikasi berjalan, dan penggajian
menggunakan API simulasi lokal—belum terhubung ke backend atau layanan HR
eksternal.

Untuk mencoba login demo, gunakan:

- Email: `admin@company.com`
- Password: `admin123`
