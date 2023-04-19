import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatefulWidget {
  String heading;
  TransactionsList(this.heading, {Key? key}) : super(key: key);

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final user = FirebaseAuth.instance.currentUser;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Transactions',
            style: TextStyle(
              color: Color.fromARGB(255, 74, 74, 74),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(
          height: screenH / 3.1,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(user!.uid)
                .collection('transaction')
                .orderBy('creationTime', descending: true)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final Doc = snapshot.data!.docs;
              return Doc.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.hourglass_empty,
                            size: 90,
                            color: Color.fromARGB(255, 82, 82, 82),
                          ),
                          Text('No Transactions yet!'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: Doc.length,
                      itemBuilder: ((context, index) {
                        print(snapshot.data!.docs);
                        var createDate = DateFormat('dd-MMM-yy ~ HH:mm')
                            .format(Doc[index]['creationTime'].toDate());
                        return Card(
                          elevation: 7,
                          child: ListTile(
                            leading: Icon(
                              Doc[index]['reason'] == null
                                  ? Icons.wallet
                                  : Doc[index]['reason'] == 'Food'
                                      ? Icons.food_bank
                                      : Doc[index]['reason'] == 'Clothing'
                                          ? Icons.store
                                          : Doc[index]['reason'] ==
                                                  'Miscellaneous'
                                              ? Icons.store
                                              : Icons.travel_explore,
                              size: 35,
                              color: const Color.fromARGB(255, 74, 74, 74),
                            ),
                            title: Text(
                              Doc[index]['To'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 74, 74, 74),
                              ),
                            ),
                            subtitle: Text(createDate),
                            trailing: Text(
                              '${Doc[index]['reason'] == null ? '+' : '-'}₹${Doc[index]['amount']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Color.fromARGB(255, 74, 74, 74),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
            },
          ),
        ),
      ],
    );
  }
}
