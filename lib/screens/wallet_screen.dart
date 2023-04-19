import 'package:flutter/material.dart';
import 'package:thriftyu/widgets/custom_appbar.dart';
import 'package:thriftyu/widgets/wallet/thrifty_card.dart';
import 'package:thriftyu/widgets/wallet/transactions_data.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 44, 48),
      body: Column(
        children: const [
          CustomAppBar(),
          ThriftyCard(),
          TransactionsData(),
        ],
      ),
    );
  }
}
