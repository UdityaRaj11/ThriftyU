import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({Key? key}) : super(key: key);

  static const routeName = '/add-money';

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  int? newBalance;
  final GlobalKey<FormState> _key = GlobalKey();
  Future<void> setNewBalance(int newBalance) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
      'balance': newBalance,
    });
  }

  String? activetrackId;
  Future<void> addTransaction(
      int amount, String? reason, String to, String type) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('transaction')
        .add({
      'creationTime': Timestamp.now(),
      'amount': amount,
      'To': to,
      'reason': reason,
    });
    if (to == 'someone') {
      fetchtrackId().then((value) {
        final user = FirebaseAuth.instance.currentUser;
        FirebaseFirestore.instance
            .collection('user')
            .doc(user!.uid)
            .collection('track')
            .doc(value)
            .get()
            .then((value1) {
          final data = {'spent$reason': value1['spent$reason'] + amount};
          FirebaseFirestore.instance
              .collection('user')
              .doc(user.uid)
              .collection('track')
              .doc(value)
              .set(data, SetOptions(merge: true));
        });
      });
    }
  }

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

  int? myBalance;
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
    fetchtrackId().then(
      (value1) {
        fetchbalance().then((value) {
          setState(() {
            myBalance = value;
            activetrackId = value1;
          });
        });
      },
    );
  }

  String choice = '';
  String _selectedChoice = '';
  final List<String> reasonList = [
    'Food',
    'Clothing',
    'Travel',
    'Miscellaneous',
  ];

  @override
  Widget build(BuildContext context) {
    final userBalance = ModalRoute.of(context)!.settings.arguments as int;
    if (_selectedChoice.length == 1) {
      setState(() {
        choice = _selectedChoice;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Amount'),
        backgroundColor: const Color.fromARGB(255, 38, 44, 48),
      ),
      backgroundColor: const Color.fromARGB(255, 38, 44, 48),
      body: InkWell(
        onTap: () => Navigator.of(context).pushNamed(''),
        child: Card(
          color: const Color.fromARGB(255, 38, 44, 48),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Amount:',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    onSaved: (value) {
                      setState(() {
                        newBalance = int.parse(value.toString());
                      });
                    },
                  ),
                  if (userBalance == -1)
                    const Text(
                      'Select a reason:',
                      style: TextStyle(color: Colors.white),
                    ),
                  if (userBalance == -1)
                    Wrap(
                      children: reasonList.map(
                        (reason) {
                          bool isSelected = false;
                          if (_selectedChoice.contains(reason)) {
                            isSelected = true;
                          }
                          return GestureDetector(
                            onTap: () {
                              if (!_selectedChoice.contains(reason)) {
                                if (_selectedChoice.length < 5) {
                                  _selectedChoice = reason;
                                  setState(() {});
                                }
                              } else {
                                _selectedChoice = '';
                                setState(() {});
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 41, 41, 41),
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
                  ElevatedButton(
                    onPressed: () {
                      _key.currentState!.save();
                      if (userBalance != -1) {
                        setNewBalance(newBalance! + userBalance);
                        addTransaction(
                            newBalance!, null, 'Thrifty Wallet', 'transfer');
                        Navigator.of(context)
                            .pushNamed('/enter-pin', arguments: newBalance!);
                      } else if (myBalance! > 0 && myBalance! >= newBalance!) {
                        setNewBalance(myBalance! - newBalance!);
                        addTransaction(
                            newBalance!, _selectedChoice, 'someone', 'payment');
                        Navigator.of(context)
                            .pushNamed('/enter-pin', arguments: newBalance!);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('You have Insufficiant balance'),
                        ));
                      }
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
