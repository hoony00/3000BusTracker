import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/bus_provider.dart';
import '../appbar/w_mode_appbar.dart';
import '../component/w_card.dart';
import '../component/w_empty.dart';
import '../dialog/w_letter.dart';

import '../component/w_today.dart'; // 파일 import

class BusArrivalScreen extends ConsumerWidget {
  const BusArrivalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStation = ref.watch(selectedStationProvider);
    final busArrivalAsync = ref.watch(busArrivalProvider);

    return Scaffold(
      appBar: ModeToggleAppBar(),
      floatingActionButton: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AnimatedLetterDialog(),
          );
        },
        icon: Icon(Icons.mail, size: 35, color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/back2.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: RefreshIndicator(
              color: Color(0xFF33B5E5),
              onRefresh: () => ref.refresh(busArrivalProvider.future),
              child: busArrivalAsync.when(
                data: (busArrivals) {
                  if (busArrivals.isEmpty) {
                    return BusInfoNotFound();
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
                error: (error, stack) => BusInfoNotFound(),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          const TodayWidget(), // D-Day 위젯 추가
        ],
      ),
    );
  }
}

