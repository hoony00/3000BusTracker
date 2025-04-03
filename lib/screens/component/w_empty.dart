import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/bus_provider.dart';
import '../../services/bus_service.dart'; // busArrivalProvider가 정의된 파일을 import 합니다.

class BusInfoNotFound extends StatelessWidget {
  const BusInfoNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 300),
      child: Center(
        child: Container(
          width: 250,
          height: 250,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "버스 정보가 아직 없습니다",
                style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20), // 텍스트와 버튼 사이의 간격
              Consumer(
                builder: (context, ref, child) {


                  return IconButton(
                    onPressed: () {
                      final station = ref.watch(selectedStationProvider);

                      ref
                          .read(busServiceProvider)
                          .getBusArrivalInfo(
                            nodeId: station['nodeId']!,
                            routeId: station['routeId']!,
                            cityId: station['cityId']!,
                          );
                    },
                    icon: Icon(
                      Icons.refresh,
                      size: 35,
                      color: Colors.black87,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
