import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/bus_provider.dart';
import '../appbar/w_mode_appbar.dart';
import '../component/w_card.dart';

class BusArrivalScreen extends ConsumerWidget {
  const BusArrivalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStation = ref.watch(selectedStationProvider);
    final busArrivalAsync = ref.watch(busArrivalProvider);

    return Scaffold(
      appBar: ModeToggleAppBar(),
      body: RefreshIndicator(
        color: Color(0xFF33B5E5),
        onRefresh: () => ref.refresh(busArrivalProvider.future),
        child: busArrivalAsync.when(
          data: (busArrivals) {
            if (busArrivals.isEmpty) {
              return Center(child: Text("버스 정보가 아직 없습니다"));
            }

            return ListView.builder(
              itemCount: busArrivals.length,
              itemBuilder: (context, index) {
                final busArrival = busArrivals[index];
                return BusArrivalCard(
                  busArrival: busArrival,
                  stationName: selectedStation['name']!,
                );
              },
            );
          },
          error: (error, stack) => Center(child: Text("버스 정보가 없습니다")),
          loading: () => const Center(child: CircularProgressIndicator(
            color: Color(0xFF33B5E5),

          )),
        ),
      ),
    );
  }
}
