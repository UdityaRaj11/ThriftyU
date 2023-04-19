import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thriftyu/widgets/custom_appbar.dart';
import 'package:thriftyu/widgets/plan/expense_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? userBalance;
  Future<int> fetchbalance() async {
    int balance;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    balance = userData['balance'];
    return balance;
  }

  @override
  void initState() {
    super.initState();
    fetchbalance().then((value) {
      setState(() {
        userBalance = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 44, 48),
      body: Column(
        children: [
          const CustomAppBar(),
          Stack(
            children: [
              userBalance == 0
                  ? Positioned(
                      left: screenW / 3,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/bank-list', arguments: userBalance);
                        },
                        child: const Text('Add to Wallet'),
                      ),
                    )
                  : Container(
                      color: const Color.fromARGB(255, 25, 29, 31),
                      height: screenH / 7,
                      width: screenW,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('tips')
                            .snapshots(),
                        builder: (ctx, tipSnapshot) {
                          if (tipSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final tipDoc = tipSnapshot.data!.docs;
                          final docLength = tipDoc.length;
                          Random random = Random();
                          int index = random.nextInt(docLength);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Qucik Tip: ',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                  const Divider(
                                    height: 5,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    tipDoc[index]['tip'],
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 224, 224, 224),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ]),
                          );
                        },
                      ),
                    ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 105, 136, 106),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                margin: EdgeInsets.only(top: screenH / 7),
                height: screenH / 1.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text(
                        'My Balance',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 228, 228, 228),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        userBalance == 0 ? 'Wallet Empty' : '\₹${userBalance}',
                        style: TextStyle(
                            fontSize: 20,
                            color: userBalance == 0
                                ? const Color.fromARGB(255, 43, 43, 43)
                                : const Color.fromARGB(255, 245, 245, 245),
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(
                        Icons.more_horiz_outlined,
                        color: Color.fromARGB(255, 249, 249, 249),
                      ),
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 91, 117, 92),
                    ),
                    SizedBox(
                      width: screenW,
                      height: screenH / 3.5,
                      child: GridView(
                        padding: const EdgeInsets.all(0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('/bank-list',
                                  arguments: userBalance);
                            },
                            child: const ListTile(
                              title: Icon(Icons.attach_money,
                                  size: 35, color: Colors.white),
                              subtitle: Text(
                                'Add to Thrifty',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('/qr-view');
                            },
                            child: const ListTile(
                              title: Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 35,
                              ),
                              subtitle: Text(
                                'Scan',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ),
                          ),
                          const ListTile(
                            title: Icon(Icons.person,
                                size: 35, color: Colors.white),
                            subtitle: Text(
                              'ThriftyID',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                          const ListTile(
                            title:
                                Icon(Icons.add, size: 35, color: Colors.white),
                            subtitle: Text(
                              'Top Up',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                          const ListTile(
                            title: Icon(Icons.phone_android,
                                size: 35, color: Colors.white),
                            subtitle: Text(
                              'Phone Bill',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                          const ListTile(
                            title: Icon(Icons.explore,
                                size: 35, color: Colors.white),
                            subtitle: Text(
                              'More',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 237, 237, 237),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                margin: EdgeInsets.only(top: screenH / 1.93),
                height: screenH / 3.9,
                width: screenW,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 20),
                      width: screenW,
                      child: const Text(
                        'Expense Status',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 74, 74, 74),
                        ),
                      ),
                    ),
                    const Divider(),
                    const ExpenseStatus(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
