import 'package:flutter/material.dart';
import 'package:thriftyu/screens/tabs_screen.dart';

class TransferCompleteScreen extends StatelessWidget {
  const TransferCompleteScreen({Key? key}) : super(key: key);

  static const routeName = '/success-screen';

  @override
  Widget build(BuildContext context) {
    final userBalance = ModalRoute.of(context)!.settings.arguments as int;
    final screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 44, 48),
      body: SizedBox(
        width: screenW,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Transfer Successfull!',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            Text(
              '\₹${userBalance} Added',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      TabsScreen.routeName, (route) => false);
                },
                child: const Text('Go to Home'))
          ],
        ),
      ),
    );
  }
}
