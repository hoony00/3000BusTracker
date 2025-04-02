import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/mode_provider.dart';

class ModeToggleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ModeToggleAppBar({super.key});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Consumer(
          builder: (context, ref, child) {
            final stationMode = ref.watch(stationModeProvider);

            final modeText = stationMode == StationMode.misa ? '미사역' : '야탑역';

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                modeText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.sync),
                tooltip: '모드 변경',
                onPressed: () {
                  // 현재 모드에 따라 토글
                  ref.read(stationModeProvider.notifier).state =
                      stationMode == StationMode.misa
                          ? StationMode.yatap
                          : StationMode.misa;
                },
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
