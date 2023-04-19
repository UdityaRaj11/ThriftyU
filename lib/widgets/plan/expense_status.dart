import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseStatus extends StatefulWidget {
  const ExpenseStatus({super.key});

  @override
  State<ExpenseStatus> createState() => _ExpenseStatusState();
}

class _ExpenseStatusState extends State<ExpenseStatus> {
  List<_ChartData>? foodData;
  List<_ChartData>? travelData;
  List<_ChartData>? clothingData;
  List<_ChartData>? misceData;
  TooltipBehavior? _tooltip1;
  TooltipBehavior? _tooltip2;
  TooltipBehavior? _tooltip3;
  TooltipBehavior? _tooltip4;
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
      _tooltip1 = TooltipBehavior(enable: true);
      _tooltip2 = TooltipBehavior(enable: true);
      _tooltip3 = TooltipBehavior(enable: true);
      _tooltip4 = TooltipBehavior(enable: true);
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
      height: screenH / 6,
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
            foodData = [
              _ChartData('Food', data['spentFood']),
              _ChartData('remaining', data['foodBudget'] - data['spentFood']),
            ];
            travelData = [
              _ChartData('Travel', data['spentTravel']),
              _ChartData(
                  'remaining', data['travelBudget'] - data['spentTravel']),
            ];
            clothingData = [
              _ChartData('Clothing', data['spentClothing']),
              _ChartData(
                  'remianing', data['clothingBudget'] - data['spentClothing']),
            ];

            misceData = [
              _ChartData('Miscellaneous', data['spentMiscellaneous']),
              _ChartData('remaining',
                  data['miscellaneousBudget'] - data['spentMiscellaneous']),
            ];
            return GridView(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children: [
                SizedBox(
                  height: 800,
                  width: 500,
                  child: SfCircularChart(
                    palette: const <Color>[
                      Colors.grey,
                      Color.fromARGB(255, 83, 164, 86)
                    ],
                    tooltipBehavior: _tooltip1,
                    series: <CircularSeries<_ChartData, String>>[
                      DoughnutSeries<_ChartData, String>(
                        innerRadius: '16',
                        dataSource: foodData,
                        xValueMapper: (_ChartData foodData, _) => foodData.x,
                        yValueMapper: (_ChartData foodData, _) => foodData.y,
                        name: 'Food',
                      )
                    ],
                    title: ChartTitle(
                      text: 'Food',
                      textStyle: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 800,
                  width: 500,
                  child: SfCircularChart(
                    palette: const <Color>[
                      Colors.grey,
                      Color.fromARGB(255, 83, 164, 86)
                    ],
                    tooltipBehavior: _tooltip2,
                    series: <CircularSeries<_ChartData, String>>[
                      DoughnutSeries<_ChartData, String>(
                          innerRadius: '16',
                          dataSource: travelData,
                          xValueMapper: (_ChartData travelData, _) =>
                              travelData.x,
                          yValueMapper: (_ChartData travelData, _) =>
                              travelData.y,
                          name: 'Travel')
                    ],
                    title: ChartTitle(
                      text: 'Travel',
                      textStyle: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 800,
                  width: 500,
                  child: SfCircularChart(
                    palette: const <Color>[
                      Colors.grey,
                      Color.fromARGB(255, 83, 164, 86)
                    ],
                    tooltipBehavior: _tooltip3,
                    series: <CircularSeries<_ChartData, String>>[
                      DoughnutSeries<_ChartData, String>(
                          innerRadius: '16',
                          dataSource: misceData,
                          xValueMapper: (_ChartData misceData, _) =>
                              misceData.x,
                          yValueMapper: (_ChartData misceData, _) =>
                              misceData.y,
                          name: 'Miscellaneouse')
                    ],
                    title: ChartTitle(
                      text: 'Miscellaneouse',
                      textStyle: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 800,
                  width: 500,
                  child: SfCircularChart(
                    palette: const <Color>[
                      Colors.grey,
                      Color.fromARGB(255, 83, 164, 86)
                    ],
                    tooltipBehavior: _tooltip4,
                    series: <CircularSeries<_ChartData, String>>[
                      DoughnutSeries<_ChartData, String>(
                          innerRadius: '16',
                          dataSource: clothingData,
                          xValueMapper: (_ChartData clothingData, _) =>
                              clothingData.x,
                          yValueMapper: (_ChartData clothingData, _) =>
                              clothingData.y,
                          name: 'Clothing')
                    ],
                    title: ChartTitle(
                      text: 'Clothing',
                      textStyle: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox(
            child: Center(child: Text('Create a Plan First.')),
          );
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
