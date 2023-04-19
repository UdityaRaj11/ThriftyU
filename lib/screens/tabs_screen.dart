import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thriftyu/screens/home_screen.dart';
import 'package:thriftyu/screens/info_screen.dart';
import 'package:thriftyu/screens/make_plan_screen.dart';
import 'package:thriftyu/screens/wallet_screen.dart';
import '/screens/splash_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  String? userImageUrl;
  String? userName;
  bool userComplete = true;
  Future<String> fetchImageUrl() async {
    String imageUrl;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    imageUrl = userData['image_url'];
    return imageUrl;
  }

  Future<String> fetchUsername() async {
    String username;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    username = userData['username'];
    return username;
  }

  List<Object> _pages = [];
  @override
  void initState() {
    super.initState();
    fetchImageUrl().then((value) {
      setState(() {
        userImageUrl = value;
      });
    });
    fetchUsername().then((value) {
      setState(() {
        userName = value;
      });
    });
    _pages = [
      const HomeScreen(),
      const WalletScreen(),
      const InfoScreen(),
      const SplashScreen(),
    ];
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
        var userdata = userSnapshot.data;
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        return Scaffold(
          body: _pages[_selectedPageIndex] as Widget,
          bottomNavigationBar: BottomNavigationBar(
            elevation: 7,
            onTap: _selectPage,
            backgroundColor: const Color.fromARGB(255, 29, 37, 44),
            unselectedItemColor: const Color.fromARGB(255, 152, 152, 152),
            selectedItemColor: const Color.fromARGB(255, 245, 245, 245),
            selectedFontSize: 20,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            currentIndex: _selectedPageIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(Icons.account_balance_wallet_outlined),
                activeIcon: const Icon(
                  Icons.money_rounded,
                ),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(Icons.query_stats),
                activeIcon: const Icon(
                  Icons.search,
                ),
                label: 'Info',
              ),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(
                  Icons.notifications_none_outlined,
                ),
                activeIcon: const Icon(
                  Icons.notifications_active,
                ),
                label: 'Notification',
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
