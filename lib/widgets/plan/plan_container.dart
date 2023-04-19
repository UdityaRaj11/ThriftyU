import 'package:flutter/material.dart';
import 'package:thriftyu/widgets/plan/plan_box.dart';
import 'package:thriftyu/widgets/plan/thrifty_circle.dart';

class PlanContainer extends StatelessWidget {
  const PlanContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    return Container(
      height: screenH / 1.4,
      width: screenW,
      padding: const EdgeInsets.all(8),
      color: const Color.fromARGB(255, 29, 37, 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Thrifty Plan',
            style: TextStyle(
              color: Color.fromARGB(255, 236, 236, 236),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 21,
          ),
          ThriftyCircle(),
          PlanBox(),
        ],
      ),
    );
  }
}
