import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thriftyu/widgets/wallet/payments_list.dart';
import 'package:thriftyu/widgets/wallet/transactions_list.dart';
import 'package:thriftyu/widgets/wallet/transfers_list.dart';

class TransactionsData extends StatefulWidget {
  const TransactionsData({Key? key}) : super(key: key);

  @override
  State<TransactionsData> createState() => _TransactionsDataState();
}

class _TransactionsDataState extends State<TransactionsData> {
  String heading = 'Transactions';
  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: screenH / 13.1,
          ),
          height: screenH / 2.4,
          width: screenW,
          color: const Color.fromARGB(255, 237, 237, 237),
          child: Container(
            margin: EdgeInsets.only(
              top: screenH / 30,
            ),
            child: heading == 'Transactions'
                ? TransactionsList(heading)
                : heading == 'Transfers'
                    ? TransfersList(heading)
                    : PaymentsList(heading),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenW / 8, vertical: 20),
          width: screenW / 1.3,
          height: screenH / 14,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 93, 93, 93),
                offset: Offset(5.0, 5.0),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ),
            ],
            color: Color.fromARGB(255, 242, 242, 242),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () => setState(() {
                  heading = 'Transactions';
                }),
                child: Row(
                  children: [
                    Text(
                      'All',
                      style: TextStyle(
                        fontSize: heading == 'Transactions' ? 19 : 13,
                        color: heading == 'Transactions'
                            ? const Color.fromARGB(255, 37, 37, 37)
                            : const Color.fromARGB(255, 112, 112, 112),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              InkWell(
                onTap: () => setState(() {
                  heading = 'Payments';
                }),
                child: Row(
                  children: [
                    Icon(
                      Icons.payment_outlined,
                      color: heading == 'Payments'
                          ? const Color.fromARGB(255, 37, 37, 37)
                          : const Color.fromARGB(255, 112, 112, 112),
                      size: heading == 'Payments' ? 19 : 13,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Payments',
                      style: TextStyle(
                        fontSize: heading == 'Payments' ? 19 : 13,
                        color: heading == 'Payments'
                            ? const Color.fromARGB(255, 37, 37, 37)
                            : const Color.fromARGB(255, 112, 112, 112),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              InkWell(
                onTap: () => setState(() {
                  heading = 'Transfers';
                }),
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      color: heading == 'Transfers'
                          ? const Color.fromARGB(255, 37, 37, 37)
                          : const Color.fromARGB(255, 112, 112, 112),
                      size: heading == 'Transfers' ? 19 : 13,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Transfer',
                      style: TextStyle(
                        fontSize: heading == 'Transfers' ? 19 : 13,
                        color: heading == 'Transfers'
                            ? const Color.fromARGB(255, 37, 37, 37)
                            : const Color.fromARGB(255, 112, 112, 112),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
