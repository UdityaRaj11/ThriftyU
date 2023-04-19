import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlanBox extends StatefulWidget {
  const PlanBox({super.key});

  @override
  State<PlanBox> createState() => _PlanBoxState();
}

class _PlanBoxState extends State<PlanBox> {
  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;
    return SizedBox(
      height: screenH / 2.7,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(user!.uid)
              .collection('plans')
              .orderBy('creationTime', descending: true)
              .snapshots(),
          builder: (ctx, planSnapshot) {
            if (planSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final planDoc = planSnapshot.data!.docs;
            return ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: 4,
                itemBuilder: (ctx, index) {
                  return Card(
                    color: const Color.fromARGB(255, 237, 237, 237),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        style: ListTileStyle.drawer,
                        leading: Icon(
                          planDoc[0]['prio${index + 1}'] == 'Food'
                              ? Icons.food_bank
                              : planDoc[0]['prio${index + 1}'] == 'Clothing'
                                  ? Icons.accessibility_new
                                  : planDoc[0]['prio${index + 1}'] == 'Travel'
                                      ? Icons.explore
                                      : Icons.create,
                          size: 30,
                          color: planDoc[0]['prio${index + 1}'] == 'Food'
                              ? const Color.fromRGBO(75, 135, 185, 1)
                              : planDoc[0]['prio${index + 1}'] == 'Clothing'
                                  ? const Color.fromRGBO(246, 114, 128, 1)
                                  : planDoc[0]['prio${index + 1}'] == 'Travel'
                                      ? const Color.fromRGBO(192, 108, 132, 1)
                                      : const Color.fromRGBO(248, 177, 149, 1),
                        ),
                        // title: Text(
                        //   planDoc[0]['prio${index + 1}'] == 'Food'
                        //       ? 'Plan meals ahead & cook at home to save money. Let\'s skip frequent eating out or food delivery.'
                        //       : planDoc[0]['prio${index + 1}'] == 'Clothing'
                        //           ? 'You can opt to buy second-hand clothes or buy only essentials if you do not require new clothes.'
                        //           : planDoc[0]['prio${index + 1}'] == 'Travel'
                        //               ? 'Let\'s cover transportation costs (bus/metro fares) and small travel expenses. Be smart, plan ahead!'
                        //               : 'Cover personal care items, phone recharge & small purchases. Plan ahead, make it count!',
                        //   style: const TextStyle(
                        //     color: Color.fromARGB(255, 26, 45, 26),
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                        title: Text(
                          planDoc[0]['prio${index + 1}'] == 'Food'
                              ? 'Food budget = ₹${planDoc[0]['prio${index + 1}Expense']}'
                              : planDoc[0]['prio${index + 1}'] == 'Clothing'
                                  ? 'Clothing budget = ₹${planDoc[0]['prio${index + 1}Expense']}'
                                  : planDoc[0]['prio${index + 1}'] == 'Travel'
                                      ? 'Travel budget = ₹${planDoc[0]['prio${index + 1}Expense']}'
                                      : 'Miscellaneous budget = ₹${planDoc[0]['prio${index + 1}Expense']}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 68, 113, 69),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          planDoc[0]['prio${index + 1}'] == 'Food'
                              ? '₹${(planDoc[0]['prio${index + 1}Expense'] / 30).round()}/day'
                              : planDoc[0]['prio${index + 1}'] == 'Clothing'
                                  ? '₹${(planDoc[0]['prio${index + 1}Expense'] / 30).round()}/day'
                                  : planDoc[0]['prio${index + 1}'] == 'Travel'
                                      ? '₹${(planDoc[0]['prio${index + 1}Expense'] / 30).round()}/day'
                                      : '₹${(planDoc[0]['prio${index + 1}Expense'] / 30).round()}/day',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 103, 173, 105),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
