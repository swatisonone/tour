import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tour/features/chatbot.dart';
import 'package:tour/ocr.dart';
import 'package:tour/screens/Home_page.dart';
import 'package:tour/screens/feeds.dart';
import 'package:tour/screens/history.dart';
import 'package:tour/screens/profile.dart';
import 'package:tour/screens/screens/feedback.dart';
import 'package:tour/screens/screens/list_posts.dart';
import 'package:tour/utils/firebase.dart';

import '../models/user.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.initialTabIndex});

  final String title;
  final int initialTabIndex;

  @override
  State<MyHomePage> createState() =>
      _MyHomePageState(initialTabIndex: initialTabIndex);
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController? animationController;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    print('--------------------$user----------------------');
    super.initState();
    usersRef.doc(user?.uid).get().then((value) {
      this.loggedInUser = UserModel.fromJson(
        value.data() as Map<String, dynamic>,
      );
      setState(() {});
    });
    _currentIndex = widget.initialTabIndex;
  }

  int _currentIndex = 0;

  _MyHomePageState({required this.initialTabIndex});

  final int initialTabIndex;

  // @override
  // void initState() {
  //   super.initState();
  //   _currentIndex = widget.initialTabIndex;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavigationDrawer(children: [],),
      appBar: _buildAppBar(),
      endDrawer: Drawer(),
      body: _buildTabContent(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      // floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
  return AppBar(
    backgroundColor: Color.fromARGB(255, 240, 227, 139).withOpacity(0.4), // Adjust the opacity as needed
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20.0), // Adjust the radius for rounded corners
      ),
    ),
    title: Row(
      children: [
        Text('Hello ${loggedInUser.username}!!'),
        Spacer(),
      ],
    ),
    actions: [
      IconButton(
        icon: CircleAvatar(
          radius: 20.0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Center(
            child: Text(
              loggedInUser.username![0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => Profile(profileId: loggedInUser.id),
            ),
          );
        },
      ),
      IconButton(
        icon: CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.feedback,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedbackScreen(),
            ),
          );
        },
      ),
    ],
  );
}


  Widget _buildTabContent() {
    switch (_currentIndex) {
      case 0:
        return MyHomeScreen();
      case 1:
        return ChatScreen();
      case 2:
        return IndianLanguageOCR(title: "translator");
      case 3:
        return Feeds();
      case 4:
        return OCRResultsPage();
      default:
        return Container();
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      selectedItemColor: Color.fromARGB(255, 245, 118, 109),
      unselectedItemColor: Color.fromARGB(255, 113, 112, 112),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chatbot',
        ),
        BottomNavigationBarItem(
          icon: Container(
            transform: Matrix4.translationValues(0.0, -10.0, 0.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 4,
                  blurRadius: 15,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.grey.shade300,
              child: CircleAvatar(
                radius: 35.0,
                foregroundImage: AssetImage('assets/images/scanner.png'),
              ),
            ),
          ),
          label: '', // Set an empty string to remove the label
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'History',
        ),
      ],
      selectedFontSize: 15.0,
      unselectedFontSize: 15.0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 15.0,
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
