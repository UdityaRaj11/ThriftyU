import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter/material.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({Key? key}) : super(key: key);

  static const routeName = '/enter-pin';

  @override
  State<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  int? pin;
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final userBalance = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
        backgroundColor: const Color.fromARGB(255, 38, 44, 48),
      ),
      backgroundColor: const Color.fromARGB(255, 38, 44, 48),
      body: InkWell(
        onTap: () => Navigator.of(context).pushNamed(''),
        child: Card(
          color: const Color.fromARGB(255, 37, 37, 37),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter your pin:',
                    style: TextStyle(color: Colors.white),
                  ),
                  PinCodeFields(
                    fieldBorderStyle: FieldBorderStyle.topBottom,
                    fieldBackgroundColor: const Color.fromARGB(255, 62, 62, 62),
                    fieldHeight: 50,
                    obscureText: true,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 40),
                    length: 4,
                    onComplete: (output) {
                      print(output);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _key.currentState!.save();
                      Navigator.of(context)
                          .pushNamed('/success-screen', arguments: userBalance);
                    },
                    child: const Text('Done'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
