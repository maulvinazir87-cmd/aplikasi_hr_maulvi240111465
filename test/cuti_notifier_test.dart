import 'package:flutter_test/flutter_test.dart';
import 'package:toko_app/latihan61_provider/cuti_notifier.dart';

void main() {
  test('ajukan dan batalkan cuti karyawan', () {
    final notifier = CutiNotifier();

    notifier.ajukan('ENG-001');
    expect(notifier.jumlah, 1);
    expect(notifier.sudahMengajukan('ENG-001'), isTrue);

    notifier.batalkan('ENG-001');
    expect(notifier.jumlah, 0);
    expect(notifier.sudahMengajukan('ENG-001'), isFalse);
  });

  test('pengajuan cuti tidak menambahkan NIK yang sama dua kali', () {
    final notifier = CutiNotifier();

    notifier.ajukan('HR-004');
    notifier.ajukan('HR-004');

    expect(notifier.jumlah, 1);
  });
}
