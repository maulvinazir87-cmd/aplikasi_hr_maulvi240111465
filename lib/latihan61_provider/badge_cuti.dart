import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cuti_notifier.dart';

class BadgeCuti extends StatelessWidget {
  const BadgeCuti({super.key});

  @override
  Widget build(BuildContext context) {
    final jumlah = context.select<CutiNotifier, int>((n) => n.jumlah);
    debugPrint('BadgeCuti rebuild: $jumlah');
    return Badge(
      backgroundColor: Theme.of(context).colorScheme.primary,
      isLabelVisible: jumlah > 0,
      label: Text('$jumlah'),
      child: const Icon(Icons.beach_access_rounded),
    );
  }
}
