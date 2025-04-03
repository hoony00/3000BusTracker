import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/bus_provider.dart';
import '../../services/bus_service.dart';
import '../component/w_webview.dart';
import '../dialog/w_letter.dart';

class ModeToggleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ModeToggleAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.5), // 투명한 흰색 배경
      elevation: 0,
      centerTitle: true,
      leading: Consumer(
        builder: (context, ref, child) {
          final bool isMisa = ref.watch(selectedStationProvider) == BusStations.misaStation;

          return IconButton(
            icon:  Icon(Icons.map, color:
            isMisa ?  const Color(0xFF33B5E5) : const Color(0xFF7ED321) // 아이콘 색상: 검정
            ),
            tooltip: '웹뷰 열기',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WebViewScreen(),
                ),
              );
            },
          );
        }
      ),
      title: Consumer(
        builder: (context, ref, child) {
          final Map<String, String> stationMode = ref.watch(selectedStationProvider);
          final modeText = stationMode == BusStations.misaStation
              ? '미사 to 야탑'
              : '야탑 to 미사';

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {

                  ref.read(busServiceProvider).getBusArrivalInfo(
                    nodeId: stationMode['nodeId']!,
                    routeId: stationMode['routeId']!,
                    cityId: stationMode['cityId']!,
                  );
                },
                child: AnimatedSwitcher(
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
              ),
            ],
          );
        },
      ),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            final bool isMisa = ref.watch(selectedStationProvider) == BusStations.misaStation;


            return IconButton(
              icon:  Icon(Icons.sync, color:
              isMisa ?  const Color(0xFF7ED321) : const Color(0xFF33B5E5) // 아이콘 색상: 검정
              ), // 아이콘 색상: 검정
              tooltip: '모드 변경',
              onPressed: () {
                ref.read(selectedStationProvider.notifier).state =
                isMisa
                    ? BusStations.yatapStation
                    : BusStations.misaStation;
              },
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
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
