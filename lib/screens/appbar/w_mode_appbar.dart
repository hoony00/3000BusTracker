import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/bus_provider.dart';
import '../../services/bus_service.dart';

class ModeToggleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ModeToggleAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(

      backgroundColor: Colors.white.withOpacity(0.5), // 투명한 흰색 배경
      elevation: 0,
      centerTitle: true,
      title: Consumer(
        builder: (context, ref, child) {
          final Map<String, String> stationMode = ref.watch(selectedStationProvider);
          final modeText = stationMode == BusStations.misaStation
              ? '미사 to 야탑'
              : '야탑 to 미사';

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Text(
                  modeText,
                  key: ValueKey(modeText),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // 텍스트 색상: 검정
                  ),
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            final Map<String, String> stationMode = ref.watch(selectedStationProvider);
            return IconButton(
              icon: const Icon(Icons.sync, color: Colors.black), // 아이콘 색상: 검정
              tooltip: '모드 변경',
              onPressed: () {
                ref.read(selectedStationProvider.notifier).state =
                stationMode == BusStations.misaStation
                    ? BusStations.yatapStation
                    : BusStations.misaStation;
              },
            );
          },
        ),
      ],
      bottom:  PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
