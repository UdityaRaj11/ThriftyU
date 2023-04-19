import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TransfersList extends StatefulWidget {
  String heading;
  TransfersList(this.heading, {Key? key}) : super(key: key);

  @override
  State<TransfersList> createState() => _TransfersListState();
}

class _TransfersListState extends State<TransfersList> {
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
                .where('To', isEqualTo: 'Thrifty Wallet')
                .orderBy('creationTime', descending: true)
                .snapshots(),
            builder: (ctx, tfsnapshot) {
              if (tfsnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final Doc = tfsnapshot.data!.docs;
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
                        print(tfsnapshot.data!.docs);
                        var createDate = DateFormat('dd-MMM-yy ~ HH:mm')
                            .format(Doc[index]['creationTime'].toDate());
                        return Card(
                          elevation: 7,
                          child: ListTile(
                            leading: const Icon(
                              Icons.wallet,
                              size: 35,
                              color: Color.fromARGB(255, 74, 74, 74),
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
                              '+₹${Doc[index]['amount']}',
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
