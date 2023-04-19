import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ThriftyCircle extends StatefulWidget {
  const ThriftyCircle({super.key});

  @override
  State<ThriftyCircle> createState() => _ThriftyCircleState();
}

class _ThriftyCircleState extends State<ThriftyCircle> {
  List<_ChartData>? Data;
  TooltipBehavior? _tooltip;
  String? currentPlanId;
  Future<String> fetchtrackId() async {
    String trackId;
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    trackId = userDoc['activePlanDocId'];
    return trackId;
  }

  @override
  void initState() {
    fetchtrackId().then((value) {
      setState(() {
        currentPlanId = value;
      });
      _tooltip = TooltipBehavior(enable: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;
    return SizedBox(
      width: screenW,
      height: screenH / 4,
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('user')
            .doc(user!.uid)
            .collection('track')
            .doc(currentPlanId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final data = snapshot.data!;
            Data = [
              _ChartData('Food', data['foodBudget']),
              _ChartData('Travel', data['travelBudget']),
              _ChartData('Clothing', data['clothingBudget']),
              _ChartData('Miscellaneous', data['miscellaneousBudget']),
            ];
            return SizedBox(
              height: 800,
              width: 500,
              child: SfCircularChart(
                tooltipBehavior: _tooltip,
                series: <CircularSeries<_ChartData, String>>[
                  DoughnutSeries<_ChartData, String>(
                    enableTooltip: true,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    innerRadius: '30',
                    dataSource: Data,
                    xValueMapper: (_ChartData foodData, _) => foodData.x,
                    yValueMapper: (_ChartData foodData, _) => foodData.y,
                    name: 'ThriftyCircle',
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
