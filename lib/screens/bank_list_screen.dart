import 'package:flutter/material.dart';

class BankListScreen extends StatelessWidget {
  const BankListScreen({Key? key}) : super(key: key);

  static const routeName = '/bank-list';

  @override
  Widget build(BuildContext context) {
    final balance = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select bank'),
          backgroundColor: const Color.fromARGB(255, 38, 44, 48),
        ),
        backgroundColor: const Color.fromARGB(255, 38, 44, 48),
        body: Column(
          children: [
            InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed('/add-money', arguments: balance),
              child: const Card(
                color: Color.fromARGB(255, 47, 54, 59),
                child: ListTile(
                    title: Text(
                  'Bank Of India',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                '/add-money',
                arguments: balance,
              ),
              child: const Card(
                color: Color.fromARGB(255, 47, 54, 59),
                child: ListTile(
                    title: Text(
                  'State Bank of India',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                '/add-money',
                arguments: balance,
              ),
              child: const Card(
                color: Color.fromARGB(255, 47, 54, 59),
                child: ListTile(
                    title: Text(
                  'Punjab National Bank',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          ],
        ));
  }
}
