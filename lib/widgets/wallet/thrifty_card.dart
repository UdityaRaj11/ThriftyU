import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ThriftyCard extends StatefulWidget {
  const ThriftyCard({Key? key}) : super(key: key);

  @override
  State<ThriftyCard> createState() => _ThriftyCardState();
}

class _ThriftyCardState extends State<ThriftyCard> {
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
    return Container(
      margin: EdgeInsets.only(top: screenH / 20),
      width: screenW / 1.12,
      child: Card(
        shadowColor: const Color.fromARGB(255, 78, 139, 79),
        color: const Color.fromARGB(255, 105, 136, 106),
        elevation: 7,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: const [
                  Text(
                    'Thrifty',
                    style: TextStyle(letterSpacing: 2, color: Colors.white),
                  ),
                  Spacer(),
                  Icon(
                    Icons.wifi,
                    color: Color.fromARGB(255, 39, 68, 40),
                  ),
                ],
              ),
              SizedBox(
                height: screenH / 25,
              ),
              const Text(
                '**** **** 2456',
                style: TextStyle(
                  letterSpacing: 3,
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Balance',
                        style: TextStyle(
                          letterSpacing: 2,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '\₹${userBalance}',
                        style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: screenH / 80,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Exp. 5/23',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
