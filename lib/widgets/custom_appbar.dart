import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
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
  }

  @override
  Widget build(BuildContext context) {
    final ScreenH = MediaQuery.of(context).size.height;
    final ScreenW = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
        top: ScreenH / 16,
        left: 10,
        right: 10,
        bottom: ScreenH / 70,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () {
                // Navigator.of(context).pushNamed('/profile-detail');
              },
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  userImageUrl.toString(),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                userName.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          DropdownButton(
            underline: Container(),
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).popAndPushNamed('/auth-screen');
              }
            },
          ),
        ],
      ),
    );
  }
}
