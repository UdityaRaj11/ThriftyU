import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thriftyu/modal/user.dart';
import 'package:thriftyu/providers/user_provider.dart';
import 'package:thriftyu/screens/add_money_screen.dart';
import 'package:thriftyu/screens/auth_screen.dart';
import 'package:thriftyu/screens/bank_list_screen.dart';
import 'package:thriftyu/screens/enter_pin_screen.dart';
import 'package:thriftyu/screens/home_screen.dart';
import 'package:thriftyu/screens/info_screen.dart';
import 'package:thriftyu/screens/make_plan_screen.dart';
import 'package:thriftyu/screens/qr_view.dart';
import 'package:thriftyu/screens/splash_screen.dart';
import 'package:thriftyu/screens/tabs_screen.dart';
import 'package:thriftyu/screens/transactions_complete_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? authUser = FirebaseAuth.instance.currentUser;
    if (authUser != null) {
      UserProvider userProvider = UserProvider();
      userProvider.setUser(authUser.uid);
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        )
      ],
      child: Consumer<UserProvider>(
        builder: (context, value, _) => MaterialApp(
          title: 'ThriftyU',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (userSnapshot.hasData) {
                return TabsScreen();
              }
              return const AuthScreen();
            },
          ),
          routes: {
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            AuthScreen.routeName: (ctx) => const AuthScreen(),
            AddMoneyScreen.routeName: (ctx) => const AddMoneyScreen(),
            EnterPinScreen.routeName: (ctx) => const EnterPinScreen(),
            QRViewExample.routeName: (ctx) => const QRViewExample(),
            TransferCompleteScreen.routeName: (ctx) =>
                const TransferCompleteScreen(),
            BankListScreen.routeName: (ctx) => const BankListScreen(),
            MakePlanScreen.routeName: (ctx) => const MakePlanScreen(),
            TabsScreen.routeName: (ctx) => TabsScreen(),
            InfoScreen.routeName: (ctx) => const InfoScreen(),
          },
        ),
      ),
    );
  }
}
