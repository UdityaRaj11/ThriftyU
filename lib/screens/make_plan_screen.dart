import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thriftyu/screens/info_screen.dart';
import 'package:thriftyu/screens/tabs_screen.dart';

class MakePlanScreen extends StatefulWidget {
  const MakePlanScreen({Key? key}) : super(key: key);

  static const routeName = '/make-plan';

  @override
  State<MakePlanScreen> createState() => _MakePlanScreenState();
}

class _MakePlanScreenState extends State<MakePlanScreen> {
  int? walletBalance;
  DateTime? _selectedDate;
  Future<int> fetchBalance() async {
    int balance;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    balance = userData['balance'];
    return balance;
  }

  void createPlan(
    DateTime lastdata,
    String prio1,
    int prio1Expense,
    String prio2,
    int prio2Expense,
    String prio3,
    int prio3Expense,
    String prio4,
    int prio4Expense,
  ) async {
    final time = DateTime.now();
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('plans')
        .add({
      'creationTime': time,
      'ExpireDate': lastdata,
      'totalExpense': walletBalance,
      'prio1': prio1,
      'prio1Expense': prio1Expense,
      'prio1Spent': 0,
      'prio2': prio2,
      'prio2Expense': prio2Expense,
      'prio2Spent': 0,
      'prio3': prio3,
      'prio3Expense': prio3Expense,
      'prio3Spent': 0,
      'prio4': prio4,
      'prio4Expense': prio4Expense,
      'prio4Spent': 0,
    });
    final docId = FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .collection('track')
        .doc();
    docId.set({
      'creationTime': time,
      'totalBudget': walletBalance,
      'foodBudget': prio1 == 'Food'
          ? prio1Expense
          : prio2 == 'Food'
              ? prio2Expense
              : prio3 == 'Food'
                  ? prio3Expense
                  : prio4Expense,
      'spentFood': 0,
      'travelBudget': prio1 == 'Travel'
          ? prio1Expense
          : prio2 == 'Travel'
              ? prio2Expense
              : prio3 == 'Travel'
                  ? prio3Expense
                  : prio4Expense,
      'spentTravel': 0,
      'miscellaneousBudget': prio1 == 'Miscellaneous'
          ? prio1Expense
          : prio2 == 'Miscellaneous'
              ? prio2Expense
              : prio3 == 'Miscellaneous'
                  ? prio3Expense
                  : prio4Expense,
      'spentMiscellaneous': 0,
      'clothingBudget': prio1 == 'Clothing'
          ? prio1Expense
          : prio2 == 'Clothing'
              ? prio2Expense
              : prio3 == 'Clothing'
                  ? prio3Expense
                  : prio4Expense,
      'spentClothing': 0,
    });
    final docref = docId.id;
    final data = {'activePlanDocId': docref};
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .set(data, SetOptions(merge: true));
  }

  List<double> balancePartion = [];
  List<double> calculatePartition(int total) {
    List<double> amounts = [0, 0, 0, 0];
    amounts[0] = total * 0.6;
    amounts[1] = total * 0.2;
    amounts[2] = total * 0.15;
    amounts[3] = total * 0.05;
    return amounts;
  }

  void _presentDatePicker() async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2028),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(
          () {
            _selectedDate = pickedDate;
          },
        );
      },
    );
  }

  List<String> myPrio = [];
  List<String> initMyPrio = [];
  final List<String> reasonList = [
    'Food',
    'Clothing',
    'Travel',
    'Miscellaneous',
  ];
  @override
  void initState() {
    super.initState();
    fetchBalance().then((value) {
      setState(() {
        walletBalance = value;
        balancePartion = calculatePartition(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    if (initMyPrio.length <= 4) {
      setState(() {
        myPrio = initMyPrio;
      });
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 37, 44),
      body: Container(
        height: screenH,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Your money, your call! Let\'s talk about your goals and spending...',
              style: TextStyle(
                  color: Color.fromARGB(255, 239, 239, 239),
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Your priorites: ',
              style: TextStyle(
                  color: Color.fromARGB(255, 190, 190, 190),
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            Row(children: [
              Card(
                elevation: 7,
                color: const Color.fromARGB(255, 19, 24, 29),
                child: Container(
                  height: screenH / 5.6,
                  width: screenW / 2.2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 0),
                      itemCount: myPrio.length,
                      itemBuilder: (ctx, index) {
                        return Card(
                          color: const Color.fromARGB(255, 97, 123, 147),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Text(
                                  '${index + 1}.',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  myPrio[index],
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
              SizedBox(
                height: screenH / 2,
                width: screenW / 2.2,
                child: Column(children: [
                  const Text(
                    'Choose in order:',
                    style: TextStyle(
                        color: Color.fromARGB(255, 124, 124, 124),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    children: reasonList.map(
                      (reason) {
                        bool isSelected = false;
                        if (initMyPrio.contains(reason)) {
                          isSelected = true;
                        }
                        return GestureDetector(
                          onTap: () {
                            if (!initMyPrio.contains(reason)) {
                              if (initMyPrio.length < 5) {
                                initMyPrio.add(reason);
                                setState(() {});
                              }
                            } else {
                              initMyPrio.remove(reason);
                              setState(() {});
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 41, 41, 41),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                      color: isSelected
                                          ? Colors.green
                                          : const Color.fromARGB(
                                              255, 86, 121, 146),
                                      width: 2)),
                              child: Text(
                                reason,
                                style: TextStyle(
                                    color: isSelected
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 86, 121, 146),
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ]),
              ),
            ]),
            const Text(
              'How long do you want your current Balance to last?',
              style: TextStyle(
                  color: Color.fromARGB(255, 167, 167, 167),
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            TextButton(
              onPressed: _presentDatePicker,
              child: const Text(
                'Pick Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedDate != null && myPrio.length == 4) {
                    createPlan(
                      _selectedDate!,
                      myPrio[0],
                      balancePartion[0].toInt(),
                      myPrio[1],
                      balancePartion[1].toInt(),
                      myPrio[2],
                      balancePartion[2].toInt(),
                      myPrio[3],
                      balancePartion[3].toInt(),
                    );
                  }
                  Navigator.of(context)
                      .popAndPushNamed(TabsScreen.routeName, arguments: 2);
                },
                child: const Text('Show Plan'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
