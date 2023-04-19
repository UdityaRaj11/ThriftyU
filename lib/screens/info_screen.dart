import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thriftyu/screens/make_plan_screen.dart';
import 'package:thriftyu/widgets/custom_appbar.dart';
import 'package:thriftyu/widgets/plan/plan_container.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);
  static const routeName = '/info-screen';

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  bool? planDataFound;

  Future<bool> getPlan() async {
    bool found = false;
    final user = FirebaseAuth.instance.currentUser;
    final plan = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('plans')
        .get();
    return plan.docs.isNotEmpty ? found = true : found;
  }

  @override
  void initState() {
    super.initState();
    getPlan().then(
      (value) {
        setState(() {
          planDataFound = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 37, 44),
      body: Column(
        children: [
          const CustomAppBar(),
          planDataFound == false
              ? Container(
                  height: screenH / 1.4,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wallet_membership_outlined,
                        size: 200,
                        color: Color.fromARGB(255, 141, 141, 141),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Want to create a new spending plan together? Let\'s align it with your goals and take control of your finances.',
                        style: TextStyle(
                          color: Color.fromARGB(255, 111, 111, 111),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            MakePlanScreen.routeName,
                          );
                        },
                        child: const Text('Let\'s Go!'),
                      )
                    ],
                  ),
                )
              : const PlanContainer()
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        extendedIconLabelSpacing: 2,
        extendedPadding: const EdgeInsets.all(5),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          Navigator.of(context).pushNamed(MakePlanScreen.routeName);
        },
        icon: const Icon(Icons.create_new_folder),
        label: const Text('Create New'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
